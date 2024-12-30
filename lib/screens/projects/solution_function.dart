// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// import '../../providers/solution_function_provider.dart';

// class SolutionFunction extends ConsumerStatefulWidget {
//   const SolutionFunction({super.key});

//   @override
//   _SolutionFunctionState createState() => _SolutionFunctionState();
// }

// class _SolutionFunctionState extends ConsumerState<SolutionFunction>
//     with SingleTickerProviderStateMixin {
//   bool isPlaying = false;
//   bool manualControl = false;
//   late AnimationController _animationController;

//   bool showTooltip = false;
//   Offset tooltipPosition = Offset.zero;
//   final TextEditingController textController =
//       TextEditingController(text: 'Break, Lunch at McDonald\'s 11AM');

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(minutes: 2),
//     );
//     _animationController.addListener(() {
//       final percentage = (_animationController.value * 100).toInt();
//       ref.read(percentageProvider.notifier).state = percentage;
//     });
//   }

//   void togglePlayPause() {
//     setState(() {
//       isPlaying = !isPlaying;
//       if (isPlaying) {
//         _animationController.forward();
//       } else {
//         _animationController.stop();
//       }
//     });
//   }

//   void stopAnimation() {
//     setState(() {
//       _animationController.reset();
//       ref.read(percentageProvider.notifier).state = 0;
//       isPlaying = false;
//     });
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   String formatTimer(double value) {
//     final totalSeconds =
//         (value * _animationController.duration!.inSeconds).toInt();
//     final minutes = totalSeconds ~/ 60;
//     final seconds = totalSeconds % 60;
//     return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final percentage = ref.watch(percentageProvider);
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//     final travelWidth = screenWidth * 0.72;
//     final dx = travelWidth * _animationController.value * cos(27 * pi / 180);
//     final dy = travelWidth * _animationController.value * sin(22 * pi / 180);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Solution Function',
//           style: TextStyle(
//             fontFamily: 'Inter',
//             fontWeight: FontWeight.w600,
//             fontSize: 24,
//           ),
//         ),
//         elevation: 0,
//         scrolledUnderElevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         backgroundColor: Colors.white,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
//         child: Column(
//           children: [
//             const Center(
//               child: Text(
//                 "Michale David Function Status",
//                 style: TextStyle(
//                     fontFamily: 'Inter',
//                     fontWeight: FontWeight.w700,
//                     fontSize: 15,
//                     height: 1.5),
//               ),
//             ),
//             // const SizedBox(height: 40),
//             Stack(
//               children: [
//                 Container(
//                   padding:
//                       const EdgeInsets.only(left: 20, bottom: 100, top: 40),
//                   alignment: Alignment.center,
//                   child: Image.asset(
//                     'assets/images/solution_function/road-to-home.png',
//                     fit: BoxFit.contain,
//                     width: screenWidth * 0.75,
//                   ),
//                 ),

//                 // Circular percentage indicator that moves
//                 AnimatedBuilder(
//                   animation: _animationController,
//                   builder: (context, child) {
//                     return Positioned(
//                       bottom: 18 + dy,
//                       left: dx,
//                       child: Column(
//                         //no alignment is working
//                         children: [
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 5),
//                                 child: Image.asset(
//                                   "assets/images/solution_function/profile-image.png",
//                                   height: 25,
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 15),
//                                 child: Text(
//                                   isPlaying ? 'Start' : 'Break',
//                                   style: const TextStyle(
//                                     fontFamily: 'Inter',
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                               ),
//                               const Padding(
//                                 padding: EdgeInsets.only(right: 42),
//                                 child: Text(
//                                   'Solution \nFunction',
//                                   style: TextStyle(
//                                     fontFamily: 'Inter',
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w700,
//                                     height: 1,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SvgPicture.asset(
//                               "assets/images/solution_function/line-arrow.svg"),
//                           const SizedBox(height: 10),
//                           Padding(
//                             padding: const EdgeInsets.only(right: 78),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Stack(
//                                   alignment: Alignment.center,
//                                   children: [
//                                     SizedBox(
//                                       height: 42.5,
//                                       width: 42.5,
//                                       child: CircularProgressIndicator(
//                                         value: _animationController.value,
//                                         strokeWidth: 2,
//                                         backgroundColor: Colors.grey.shade200,
//                                         color: const Color.fromARGB(
//                                             255, 8, 102, 255),
//                                       ),
//                                     ),
//                                     Column(
//                                       children: [
//                                         Text(
//                                           formatTimer(
//                                               _animationController.value),
//                                           style: const TextStyle(
//                                             fontSize: 9.3,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         ),
//                                         if (!isPlaying)
//                                           const Text(
//                                             'Paused',
//                                             style: TextStyle(
//                                                 fontSize: 7,
//                                                 fontWeight: FontWeight.w400),
//                                           ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 10),
//                                 Text(
//                                   '$percentage% Completed',
//                                   style: const TextStyle(
//                                     fontFamily: 'Inter',
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w400,
//                                     height: 1.1,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),

