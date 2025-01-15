import 'dart:io';

import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class FeedbackModel extends ConsumerStatefulWidget {
  const FeedbackModel({super.key});

  @override
  ConsumerState<FeedbackModel> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends ConsumerState<FeedbackModel> {
  bool showPrinciple = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: showPrinciple,
                    onChanged: (val) {
                      setState(() {
                        showPrinciple = val!;
                      });
                    },
                    activeColor: context.colors.primaryBlue,
                  ),
                  const Text('Show "The Given Set"'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
