// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:file_picker/file_picker.dart';

// import '../../providers/solution_function_provider.dart';

// class SettingsScreen extends ConsumerStatefulWidget {
//   const SettingsScreen({super.key});

//   @override
//   _SettingsScreenState createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends ConsumerState<SettingsScreen> {
//   final TextEditingController startDateController = TextEditingController();
//   final TextEditingController finishDateController = TextEditingController();
//   final TextEditingController breakTimeController = TextEditingController();
//   final TextEditingController travelHourController = TextEditingController();
//   final TextEditingController travelMinuteController = TextEditingController();
//   final TextEditingController audioController = TextEditingController();
//   final TextEditingController popupTextController = TextEditingController();

//   @override
//   void dispose() {
//     startDateController.dispose();
//     finishDateController.dispose();
//     breakTimeController.dispose();
//     travelHourController.dispose();
//     travelMinuteController.dispose();
//     audioController.dispose();
//     popupTextController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final startTime = ref.watch(startTimeProvider);
//     final endTime = ref.watch(endTimeProvider);
//     final breakTime = ref.watch(breakTimeProvider);
//     final travelPerHour = ref.watch(travelPerHourProvider);
//     final travelPerMinute = ref.watch(travelPerMinuteProvider);

//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 240, 242, 245),
//       appBar: AppBar(
//         title: const Text('Settings'),
//         centerTitle: false,
//         actions: [
//           IconButton(
//             onPressed: () {
//               // Save logic here
//               ref.read(startTimeProvider.notifier).state =
//                   DateTime.parse(startDateController.text);
//               ref.read(endTimeProvider.notifier).state =
//                   DateTime.parse(finishDateController.text);
//               ref.read(breakTimeProvider.notifier).state =
//                   DateTime.parse(breakTimeController.text)
//                       .difference(DateTime.now());
//               ref.read(travelPerHourProvider.notifier).state =
//                   double.parse(travelHourController.text);
//               ref.read(travelPerMinuteProvider.notifier).state =
//                   double.parse(travelMinuteController.text);

