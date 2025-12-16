import 'package:flutter/material.dart';
import 'package:gajanan_maharaj_sevekari_app_demo/l10n/app_localizations.dart';
import 'package:gajanan_maharaj_sevekari_app_demo/settings/locale_provider.dart';
import 'package:provider/provider.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.language),
      ),
      body: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _buildLanguageOption(
                  context,
                  localizations.english,
                  localeProvider.locale.languageCode == 'en',
                  () => localeProvider.setLocale(const Locale('en')),
                ),
                _buildLanguageOption(
                  context,
                  localizations.marathi,
                  localeProvider.locale.languageCode == 'mr',
                  () => localeProvider.setLocale(const Locale('mr')),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLanguageOption(
      BuildContext context, String title, bool isSelected, VoidCallback onTap) {
    return Card(
      child: ListTile(
        title: Text(title, style: const TextStyle(fontSize: 18)),
        trailing: isSelected
            ? Icon(Icons.check, color: Theme.of(context).primaryColor)
            : null,
        onTap: onTap,
      ),
    );
  }
}
