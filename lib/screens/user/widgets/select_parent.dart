import 'package:feedback_work/core/ui/widgets/filter__content.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/user_model.dart';
import 'package:feedback_work/providers/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectParent extends ConsumerStatefulWidget {
  const SelectParent({
    this.onFiltersChanged,
    super.key,
  });

  final void Function(Map<String, Set<UserModel>>)? onFiltersChanged;

  @override
  ConsumerState<SelectParent> createState() => _SelectFeedbackuserState();
}

class _SelectFeedbackuserState extends ConsumerState<SelectParent> {
  List<FilterSection<UserModel>> sections = [];

  List<UserModel> users = [];

  Map<String, Set<UserModel>> selectedFilters = {};

  @override
  void initState() {
    Future.microtask(() {
      ref.read(userProvider.notifier).fetchAllUsers();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    ref.listen(userProvider, (_, newState) {
      if (newState.state == AsyncState.success) {
        Log.info(newState.data!.length.toString());
        users = newState.data!;
        Log.info(users.length.toString());
        List<UserModel> values = [];
        List<String> labels = [];
        List<String> imageUrls = [];
        if (newState.data != null || newState.data!.isNotEmpty) {
          for (var i in newState.data!) {
            values.add(i);
            labels.add("${i.firstName ?? ''} ${i.lastName ?? ''}");
            imageUrls.add(i.avatarUrl ?? '');
          }
          sections = [
            FilterSection<UserModel>(
                title: "parent",
                showTitle: false,
                values: values,
                labels: labels,
                imageUrls: imageUrls,
                allowMultipleSelection: false),
          ];
          selectedFilters = {
            'parent': {values.first}
          };
        }
      }
    });
    return Builder(builder: (context) {
      if (userState.state == AsyncState.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (userState.state == AsyncState.failure) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              Expanded(
                child: FilterContent<UserModel>(
                  hasHeader: false,
                  sections: sections,
                  selectedFilters: selectedFilters,
                  onFiltersChanged: widget.onFiltersChanged,
                  onApply: () {
                    Log.info('Filters applied');
                  },
                  onReset: () {
                    Log.info('Filters reset');
                  },
                  hasActionButton: false,
                ),
              ),
            ],
          ),
        );
      }
    });
  }
}
