import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gajanan_maharaj_sevekari_app_demo/l10n/app_localizations.dart';

class StotraDetailsScreen extends StatefulWidget {
  final String stotraFileName;

  const StotraDetailsScreen({super.key, required this.stotraFileName});

  @override
  State<StotraDetailsScreen> createState() => _StotraDetailsScreenState();
}

class _StotraDetailsScreenState extends State<StotraDetailsScreen> with SingleTickerProviderStateMixin {
  late Future<Map<String, dynamic>> _stotraFuture;
  double _fontSize = 18.0;
  TabController? _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _stotraFuture = _loadStotra();
    _tabController = TabController(length: 2, vsync: this);
    _tabController!.addListener(() {
      if (mounted) {
        setState(() {
          _currentIndex = _tabController!.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> _loadStotra() async {
    final String response = await rootBundle.loadString('resources/texts/stotras/${widget.stotraFileName}');
    final data = await json.decode(response);
    return data;
  }

  void _changeFontSize(double delta) {
    setState(() {
      _fontSize = (_fontSize + delta).clamp(10.0, 40.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Map<String, dynamic>>(
          future: _stotraFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final stotra = snapshot.data!;
              final title = locale.languageCode == 'mr' ? stotra['title_mr'] : stotra['title_en'];
              return Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold));
            } else {
              return const Text(''); // Placeholder while loading
            }
          },
        ),
        actions: _currentIndex == 0
            ? [
                TextButton(
                  onPressed: () => _changeFontSize(-2.0),
                  child: const Text('A-', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                TextButton(
                  onPressed: () => _changeFontSize(2.0),
                  child: const Text('A+', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ]
            : [],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Material(
            color: Colors.orange,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.white,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
              tabs: [
                Tab(text: localizations.read),
                Tab(text: localizations.listen),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Read Tab
          FutureBuilder<Map<String, dynamic>>(
            future: _stotraFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                final stotra = snapshot.data!;
                final text = locale.languageCode == 'mr' ? stotra['stotra_mr'] : stotra['stotra_en'];
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: _fontSize),
                    ),
                  ),
                );
              } else {
                return const Center(child: Text('No data'));
              }
            },
          ),
          // Listen Tab
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.music_note, size: 100, color: Colors.grey),
                SizedBox(height: 20),
                Text('Audio player will be implemented here.', textAlign: TextAlign.center,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
