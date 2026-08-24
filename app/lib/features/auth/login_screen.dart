import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/constants.dart';
import '../../core/services/local_store.dart';
import '../../core/theme.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    final name = _name.text.trim();
    if (name.isEmpty) return;
    // TODO(johar): replace with Firebase Phone-OTP auth + role custom-claims.
    await LocalStore.setWorker(name, _phone.text.trim());
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Center(
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: kBrand,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(Icons.shield_outlined, color: Colors.white, size: 48),
                ),
              ),
              const SizedBox(height: 16),
              Text(t.appTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: kBrandInk)),
              Text(t.tagline,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.black54)),
              const SizedBox(height: 32),
              Text(t.chooseLanguage, style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: Constants.supportedLangs.entries.map((e) {
                  final selected = LocalStore.langCode == e.key;
                  return ChoiceChip(
                    label: Text(e.value),
                    selected: selected,
                    selectedColor: const Color(0xFFE9F6EF),
                    onSelected: (_) => LocalStore.setLocale(e.key),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Text(t.loginTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              TextField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(labelText: t.nameLabel, border: const OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: t.phoneLabel, border: const OutlineInputBorder()),
              ),
              const SizedBox(height: 24),
              FilledButton(onPressed: _continue, child: Text(t.continueBtn)),
            ],
          ),
        ),
      ),
    );
  }
}
