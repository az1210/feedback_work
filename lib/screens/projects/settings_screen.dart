// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:file_picker/file_picker.dart';

// import '../../providers/project_providers.dart';

// class CreateProjectScreen extends ConsumerStatefulWidget {
//   const CreateProjectScreen({super.key});

//   @override
//   ConsumerState<CreateProjectScreen> createState() =>
//       _CreateProjectScreenState();
// }

// class _CreateProjectScreenState extends ConsumerState<CreateProjectScreen> {
//   final TextEditingController startDateController = TextEditingController();
//   final TextEditingController finishDateController = TextEditingController();
//   final TextEditingController breakTimeController = TextEditingController();
//   final TextEditingController percentageController = TextEditingController();
//   final TextEditingController beepController = TextEditingController();

//   bool isKeyboardVisible(BuildContext context) {
//     return MediaQuery.of(context).viewInsets.bottom > 0;
//   }

//   String? selectedFilePath;

//   Future<void> saveSettings() async {}

//   @override
//   void dispose() {
//     startDateController.dispose();
//     finishDateController.dispose();
//     breakTimeController.dispose();
//     percentageController.dispose();
//     beepController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bool keyboardVisible = isKeyboardVisible(context);

//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 240, 242, 245),
//       appBar: AppBar(
//         title: const Text('Settings'),
//         centerTitle: false,
//         actions: [IconButton(onPressed: () {}, icon: Icon(Icons.save_alt))],
//       ),
//       body: ListView(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 19),
//                 Text(
//                   "Start Time/Date",
//                   style: Theme.of(context).textTheme.titleMedium,
//                 ),
//                 const SizedBox(height: 5),
//                 TextField(
//                   controller: startDateController,
//                   decoration: InputDecoration(
//                     hintText: "Select Date",
//                     hintStyle: Theme.of(context).textTheme.bodySmall,
//                     filled: true,
//                     fillColor: Colors.white,
//                     border: const OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(10)),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   "Finish Time/Date",
//                   style: Theme.of(context).textTheme.titleMedium,
//                 ),
//                 const SizedBox(height: 5),
//                 TextField(
//                   controller: finishDateController,
//                   decoration: InputDecoration(
//                     hintText: "Select Date",
//                     hintStyle: Theme.of(context).textTheme.bodySmall,
//                     filled: true,
//                     fillColor: Colors.white,
//                     border: const OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(10)),
//                       borderSide: BorderSide.none,
//                     ),
//                     suffix: Icon(Icons.calendar_month_outlined),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   "Break Time/Date",
//                   style: Theme.of(context).textTheme.titleMedium,
//                 ),
//                 const SizedBox(height: 5),
//                 TextField(
//                   controller: breakTimeController,
//                   decoration: InputDecoration(
//                     hintText: "Select Date",
//                     hintStyle: Theme.of(context).textTheme.bodySmall,
//                     filled: true,
//                     fillColor: Colors.white,
//                     border: const OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(10)),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   "Number of Percentage Completed per Hour",
//                   style: Theme.of(context).textTheme.titleMedium,
//                 ),
//                 const SizedBox(height: 5),
//                 TextField(
//                   controller: beepController,
//                   decoration: InputDecoration(
//                     hintText: "Number of percentage",
//                     hintStyle: Theme.of(context).textTheme.bodySmall,
//                     filled: true,
//                     fillColor: Colors.white,
//                     border: const OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(10)),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   "Load Beep Audio",
//                   style: Theme.of(context).textTheme.titleMedium,
//                 ),
//                 const SizedBox(height: 5),
//                 TextField(
//                   controller: beepController,
//                   decoration: InputDecoration(
//                     hintText: "Type here",
//                     hintStyle: Theme.of(context).textTheme.bodySmall,
//                     filled: true,
//                     fillColor: Colors.white,
//                     border: const OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(10)),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   "Popup Text",
//                   style: Theme.of(context).textTheme.titleMedium,
//                 ),
//                 const SizedBox(height: 5),
//                 TextField(
//                   controller: beepController,
//                   decoration: InputDecoration(
//                     hintText: "Type here",
//                     hintStyle: Theme.of(context).textTheme.bodySmall,
//                     filled: true,
//                     fillColor: Colors.white,
//                     border: const OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(10)),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/solution_function_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController finishDateController = TextEditingController();
  final TextEditingController breakTimeController = TextEditingController();
  final TextEditingController travelHourController = TextEditingController();
  final TextEditingController travelMinuteController = TextEditingController();

  @override
  void dispose() {
    startDateController.dispose();
    finishDateController.dispose();
    breakTimeController.dispose();
    travelHourController.dispose();
    travelMinuteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final startTime = ref.watch(startTimeProvider);
    final endTime = ref.watch(endTimeProvider);
    final breakTime = ref.watch(breakTimeProvider);
    final travelPerHour = ref.watch(travelPerHourProvider);
    final travelPerMinute = ref.watch(travelPerMinuteProvider);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 242, 245),
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              // Save logic here
              ref.read(startTimeProvider.notifier).state =
                  DateTime.parse(startDateController.text);
              ref.read(endTimeProvider.notifier).state =
                  DateTime.parse(finishDateController.text);
              ref.read(breakTimeProvider.notifier).state =
                  Duration(minutes: int.parse(breakTimeController.text));
              ref.read(travelPerHourProvider.notifier).state =
                  double.parse(travelHourController.text);
              ref.read(travelPerMinuteProvider.notifier).state =
                  double.parse(travelMinuteController.text);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Settings saved successfully!")),
              );
            },
            icon: const Icon(Icons.save_alt),
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 19),
                _buildTimePicker(
                  context,
                  "Start Time/Date",
                  startTime,
                  startDateController,
                  (value) => ref.read(startTimeProvider.notifier).state = value,
                ),
                const SizedBox(height: 16),
                _buildTimePicker(
                  context,
                  "Finish Time/Date",
                  endTime,
                  finishDateController,
                  (value) => ref.read(endTimeProvider.notifier).state = value,
                ),
                const SizedBox(height: 16),
                _buildBreakTimePicker(
                  context,
                  "Break Time (minutes)",
                  breakTime,
                  breakTimeController,
                ),
                const SizedBox(height: 16),
                _buildSlider(
                  "Percentage Completed per Hour",
                  travelPerHour,
                  travelHourController,
                  min: 10.0,
                  max: 100.0,
                  divisions: 18,
                  onChanged: (value) =>
                      ref.read(travelPerHourProvider.notifier).state = value,
                ),
                const SizedBox(height: 16),
                _buildSlider(
                  "Percentage Completed per Minute",
                  travelPerMinute,
                  travelMinuteController,
                  min: 0.1,
                  max: 5.0,
                  divisions: 50,
                  onChanged: (value) =>
                      ref.read(travelPerMinuteProvider.notifier).state = value,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePicker(
    BuildContext context,
    String label,
    DateTime currentValue,
    TextEditingController controller,
    Function(DateTime) onValueChange,
  ) {
    controller.text = currentValue.toIso8601String();
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
              initialDate: currentValue,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (date != null) {
              onValueChange(date);
            }
          },
        ),
      ],
    );
  }

  Widget _buildBreakTimePicker(
    BuildContext context,
    String label,
    Duration currentValue,
    TextEditingController controller,
  ) {
    controller.text = currentValue.inMinutes.toString();
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
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "Enter Minutes",
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
    double currentValue,
    TextEditingController controller, {
    required double min,
    required double max,
    required int divisions,
    required Function(double) onChanged,
  }) {
    controller.text = currentValue.toString();
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
          onChanged: onChanged,
        ),
      ],
    );
  }
}