//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text("Settings saved successfully!")),
//               );
//             },
//             icon: const Icon(Icons.save_alt),
//           ),
//         ],
//       ),
//       body: ListView(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 19),
//                 _buildTimePicker(
//                   context,
//                   "Start Time/Date",
//                   startTime,
//                   startDateController,
//                   (value) => ref.read(startTimeProvider.notifier).state = value,
//                 ),
//                 const SizedBox(height: 16),
//                 _buildTimePicker(
//                   context,
//                   "Finish Time/Date",
//                   endTime,
//                   finishDateController,
//                   (value) => ref.read(endTimeProvider.notifier).state = value,
//                 ),
//                 const SizedBox(height: 16),
//                 _buildTimePicker(
//                   context,
//                   "Break Time/Date",
//                   DateTime.now().add(breakTime),
//                   breakTimeController,
//                   (value) => ref.read(breakTimeProvider.notifier).state =
//                       value.difference(DateTime.now()),
//                 ),
//                 const SizedBox(height: 16),
//                 _buildSlider(
//                   "Percentage Completed per Hour",
//                   travelPerHour,
//                   travelHourController,
//                   min: 10.0,
//                   max: 100.0,
//                   divisions: 18,
//                   onChanged: (value) =>
//                       ref.read(travelPerHourProvider.notifier).state = value,
//                 ),
//                 const SizedBox(height: 16),
//                 _buildSlider(
//                   "Percentage Completed per Minute",
//                   travelPerMinute,
//                   travelMinuteController,
//                   min: 0.1,
//                   max: 5.0,
//                   divisions: 50,
//                   onChanged: (value) =>
//                       ref.read(travelPerMinuteProvider.notifier).state = value,
//                 ),
//                 const SizedBox(height: 16),
//                 _buildFilePicker(
//                   context,
//                   "Beep Audio",
//                   audioController,
//                   (value) {
//                     // Save audio file path to Firebase here
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 _buildPopupTextField(
//                   context,
//                   "Popup Text",
//                   popupTextController,
//                   (value) {
//                     // Save popup text
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTimePicker(
//     BuildContext context,
//     String label,
//     DateTime currentValue,
//     TextEditingController controller,
//     Function(DateTime) onValueChange,
//   ) {
//     controller.text =
//         "${currentValue.month}/${currentValue.day}/${currentValue.year} at ${currentValue.hour}:${currentValue.minute.toString().padLeft(2, '0')}";
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: Theme.of(context).textTheme.titleMedium,
//         ),
//         const SizedBox(height: 5),
//         TextField(
//           controller: controller,
//           decoration: InputDecoration(
//             hintText: "Select Date",
//             hintStyle: Theme.of(context).textTheme.bodySmall,
//             filled: true,
//             fillColor: Colors.white,
//             border: const OutlineInputBorder(
//               borderRadius: BorderRadius.all(Radius.circular(10)),
//               borderSide: BorderSide.none,
//             ),
//           ),
//           onTap: () async {
//             final date = await showDatePicker(
//               context: context,
//               initialDate: currentValue,
//               firstDate: DateTime(2000),
//               lastDate: DateTime(2100),
//             );
//             final time = await showTimePicker(
//               context: context,
//               initialTime: TimeOfDay.fromDateTime(currentValue),
//             );
//             if (date != null && time != null) {
//               onValueChange(DateTime(
//                   date.year, date.month, date.day, time.hour, time.minute));
//             }
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildFilePicker(
//     BuildContext context,
//     String label,
//     TextEditingController controller,
//     Function(String) onFileSelected,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: Theme.of(context).textTheme.titleMedium,
//         ),
//         const SizedBox(height: 5),
//         TextField(
//           controller: controller,
//           decoration: InputDecoration(
//             hintText: "Attach Audio File",
//             hintStyle: Theme.of(context).textTheme.bodySmall,
//             filled: true,
//             fillColor: Colors.white,
//             border: const OutlineInputBorder(
//               borderRadius: BorderRadius.all(Radius.circular(10)),
//               borderSide: BorderSide.none,
//             ),
//             suffixIcon: IconButton(
//               icon: const Icon(Icons.attach_file),
//               onPressed: () async {
//                 final result =
//                     await FilePicker.platform.pickFiles(type: FileType.audio);
//                 if (result != null) {
//                   final filePath = result.files.single.path;
//                   controller.text = filePath ?? '';
//                   onFileSelected(filePath!);
//                 }
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildPopupTextField(
//     BuildContext context,
//     String label,
//     TextEditingController controller,
//     Function(String) onTextChanged,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: Theme.of(context).textTheme.titleMedium,
//         ),
//         const SizedBox(height: 5),
//         TextField(
//           controller: controller,
//           decoration: InputDecoration(
//             hintText: "Enter Popup Text",
//             hintStyle: Theme.of(context).textTheme.bodySmall,
//             filled: true,
//             fillColor: Colors.white,
//             border: const OutlineInputBorder(
//               borderRadius: BorderRadius.all(Radius.circular(10)),
//               borderSide: BorderSide.none,
//             ),
//           ),
//           onChanged: onTextChanged,
//         ),
//       ],
//     );
//   }

//   Widget _buildSlider(
//     String label,
//     double currentValue,
//     TextEditingController controller, {
//     required double min,
//     required double max,
//     required int divisions,
//     required Function(double) onChanged,
//   }) {
//     controller.text = currentValue.toString();
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: Theme.of(context).textTheme.titleMedium,
//         ),
//         const SizedBox(height: 5),
//         Slider(
//           value: currentValue,
//           min: min,
//           max: max,
//           divisions: divisions,
//           label: currentValue.toStringAsFixed(2),
//           onChanged: onChanged,
//         ),
//       ],
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../../providers/project_providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  final String projectId; // Added projectId for linking settings to the project
  const SettingsScreen({super.key, required this.projectId});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController finishDateController = TextEditingController();
  final TextEditingController breakTimeController = TextEditingController();
  final TextEditingController travelHourController = TextEditingController();
  final TextEditingController travelMinuteController = TextEditingController();
  final TextEditingController audioController = TextEditingController();
  final TextEditingController popupTextController = TextEditingController();

  String? uploadedAudioUrl;

  @override
  void dispose() {
    startDateController.dispose();
    finishDateController.dispose();
    breakTimeController.dispose();
    travelHourController.dispose();
    travelMinuteController.dispose();
    audioController.dispose();
    popupTextController.dispose();
    super.dispose();
  }

  Future<void> saveSettings() async {
    try {
      // Define the date format used for parsing
      final DateFormat dateFormat = DateFormat('MM/dd/yyyy at hh:mm a');

      // Parse and validate the date-time inputs
      final startTime = dateFormat.parseStrict(startDateController.text);
      final endTime = dateFormat.parseStrict(finishDateController.text);
      final breakTime = dateFormat.parseStrict(breakTimeController.text);

      // Parse numeric inputs with validation
      final travelPerHour = double.tryParse(travelHourController.text) ?? 0.0;

      // Retrieve popup text and optional audio URL
      final popupText = popupTextController.text;
      final audioUrl = uploadedAudioUrl ?? ''; // Default to empty if not set

      // Prepare the settings data for Firestore
      final settingsData = {
        'startTime': Timestamp.fromDate(startTime),
        'endTime': Timestamp.fromDate(endTime),
        'breakTime': Timestamp.fromDate(breakTime),
        'travelPerHour': travelPerHour,
        'audioUrl': audioUrl,
        'popupText': popupText,
      };

      // Reference the Firestore settings document
      final settingsRef = FirebaseFirestore.instance
          .collection('projects')
          .doc(widget.projectId)
          .collection('settings')
          .doc('solutionFunctionSettings');

      // Save the data to Firestore with merge option
      await settingsRef.set(settingsData, SetOptions(merge: true));

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Settings saved successfully!")),
      );
    } on FormatException catch (e) {
      // Handle and debug FormatException
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save settings: Invalid date format")),
      );
      debugPrint("FormatException: ${e.message}");
    } catch (e) {
      // Handle other exceptions
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
        final storageRef =
            FirebaseStorage.instance.ref().child('audio/$fileName');
        final uploadTask = storageRef.putFile(File(filePath));
        final snapshot = await uploadTask.whenComplete(() => {});
        uploadedAudioUrl = await snapshot.ref.getDownloadURL();

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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 242, 245),
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: saveSettings,
            icon: const Icon(Icons.save_alt),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 19),
          _buildTimePicker(
            context,
            "Start Time/Date",
            startDateController,
          ),
          const SizedBox(height: 16),
          _buildTimePicker(
            context,
            "Finish Time/Date",
            finishDateController,
          ),
          const SizedBox(height: 16),
          _buildTimePicker(
            context,
            "Break Time/Date",
            breakTimeController,
          ),
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
            context,
            "Beep Audio",
            audioController,
            uploadAudioFile,
          ),
          const SizedBox(height: 16),
          _buildPopupTextField(
            context,
            "Popup Text",
            popupTextController,
          ),
        ],
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
        TextField(
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
              controller.text =
                  "${date.month}/${date.day}/${date.year} at ${time.format(context)}";
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
        TextField(
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

  Widget _buildPopupTextField(
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
        TextField(
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
    final currentValue = double.parse(controller.text.isEmpty
        ? min.toString()
        : controller.text); // Default value
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 5),
        Slider(
          value: currentValue,
          min: min,
          max: max,
          divisions: divisions,
          label: currentValue.toStringAsFixed(2),
          onChanged: (value) {
            setState(() {
              controller.text = value.toStringAsFixed(2);
            });
          },
        ),
      ],
    );
  }
}
