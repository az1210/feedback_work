import 'dart:io';
import 'package:feedback_work/core/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  final String projectId;
  const SettingsScreen({super.key, required this.projectId});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController finishDateController = TextEditingController();
  final TextEditingController breakTimeController = TextEditingController();
  final TextEditingController travelHourController = TextEditingController();
  final TextEditingController audioController = TextEditingController();
  final TextEditingController popupTextController = TextEditingController();

  String? uploadedAudioUrl;
  bool isLoading = true;
  bool isValidDate(String input, String pattern) {
    try {
      DateFormat(pattern).parseStrict(input);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchSettings();
  }

  Future<void> _fetchSettings() async {
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('projects')
          .select('solution_function_settings')
          .eq('id', widget.projectId)
          .single();

      if (response['solution_function_settings'] != null) {
        final data = response['solution_function_settings'];
        setState(() {
          startDateController.text = data['startTime'] != null
              ? DateFormat('MM/dd/yyyy at hh:mm a')
                  .format(DateTime.parse(data['startTime']))
              : '';

          finishDateController.text = data['endTime'] != null
              ? DateFormat('MM/dd/yyyy at hh:mm a')
                  .format(DateTime.parse(data['endTime']))
              : '';

          breakTimeController.text = data['breakTime'] != null
              ? DateFormat('MM/dd/yyyy at hh:mm a')
                  .format(DateTime.parse(data['breakTime']))
              : '';

          travelHourController.text = data['travelPerHour']?.toString() ?? '';
          audioController.text = data['audioUrl'] ?? '';
          uploadedAudioUrl = data['audioUrl'];
          popupTextController.text = data['popupText'] ?? '';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch settings: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveSettings() async {
    try {
      formKey.currentState!.save();
      if (formKey.currentState!.validate()) {
        final DateFormat dateFormat = DateFormat('MM/dd/yyyy at hh:mm a');

        final startTime =
            dateFormat.parseStrict(startDateController.text.trim());
        final endTime =
            dateFormat.parseStrict(finishDateController.text.trim());
        final breakTime =
            dateFormat.parseStrict(breakTimeController.text.trim());
        final travelPerHour =
            double.tryParse(travelHourController.text.trim()) ?? 0.0;
        final popupText = popupTextController.text.trim();
        final audioUrl = uploadedAudioUrl ?? '';

        final settingsData = {
          'startTime': startTime.toIso8601String(),
          'endTime': endTime.toIso8601String(),
          'breakTime': breakTime.toIso8601String(),
          'travelPerHour': travelPerHour,
          'audioUrl': audioUrl,
          'popupText': popupText,
        };

        final supabase = Supabase.instance.client;
        await supabase
            .from('projects')
            .update({'solution_function_settings': settingsData}).eq(
                'id', widget.projectId);

        final projectId = widget.projectId;
        context.push('/solution-function/$projectId');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Settings saved successfully!")),
        );
      }
    } on FormatException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid date format. Please re-enter.")),
      );
      debugPrint("FormatException: ${e.message}");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save settings: $e")),
      );
      debugPrint("Exception: $e");
    }
  }

  Future<void> uploadAudioFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      final filePath = result.files.single.path!;
      final fileName = result.files.single.name;

      try {
        final file = File(filePath);
        final supabase = Supabase.instance.client;
        await supabase.storage.from('audio').upload(fileName, file);
        uploadedAudioUrl =
            supabase.storage.from('audio').getPublicUrl(fileName);

        audioController.text = fileName;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Audio file uploaded successfully!")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to upload audio file: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 242, 245),
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: saveSettings,
            icon: const Icon(
              Icons.save,
              color: Color.fromARGB(255, 8, 102, 255),
            ),
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const SizedBox(height: 19),
            _buildTimePicker(context, "Start Time/Date", startDateController),
            const SizedBox(height: 16),
            _buildTimePicker(context, "Finish Time/Date", finishDateController),
            const SizedBox(height: 16),
            _buildTimePicker(context, "Break Time/Date", breakTimeController),
            const SizedBox(height: 16),
            _buildSlider(
              "Percentage Completed per Hour",
              travelHourController,
              min: 10.0,
              max: 100.0,
              divisions: 18,
            ),
            const SizedBox(height: 16),
            _buildFilePicker(
                context, "Beep Audio", audioController, uploadAudioFile),
            const SizedBox(height: 16),
            _buildPopupTextFormField(
                context, "Popup Text", popupTextController),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker(
    BuildContext context,
    String label,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "Select Date",
            hintStyle: Theme.of(context).textTheme.bodySmall,
            filled: true,
            fillColor: Colors.white,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide.none,
            ),
          ),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (date != null && time != null) {
              final dateFormat = DateFormat('MM/dd/yyyy at hh:mm a');
              controller.text = dateFormat.format(
                DateTime(
                  date.year,
                  date.month,
                  date.day,
                  time.hour,
                  time.minute,
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildFilePicker(
    BuildContext context,
    String label,
    TextEditingController controller,
    Function onFileSelected,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "Attach Audio File",
            hintStyle: Theme.of(context).textTheme.bodySmall,
            filled: true,
            fillColor: Colors.white,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.attach_file),
              onPressed: () => onFileSelected(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPopupTextFormField(
    BuildContext context,
    String label,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "Enter Popup Text",
            hintStyle: Theme.of(context).textTheme.bodySmall,
            filled: true,
            fillColor: Colors.white,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) => validateInput(value, fieldName: 'Popup Text'),
        ),
      ],
    );
  }

  Widget _buildSlider(
    String label,
    TextEditingController controller, {
    required double min,
    required double max,
    required int divisions,
  }) {
    final currentValue = double.tryParse(controller.text) ?? min;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 5),
        Slider(
          activeColor: const Color.fromARGB(255, 8, 102, 255),
          inactiveColor: Colors.grey.shade300,
          value: currentValue,
          min: min,
          max: max,
          divisions: divisions,
          // label: currentValue.toStringAsFixed(2),
          onChanged: (value) {
            setState(() {
              controller.text = value.toStringAsFixed(2);
            });
          },
        ),
        Center(
          child: Text(
            '${currentValue.toInt()}',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
