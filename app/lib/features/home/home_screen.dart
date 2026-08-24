import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/constants.dart';
import '../../core/services/local_store.dart';
import '../../models/training_module.dart';
import '../certificate/certificate_service.dart';
import '../modules/module_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<TrainingModule>> _modules;

  @override
  void initState() {
    super.initState();
    _modules = _load();
    // Sync any certificates that were issued while offline (fire-and-forget).
    CertificateService.flushPending();
  }

  Future<List<TrainingModule>> _load() async {
    final out = <TrainingModule>[];
    for (final path in Constants.moduleAssets) {
      final raw = await rootBundle.loadString(path);
      out.add(TrainingModule.fromJson(json.decode(raw) as Map<String, dynamic>));
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final lang = LocalStore.langCode;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.appTitle),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: (code) => LocalStore.setLocale(code),
            itemBuilder: (_) => Constants.supportedLangs.entries
                .map((e) => PopupMenuItem<String>(value: e.key, child: Text(e.value)))
                .toList(),
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<List<TrainingModule>>(
          future: _modules,
          builder: (context, snap) {
            if (snap.hasError) {
              return Center(child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('Could not load modules: ${snap.error}'),
              ));
            }
            if (!snap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final modules = snap.data!;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(t.homeGreeting(LocalStore.workerName ?? ''),
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.offline_bolt, size: 16, color: Colors.green),
                  const SizedBox(width: 6),
                  Text(t.offlineReady, style: const TextStyle(color: Colors.black54)),
                ]),
                const SizedBox(height: 16),
                Text(t.chooseModule, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                ...modules.map((m) => _ModuleCard(
                      module: m,
                      lang: lang,
                      onReturn: () => setState(() {}),
                    )),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({required this.module, required this.lang, required this.onReturn});
  final TrainingModule module;
  final String lang;
  final VoidCallback onReturn;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final done = LocalStore.isModuleDone(module.id);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE3E8EE)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: done ? Colors.green : const Color(0xFFFFF2D6),
          child: Icon(done ? Icons.check : Icons.school,
              color: done ? Colors.white : const Color(0xFFB8860B)),
        ),
        title: Text(module.titleFor(lang), style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(
          done ? '${t.minutes(module.estimatedMinutes)} · ${t.completed}' : t.minutes(module.estimatedMinutes),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => ModuleDetailScreen(module: module)),
          );
          onReturn();
        },
      ),
    );
  }
}
