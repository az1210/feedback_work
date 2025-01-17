import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class TypePrinciple extends ConsumerStatefulWidget {
  const TypePrinciple(
      {required this.controller, required this.focusNode, super.key});

  final quill.QuillController controller;
  final FocusNode focusNode;

  @override
  ConsumerState<TypePrinciple> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends ConsumerState<TypePrinciple> {
  bool isKeyboardVisible(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  String? selectedFilePath;

  @override
  Widget build(BuildContext context) {
    final bool keyboardVisible = isKeyboardVisible(context);

    const config = quill.QuillSimpleToolbarConfigurations(
      multiRowsDisplay: true,
      showFontFamily: true,
      showFontSize: true,
      showBoldButton: true,
      showItalicButton: true,
      showUnderLineButton: true,
      showStrikeThrough: true,
      showColorButton: true,
      showAlignmentButtons: true,
      showSubscript: true,
      showSuperscript: true,
      showLink: true,
    );

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Type Principle",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 5),
              if (!keyboardVisible)
                quill.QuillToolbar.simple(
                  controller: widget.controller,
                  configurations: config,
                ),
              const SizedBox(height: 8),
              // Quill Editor
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: quill.QuillEditor.basic(
                  controller: widget.controller,
                  focusNode: FocusNode(),

                  // padding: const EdgeInsets.all(16),
                  // autoFocus: true,
                  // showCursor: true,
                  // enableInteractiveSelection: true,
                ),
              ),
              16.ph,
            ],
          ),
        ),
      ],
    );
  }
}
