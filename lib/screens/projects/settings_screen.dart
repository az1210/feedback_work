// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'package:go_router/go_router.dart';

// import '../../providers/project_providers.dart';

// class SettingsScreen extends ConsumerStatefulWidget {
//   final String projectId; // Added projectId for linking settings to the project
//   const SettingsScreen({super.key, required this.projectId});

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

//   String? uploadedAudioUrl;

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

//   Future<void> saveSettings() async {
//     try {
//       // Define the date format
//       final DateFormat dateFormat = DateFormat('MM/dd/yyyy at hh:mm a');

//       // Validate and parse inputs
//       final startTime =
//           _validateAndParseDate(startDateController.text, dateFormat);
//       final endTime =
//           _validateAndParseDate(finishDateController.text, dateFormat);
//       final breakTime =
//           _validateAndParseDate(breakTimeController.text, dateFormat);

//       // Parse numeric inputs
//       final travelPerHour = double.tryParse(travelHourController.text) ?? 0.0;
//       final popupText = popupTextController.text;

//       // Prepare Firestore data
//       final settingsData = {
//         'startTime': Timestamp.fromDate(startTime),
//         'endTime': Timestamp.fromDate(endTime),
//         'breakTime': Timestamp.fromDate(breakTime),
//         'travelPerHour': travelPerHour,
//         'audioUrl': uploadedAudioUrl ?? '',
//         'popupText': popupText,
//       };

//       // Reference Firestore settings document
//       final settingsRef = FirebaseFirestore.instance
//           .collection('projects')
//           .doc(widget.projectId)
//           .collection('settings')
//           .doc('solutionFunctionSettings');

//       // Save data to Firestore
//       await settingsRef.set(settingsData, SetOptions(merge: true));
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Settings saved successfully!")),
//       );
//     } on FormatException catch (e) {
//       // Handle invalid date format
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text("Invalid date format. Please check your input.")),
//       );
//       debugPrint("FormatException: ${e.message}");
//     } catch (e) {
//       // Handle other exceptions
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to save settings: $e")),
//       );
//       debugPrint("Exception: $e");
//     }
//   }

//   /// Helper Function: Validates and Parses Date
//   DateTime _validateAndParseDate(String input, DateFormat format) {
//     if (input.isEmpty) {
//       throw const FormatException("Date cannot be empty.");
//     }
//     return format.parseStrict(input);
//   }

//   Future<void> uploadAudioFile() async {
//     final result = await FilePicker.platform.pickFiles(type: FileType.audio);
//     if (result != null) {
//       final filePath = result.files.single.path!;
//       final fileName = result.files.single.name;

//       try {
//         final storageRef =
//             FirebaseStorage.instance.ref().child('audio/$fileName');
//         final uploadTask = storageRef.putFile(File(filePath));
//         final snapshot = await uploadTask.whenComplete(() => {});
//         uploadedAudioUrl = await snapshot.ref.getDownloadURL();

//         audioController.text = fileName;
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Audio file uploaded successfully!")),
//         );
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Failed to upload audio file: $e")),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 240, 242, 245),
//       appBar: AppBar(
//         title: const Text('Settings'),
//         centerTitle: false,
//         actions: [
//           IconButton(
//             onPressed: saveSettings,
//             icon: const Icon(Icons.save_alt),
//           ),
//         ],
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16.0),
//         children: [
//           const SizedBox(height: 19),
//           _buildTimePicker(
//             context,
//             "Start Time/Date",
//             startDateController,
//           ),
//           const SizedBox(height: 16),
//           _buildTimePicker(
//             context,
//             "Finish Time/Date",
//             finishDateController,
//           ),
//           const SizedBox(height: 16),
//           _buildTimePicker(
//             context,
//             "Break Time/Date",
//             breakTimeController,
//           ),
//           const SizedBox(height: 16),
//           _buildSlider(
//             "Percentage Completed per Hour",
//             travelHourController,
//             min: 10.0,
//             max: 100.0,
//             divisions: 18,
//           ),
//           const SizedBox(height: 16),
//           _buildFilePicker(
//             context,
//             "Beep Audio",
//             audioController,
//             uploadAudioFile,
//           ),
//           const SizedBox(height: 16),
//           _buildPopupTextFormField(
//             context,
//             "Popup Text",
//             popupTextController,
//           ),
//         ],
//       ),
//     );
//   }

