import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SetFeedbackModel extends ConsumerStatefulWidget {
  const SetFeedbackModel(
      {required this.principle,
      required this.onSelectModel,
      required this.principlesToDeriveForm,
      super.key});

  final List<String> principlesToDeriveForm;
  final String principle;
  final void Function(String) onSelectModel;

  @override
  ConsumerState<SetFeedbackModel> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends ConsumerState<SetFeedbackModel> {
  bool showPrinciple = false;
  String? selectedOption;

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
                        selectedOption = widget.principlesToDeriveForm.first;
                      });
                    },
                    activeColor: context.colors.primaryBlue,
                  ),
                  Text('Show "${widget.principle}"'),
                ],
              ),
              if (showPrinciple) ...[
                16.ph,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.principle,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                16.ph,
              ],
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.principlesToDeriveForm.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      widget
                          .onSelectModel(widget.principlesToDeriveForm[index]);
                      selectedOption = widget.principlesToDeriveForm[index];
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    decoration: BoxDecoration(
                        color: selectedOption ==
                                widget.principlesToDeriveForm[index]
                            ? context.colors.primaryBlue.withValues(alpha: 0.1)
                            : context.colors.pureWhite),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          "${index + 1}. ${widget.principlesToDeriveForm[index]}",
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: selectedOption ==
                                            widget.principlesToDeriveForm[index]
                                        ? context.colors.primaryBlue
                                        : context.colors.textBlack,
                                  ),
                        )),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
