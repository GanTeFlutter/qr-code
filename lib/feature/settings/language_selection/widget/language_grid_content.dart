import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrcode_akillisletme/feature/settings/language_selection/widget/language_card.dart';
import 'package:qrcode_akillisletme/product/init/language/language_item.dart';

class LanguageGridContent extends StatelessWidget {
  const LanguageGridContent({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;
    final screenWidth = MediaQuery.sizeOf(context).width;

    // Tablet: 3 sütun, telefon: 2 sütun
    final crossAxisCount = screenWidth > 600 ? 3 : 2;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: screenWidth > 600 ? 2.8 : 2.4,
      ),
      itemCount: LanguageItem.all.length,
      itemBuilder: (context, index) {
        final item = LanguageItem.all[index];
        final isSelected =
            item.locale.languageCode == currentLocale.languageCode;
        return LanguageCard(
          item: item,
          isSelected: isSelected,
          onTap: () async {
            await HapticFeedback.selectionClick();
            if (context.mounted) {
              await context.setLocale(item.locale);
            }
          },
        );
      },
    );
  }
}
