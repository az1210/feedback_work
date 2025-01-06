import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/screens/feedback/widgets/feedback_search_and_filter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final int _currentIndex = 1;
  bool isGrid = true;

  final List<String> _routes = [
    '/projects',
    '/feedback',
    '/network',
    '/status',
    '/more',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Feedback",
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  isGrid = !isGrid;
                });
              },
              icon: isGrid
                  ? const Icon(
                      Icons.list,
                    )
                  : const Icon(
                      Icons.grid_view,
                    ),
            ),
            8.pw,
          ],
        ),
        body: const Column(
          children: [
            FeedbackSearchAndFilter(),
          ],
        ));
  }
}