//             // Bottom UI
//             Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     IconButton(
//                       onPressed: () {
//                         setState(() {
//                           _animationController.reset();
//                           ref.read(percentageProvider.notifier).state = 0;
//                           isPlaying = false;
//                           manualControl = false;
//                         });
//                       },
//                       icon: const Icon(Icons.refresh, size: 32),
//                       style: ButtonStyle(
//                         shape: WidgetStateProperty.all(
//                           const CircleBorder(
//                             side: BorderSide(
//                               color: Color.fromARGB(255, 233, 234, 240),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 13),
//                     ElevatedButton.icon(
//                       onPressed: togglePlayPause,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color.fromARGB(255, 8, 102, 255),
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 12, horizontal: 36),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(58),
//                         ),
//                       ),
//                       icon: Icon(
//                         isPlaying ? Icons.pause : Icons.play_arrow,
//                         size: 32,
//                         color: Colors.white,
//                       ),
//                       label: Text(
//                         isPlaying ? 'Pause' : 'Resume',
//                         style: const TextStyle(
//                           fontFamily: 'Inter',
//                           fontSize: 20,
//                           fontWeight: FontWeight.w400,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 13),
//                     IconButton(
//                       onPressed: stopAnimation,
//                       icon: const Icon(Icons.stop,
//                           size: 32, color: Color.fromARGB(255, 0, 100, 209)),
//                       style: ButtonStyle(
//                         // backgroundColor: MaterialStateProperty.all(Colors.white),
//                         shape: WidgetStateProperty.all(
//                           const CircleBorder(
//                             side: BorderSide(
//                               color: Color.fromARGB(255, 233, 234, 240),
//                             ),
//                           ),
//                         ),
//                       ),
//                       tooltip: 'Stop',
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Checkbox(
//                       activeColor: const Color.fromARGB(255, 0, 100, 209),
//                       value: manualControl,
//                       onChanged: (value) {
//                         setState(() {
//                           manualControl = value!;
//                         });
//                       },
//                     ),
//                     const Text(
//                       'Enable Manual Status',
//                       style: TextStyle(
//                         fontFamily: 'Inter',
//                         fontSize: 16,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Slider(
//                       activeColor: const Color.fromARGB(255, 8, 102, 255),
//                       inactiveColor: Colors.grey.shade300,
//                       value: _animationController.value * 100,
//                       min: 0,
//                       max: 100,
//                       divisions: 100,
//                       onChanged: (value) {
//                         setState(() {
//                           _animationController.value = value / 100;
//                           ref.read(percentageProvider.notifier).state =
//                               value.toInt();
//                         });
//                       },
//                     ),
//                     Center(
//                       child: Text(
//                         '${percentage.toInt()}',
//                         style: const TextStyle(
//                           fontFamily: 'Inter',
//                           fontSize: 16,
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     ElevatedButton(
//                       onPressed: () {
//                         // Add your logic here to update percentage to other screens
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color.fromARGB(255, 8, 102, 255),
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 16, horizontal: 32),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       child: const Text(
//                         'Update',
//                         style: TextStyle(
//                           fontFamily: 'Inter',
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 68),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () {},
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color.fromARGB(255, 235, 245, 255),
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text(
//                       'View Status Report',
//                       style: TextStyle(
//                         fontFamily: 'Inter',
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: Color.fromARGB(255, 0, 100, 209),
//                         letterSpacing: 0.32,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../providers/solution_function_provider.dart';

class SolutionFunction extends ConsumerStatefulWidget {
  final String projectId;

  const SolutionFunction({required this.projectId, super.key});

  @override
  _SolutionFunctionState createState() => _SolutionFunctionState();
}

class _SolutionFunctionState extends ConsumerState<SolutionFunction>
    with SingleTickerProviderStateMixin {
  bool isPlaying = false;
  bool manualControl = false;
  late AnimationController _animationController;
  late Timer? breakTimer;

  Map<String, dynamic>? settingsData;
  AudioPlayer? audioPlayer;

  @override
  void initState() {
    super.initState();
    _fetchSettings();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(minutes: 2), // Default duration
    );
    _animationController.addListener(() {
      final percentage = (_animationController.value * 100).toInt();
      ref.read(percentageProvider.notifier).state = percentage;
    });

    audioPlayer = AudioPlayer();
  }

  Future<void> _fetchSettings() async {
    final settingsDoc = await FirebaseFirestore.instance
        .collection('projects')
        .doc(widget.projectId)
        .collection('settings')
        .doc('solutionFunctionSettings')
        .get();

    if (settingsDoc.exists) {
      setState(() {
        settingsData = settingsDoc.data();

        // Update AnimationController duration
        final startTime = (settingsData?['startTime'] as Timestamp).toDate();
        final endTime = (settingsData?['endTime'] as Timestamp).toDate();
        final travelPerHour = settingsData?['travelPerHour'] ?? 50.0;

        _animationController.duration = Duration(
          hours:
              ((100 / travelPerHour) * (endTime.hour - startTime.hour)).toInt(),
        );

        // Handle break time and audio
        if (settingsData?['breakTime'] != null) {
          final breakTime = (settingsData?['breakTime'] as Timestamp).toDate();
          final now = DateTime.now();
          if (now.isBefore(breakTime)) {
            final durationUntilBreak = breakTime.difference(now);
            _scheduleBreak(durationUntilBreak, settingsData?['beepAudio']);
          }
        }
      });
    }
  }

  void _scheduleBreak(Duration durationUntilBreak, String? beepAudio) {
    breakTimer = Timer(durationUntilBreak, () async {
      // Stop the animation and play the audio once
      _animationController.stop();
      isPlaying = false;

      if (beepAudio != null && beepAudio.isNotEmpty) {
        await audioPlayer!
            .play(UrlSource(beepAudio)); // Correct usage for audio from URL
      }

      // Do not resume the audio automatically. It plays once only.
    });
  }

  void togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
      if (isPlaying) {
        _animationController.forward();
      } else {
        _animationController.stop();
      }
    });
  }

  void stopAnimation() {
    setState(() {
      _animationController.reset();
      ref.read(percentageProvider.notifier).state = 0;
      isPlaying = false;
      breakTimer?.cancel();
      audioPlayer?.stop();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    breakTimer?.cancel();
    audioPlayer?.dispose();
    super.dispose();
  }

  String formatTimer(double value) {
    final totalSeconds =
        (value * _animationController.duration!.inSeconds).toInt();
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final percentage = ref.watch(percentageProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final travelWidth = screenWidth * 0.72;
    final dx = travelWidth * _animationController.value * cos(27 * pi / 180);
    final dy = travelWidth * _animationController.value * sin(22 * pi / 180);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Solution Function',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
      ),
      body: settingsData == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                children: [
                  const Center(
                    child: Text(
                      "Michale David Function Status",
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          height: 1.5),
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                            left: 20, bottom: 100, top: 40),
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/images/solution_function/road-to-home.png',
                          fit: BoxFit.contain,
                          width: screenWidth * 0.75,
                        ),
                      ),

                      // Circular percentage indicator that moves
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Positioned(
                            bottom: 18 + dy,
                            left: dx,
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: Image.asset(
                                        "assets/images/solution_function/profile-image.png",
                                        height: 25,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 15),
                                      child: Text(
                                        isPlaying ? 'Start' : 'Break',
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(right: 42),
                                      child: Text(
                                        'Solution \nFunction',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          height: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SvgPicture.asset(
                                    "assets/images/solution_function/line-arrow.svg"),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(right: 78),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          SizedBox(
                                            height: 42.5,
                                            width: 42.5,
                                            child: CircularProgressIndicator(
                                              value: _animationController.value,
                                              strokeWidth: 2,
                                              backgroundColor:
                                                  Colors.grey.shade200,
                                              color: const Color.fromARGB(
                                                  255, 8, 102, 255),
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                formatTimer(
                                                    _animationController.value),
                                                style: const TextStyle(
                                                  fontSize: 9.3,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              if (!isPlaying)
                                                const Text(
                                                  'Paused',
                                                  style: TextStyle(
                                                      fontSize: 7,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        '$percentage% Completed',
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          height: 1.1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _animationController.reset();
                                ref.read(percentageProvider.notifier).state = 0;
                                isPlaying = false;
                                manualControl = false;
                              });
                            },
                            icon: const Icon(Icons.refresh, size: 32),
                            style: ButtonStyle(
                              shape: WidgetStateProperty.all(
                                const CircleBorder(
                                  side: BorderSide(
                                    color: Color.fromARGB(255, 233, 234, 240),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 13),
                          ElevatedButton.icon(
                            onPressed: togglePlayPause,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 8, 102, 255),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 36),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(58),
                              ),
                            ),
                            icon: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              size: 32,
                              color: Colors.white,
                            ),
                            label: Text(
                              isPlaying ? 'Pause' : 'Resume',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 13),
                          IconButton(
                            onPressed: stopAnimation,
                            icon: const Icon(Icons.stop,
                                size: 32,
                                color: Color.fromARGB(255, 0, 100, 209)),
                            style: ButtonStyle(
                              // backgroundColor: MaterialStateProperty.all(Colors.white),
                              shape: WidgetStateProperty.all(
                                const CircleBorder(
                                  side: BorderSide(
                                    color: Color.fromARGB(255, 233, 234, 240),
                                  ),
                                ),
                              ),
                            ),
                            tooltip: 'Stop',
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            activeColor: const Color.fromARGB(255, 0, 100, 209),
                            value: manualControl,
                            onChanged: (value) {
                              setState(() {
                                manualControl = value!;
                              });
                            },
                          ),
                          const Text(
                            'Enable Manual Status',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Slider(
                            activeColor: const Color.fromARGB(255, 8, 102, 255),
                            inactiveColor: Colors.grey.shade300,
                            value: _animationController.value * 100,
                            min: 0,
                            max: 100,
                            divisions: 100,
                            onChanged: (value) {
                              setState(() {
                                _animationController.value = value / 100;
                                ref.read(percentageProvider.notifier).state =
                                    value.toInt();
                              });
                            },
                          ),
                          Center(
                            child: Text(
                              '${percentage.toInt()}',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              // Add your logic here to update percentage to other screens
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 8, 102, 255),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 32),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Update',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 68),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 235, 245, 255),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'View Status Report',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 0, 100, 209),
                              letterSpacing: 0.32,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
