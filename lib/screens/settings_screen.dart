import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.changeLanguage),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.language,
              style: const TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 16),
            
            // English option
            _buildLanguageOption(
              context,
              title: l10n.english,
              isSelected: languageProvider.locale.languageCode == 'en',
              onTap: () => languageProvider.changeLanguage('en'),
            ),
            
            const Divider(),
            
            // Arabic option
            _buildLanguageOption(
              context,
              title: l10n.arabic,
              isSelected: languageProvider.locale.languageCode == 'ar',
              onTap: () => languageProvider.changeLanguage('ar'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLanguageOption(
    BuildContext context, {
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}