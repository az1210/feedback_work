import 'package:feedback_work/core/utils/validator.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TooltipOverlayScreen(),
    );
  }
}

class TooltipOverlayScreen extends StatefulWidget {
  const TooltipOverlayScreen({super.key});

  @override
  State<TooltipOverlayScreen> createState() => _TooltipOverlayScreenState();
}

class _TooltipOverlayScreenState extends State<TooltipOverlayScreen> {
  final formKey = GlobalKey<FormState>();
  bool showTooltip = false; // Controls tooltip visibility
  final TextEditingController textController = TextEditingController(
      text: 'Break, Lunch at McDonald\'s 11AM'); // Initial text

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tooltip with Background Image'),
        backgroundColor: Colors.blue,
      ),
      body: Form(
        key: formKey,
        child: Stack(
          children: [
            // Background content
            Container(
              color: Colors.blueGrey[50],
              child: const Center(
                child: Text(
                  'Tap the icon to show tooltip',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            // Positioned GestureDetector with IconButton
            Positioned(
              top: 150, // Position of the button
              left: 100,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    showTooltip = !showTooltip; // Toggle tooltip visibility
                  });
                },
                child: const Icon(
                  Icons.info_outline,
                  size: 40,
                  color: Colors.blue,
                ),
              ),
            ),

            // Tooltip positioned below the IconButton
            if (showTooltip)
              Positioned(
                top: 190, // Tooltip below the button
                left: 80, // Center the tooltip
                child: Container(
                  width: 250,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 5,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    // Background image for the tooltip
                    image: const DecorationImage(
                      image: AssetImage('assets/tooltip_background.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Editable TextFormField with transparent background
                      TextFormField(
                        controller: textController,
                        maxLines: 2,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Enter your comment here',
                          hintStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.black
                              .withOpacity(0.3), // TextFormField background
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) =>
                            validateInput(value, fieldName: 'Comment'),
                      ),
                      const SizedBox(height: 8),

                      // Update Button
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              showTooltip =
                                  false; // Close tooltip after updating
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Updated text: ${textController.text}'),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                          ),
                          child: const Text('Update'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    textController.dispose(); // Dispose controller when widget is destroyed
    super.dispose();
  }
}
