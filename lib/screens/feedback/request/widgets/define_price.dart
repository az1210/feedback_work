import 'package:feedback_work/core/extensions/extensions.dart';
import 'package:feedback_work/core/router/routes.dart';
import 'package:feedback_work/core/ui/widgets/filter__content.dart';
import 'package:feedback_work/core/utils/utils.dart';
import 'package:feedback_work/models/user_model.dart';
import 'package:feedback_work/providers/auth_providers.dart';
import 'package:feedback_work/providers/firebase_providers.dart';
import 'package:feedback_work/providers/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefinePrice extends ConsumerStatefulWidget {
  const DefinePrice({
    super.key,
    this.onDefinePrice,
  });

  final void Function(String?)? onDefinePrice;

  @override
  ConsumerState<DefinePrice> createState() => _DefinePriceState();
}

class _DefinePriceState extends ConsumerState<DefinePrice> {
  UserModel? currentUser;

  final sections = [
    FilterSection(
      title: 'price',
      values: [
        'At Cost',
        'Free',
      ],
      labels: [
        'At Cost',
        'Free',
      ],
      allowMultipleSelection: false,
    ),
  ];

  Map<String, Set<String>> selectedFilters = {};

  String? selectedPricetype;
  double? price;
  double? minimumPrice;

  @override
  void initState() {
    Future.microtask(() {
      ref.read(userProvider.notifier).currentUser();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    currentUser = ref.watch(currentUserProvider);
    minimumPrice = currentUser?.minimumRate ?? 0;
    return Builder(builder: (context) {
      if (currentUser == null) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                FilterContent(
                  hasHeader: false,
                  hasSearchOption: false,
                  sections: sections,
                  selectedFilters: selectedFilters,
                  onFiltersChanged: (filters) {
                    setState(() {
                      selectedPricetype = filters['price']?.first ?? 'At Cost';
                      selectedFilters = filters;
                    });
                    Log.info('Filters updated: ${['price'].first as String?}');
                  },
                  onApply: () {
                    Log.info('Filters applied');
                  },
                  onReset: () {
                    Log.info('Filters reset');
                  },
                  hasActionButton: false,
                ),
                if (selectedPricetype == 'At Cost') ...[
                  Row(
                    children: [
                      Text(
                        "Feedback Price",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  8.ph,
                  TextFormField(
                    onChanged: widget.onDefinePrice,
                    decoration: InputDecoration(
                      hintText: "Min price: \$${minimumPrice ?? 0}",
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                      filled: true,
                      fillColor: context.colors.pureWhite,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
                16.ph,
              ],
            ),
          ),
        );
      }
    });
  }
}
