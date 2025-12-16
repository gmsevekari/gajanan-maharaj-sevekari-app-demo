import 'package:flutter/material.dart';
import 'package:gajanan_maharaj_sevekari_app_demo/l10n/app_localizations.dart';
import 'package:gajanan_maharaj_sevekari_app_demo/parayan/parayan_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ParayanProgressChecklistScreen extends StatefulWidget {
  final ParayanType parayanType;

  const ParayanProgressChecklistScreen({super.key, required this.parayanType});

  @override
  _ParayanProgressChecklistScreenState createState() =>
      _ParayanProgressChecklistScreenState();
}

class _ParayanProgressChecklistScreenState
    extends State<ParayanProgressChecklistScreen> {
  late Future<List<bool>> _loadProgressFuture;
  late List<bool> _completedAdhyays;

  @override
  void initState() {
    super.initState();
    _loadProgressFuture = _loadProgress();
  }

  Future<List<bool>> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final completed = List.generate(21, (i) => prefs.getBool('adhyay_${i + 1}') ?? false);
    _completedAdhyays = completed;
    return completed;
  }

  Future<void> _saveProgress(int adhyayIndex, bool isCompleted) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('adhyay_${adhyayIndex + 1}', isCompleted);
    setState(() {
      _completedAdhyays[adhyayIndex] = isCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.parayanType == ParayanType.oneDay
            ? localizations.oneDayParayanProgress
            : localizations.threeDayParayanProgress),
      ),
      body: FutureBuilder<List<bool>>(
        future: _loadProgressFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading progress'));
          } else if (snapshot.hasData) {
            return _buildChecklist(localizations);
          } else {
            return const Center(child: Text('No progress found'));
          }
        },
      ),
    );
  }

  Widget _buildChecklist(AppLocalizations localizations) {
    if (widget.parayanType == ParayanType.oneDay) {
      return _buildDayList(1, 21, localizations);
    } else {
      return ListView(
        children: [
          _buildDayCard(1, 1, 9, localizations),
          _buildDayCard(2, 10, 15, localizations),
          _buildDayCard(3, 16, 21, localizations),
        ],
      );
    }
  }

  Widget _buildDayCard(int day, int startAdhyay, int endAdhyay, AppLocalizations localizations) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${localizations.day} $day', style: Theme.of(context).textTheme.titleLarge),
            _buildDayList(startAdhyay, endAdhyay, localizations),
          ],
        ),
      ),
    );
  }

  Widget _buildDayList(int startAdhyay, int endAdhyay, AppLocalizations localizations) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: endAdhyay - startAdhyay + 1,
      itemBuilder: (context, index) {
        final adhyayNumber = startAdhyay + index;
        return CheckboxListTile(
          title: Text('${localizations.adhyay} $adhyayNumber'),
          value: _completedAdhyays[adhyayNumber - 1],
          onChanged: (bool? value) {
            if (value != null) {
              _saveProgress(adhyayNumber - 1, value);
            }
          },
        );
      },
    );
  }
}
