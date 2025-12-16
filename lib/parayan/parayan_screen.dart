import 'package:flutter/material.dart';
import 'package:gajanan_maharaj_sevekari_app_demo/l10n/app_localizations.dart';
import 'package:gajanan_maharaj_sevekari_app_demo/parayan/parayan_progress_checklist_screen.dart';
import 'package:gajanan_maharaj_sevekari_app_demo/parayan/parayan_type.dart';

class ParayanScreen extends StatelessWidget {
  const ParayanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.parayanTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                localizations.chooseParayanType,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            _buildParayanTypeCard(context, localizations.oneDayParayan, ParayanType.oneDay),
            _buildParayanTypeCard(context, localizations.threeDayParayan, ParayanType.threeDay),
          ],
        ),
      ),
    );
  }

  Widget _buildParayanTypeCard(BuildContext context, String title, ParayanType parayanType) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ParayanProgressChecklistScreen(parayanType: parayanType),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
