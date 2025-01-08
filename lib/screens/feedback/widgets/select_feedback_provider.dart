import 'package:feedback_work/core/ui/widgets/app_button.dart';
import 'package:feedback_work/core/ui/widgets/filter_bottom_sheet_content.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/providers/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SelectFeedbackProvider extends ConsumerStatefulWidget {
  const SelectFeedbackProvider({
    required this.category,
    super.key,
  });

  final String category;

  @override
  ConsumerState<SelectFeedbackProvider> createState() =>
      _SelectFeedbackProviderState();
}

class _SelectFeedbackProviderState
    extends ConsumerState<SelectFeedbackProvider> {
  List<PeopleSection> sections = [];

  @override
  void initState() {
    Future.microtask(() {
      ref
          .read(userProvider.notifier)
          .fetchUsersByExpertise(expertise: widget.category);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    ref.listen(userProvider, (_, newState) {
      if (newState.state == AsyncState.success) {
        List<String> names = [];
        for (var i in newState.data!) {
          names.add(i.firstName!);
          sections.add(PeopleSection(
              imageUrl: "", name: "${i.firstName ?? ''} ${i.lastName ?? ''}"));
        }
      }
    });
    return Builder(builder: (context) {
      if (userState.state == AsyncState.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (userState.error != null) {
        return Center(
          child: Text("Error: ${userState.error}"),
        );
      } else {
        return Column(
          children: [
            Expanded(
              child: FilterBottomSheetContent(
                hasHeader: false,
                peoples: sections,
                initialFilters: const {
                  'Expertise': {'Private'},
                  'Connection Type': {'Student'},
                },
                initialSliderValue: 50,
                onFiltersChanged: (filters) {
                  Log.info('Filters updated: $filters');
                },
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
        );
      }
    });
  }
}
