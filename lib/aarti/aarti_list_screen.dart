import 'package:flutter/material.dart';
import 'package:gajanan_maharaj_sevekari_app_demo/aarti/aarti_detail_screen.dart';
import 'package:gajanan_maharaj_sevekari_app_demo/l10n/app_localizations.dart';

enum AartiCategory { daily, event }

class AartiListScreen extends StatelessWidget {
  final AartiCategory category;

  const AartiListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final List<String> aartis = _getAartisForCategory(localizations);
    final String title = category == AartiCategory.daily ? localizations.dailyAartis : localizations.eventAartis;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
        itemCount: aartis.length,
        itemBuilder: (context, index) {
          final aartiTitle = aartis[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: ListTile(
              title: Text(aartiTitle),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AartiDetailScreen(aartiTitle: aartiTitle),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  List<String> _getAartisForCategory(AppLocalizations localizations) {
    if (category == AartiCategory.daily) {
      return [
        localizations.kakadAarti,
        localizations.madhyanAarti,
        localizations.dhoopAarti,
        localizations.shejAarti,
      ];
    } else {
      return [
        localizations.prakatDinAarti,
        localizations.ashadhiEkadashiAarti,
        localizations.dattaJayantiAarti,
        localizations.ramNavamiAarti,
        localizations.akshayTritiyaAarti,
        localizations.rushiPanchamiAarti,
      ];
    }
  }
}
