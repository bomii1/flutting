import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          title: const Text('Temperature Unit'),
          subtitle: const Text('Celsius/Fahrenheit (Default: Celsius)'),
          trailing: Switch(
            value: context.watch<TempSettingsState>().tempUnit == TempUnit.celsius,
            onChanged: (_) {
              context.read<TempSettingsProvider>().toggleTempUnit();
            },
          ),
        ),
      ),
    );
  }
}