//   // Widget _buildTimePicker(
//   //   BuildContext context,
//   //   String label,
//   //   TextEditingController controller,
//   // ) {
//   //   return Column(
//   //     crossAxisAlignment: CrossAxisAlignment.start,
//   //     children: [
//   //       Text(
//   //         label,
//   //         style: Theme.of(context).textTheme.titleMedium,
//   //       ),
//   //       const SizedBox(height: 5),
//   //       TextFormField(
//   //         controller: controller,
//   //         decoration: InputDecoration(
//   //           hintText: "Select Date",
//   //           hintStyle: Theme.of(context).textTheme.bodySmall,
//   //           filled: true,
//   //           fillColor: Colors.white,
//   //           border: const OutlineInputBorder(
//   //             borderRadius: BorderRadius.all(Radius.circular(10)),
//   //             borderSide: BorderSide.none,
//   //           ),
//   //         ),
//   //         onTap: () async {
//   //           final date = await showDatePicker(
//   //             context: context,
//   //             initialDate: DateTime.now(),
//   //             firstDate: DateTime(2000),
//   //             lastDate: DateTime(2100),
//   //           );
//   //           final time = await showTimePicker(
//   //             context: context,
//   //             initialTime: TimeOfDay.now(),
//   //           );
//   //           if (date != null && time != null) {
//   //             controller.text =
//   //                 "${date.month}/${date.day}/${date.year} at ${time.format(context)}";
//   //           }
//   //         },
//   //       ),
//   //     ],
//   //   );
//   // }

//   Widget _buildTimePicker(
//     BuildContext context,
//     String label,
//     TextEditingController controller,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: Theme.of(context).textTheme.titleMedium,
//         ),
//         const SizedBox(height: 5),
//         TextFormField(
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
//           readOnly: true, // Prevent manual input
//           onTap: () async {
//             final date = await showDatePicker(
//               context: context,
//               initialDate: DateTime.now(),
//               firstDate: DateTime(2000),
//               lastDate: DateTime(2100),
//             );
//             if (date != null) {
//               final time = await showTimePicker(
//                 context: context,
//                 initialTime: TimeOfDay.now(),
//               );
//               if (time != null) {
//                 // Format and set the selected date and time
//                 final formattedDate =
//                     "${date.month}/${date.day}/${date.year} at ${time.format(context)}";
//                 controller.text = formattedDate;
//               }
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
//     Function onFileSelected,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: Theme.of(context).textTheme.titleMedium,
//         ),
//         const SizedBox(height: 5),
//         TextFormField(
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
//               onPressed: () => onFileSelected(),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildPopupTextFormField(
//     BuildContext context,
//     String label,
//     TextEditingController controller,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: Theme.of(context).textTheme.titleMedium,
//         ),
//         const SizedBox(height: 5),
//         TextFormField(
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
//         ),
//       ],
//     );
//   }

//   Widget _buildSlider(
//     String label,
//     TextEditingController controller, {
//     required double min,
//     required double max,
//     required int divisions,
//   }) {
//     final currentValue = double.parse(controller.text.isEmpty
//         ? min.toString()
//         : controller.text); // Default value
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
//           onChanged: (value) {
//             setState(() {
//               controller.text = value.toStringAsFixed(2);
//             });
//           },
//         ),
//       ],
//     );
//   }
// }

import 'dart:io';
import 'package:feedback_work/core/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      final settingsRef = FirebaseFirestore.instance
          .collection('projects')
          .doc(widget.projectId)
          .collection('settings')
          .doc('solutionFunctionSettings');

      final doc = await settingsRef.get();

      if (doc.exists) {
        final data = doc.data()!;

        setState(() {
          startDateController.text = data['startTime'] != null
              ? DateFormat('MM/dd/yyyy at hh:mm a')
                  .format((data['startTime'] as Timestamp).toDate())
              : '';

          finishDateController.text = data['endTime'] != null
              ? DateFormat('MM/dd/yyyy at hh:mm a')
                  .format((data['endTime'] as Timestamp).toDate())
              : '';

          breakTimeController.text = data['breakTime'] != null
              ? DateFormat('MM/dd/yyyy at hh:mm a')
                  .format((data['breakTime'] as Timestamp).toDate())
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
// Define the date format used for parsing
        final DateFormat dateFormat = DateFormat('MM/dd/yyyy at hh:mm a');

        // Parse the date-time inputs
        final startTime =
            dateFormat.parseStrict(startDateController.text.trim());
        final endTime =
            dateFormat.parseStrict(finishDateController.text.trim());
        final breakTime =
            dateFormat.parseStrict(breakTimeController.text.trim());

        // Parse numeric inputs with validation
        final travelPerHour =
            double.tryParse(travelHourController.text.trim()) ?? 0.0;

        // Retrieve popup text and optional audio URL
        final popupText = popupTextController.text.trim();
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
        final projectId = widget.projectId;
        context.push('/solution-function/$projectId');

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Settings saved successfully!")),
        );
      }
    } on FormatException catch (e) {
      // Handle invalid date format
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid date format. Please re-enter.")),
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
