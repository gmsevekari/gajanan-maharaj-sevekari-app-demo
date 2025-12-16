import 'package:flutter/material.dart';
import 'package:gajanan_maharaj_sevekari_app_demo/bhajan/bhajan_detail_screen.dart';
import 'package:gajanan_maharaj_sevekari_app_demo/l10n/app_localizations.dart';

class BhajanScreen extends StatelessWidget {
  const BhajanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    final List<String> bhajans = [
      localizations.bhajanGajananachya,
      localizations.bhajanMurtiAhe,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.bhajanTitle),
      ),
      body: ListView.builder(
        itemCount: bhajans.length,
        itemBuilder: (context, index) {
          final bhajanTitle = bhajans[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: ListTile(
              title: Text(bhajanTitle),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BhajanDetailScreen(bhajanTitle: bhajanTitle),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
