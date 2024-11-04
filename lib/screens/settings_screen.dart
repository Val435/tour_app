import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final bool initialFilterState;
  final Function(bool) onFilterToggle;

  SettingsScreen(
      {required this.initialFilterState, required this.onFilterToggle});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isFilterEnabled = false;

  @override
  void initState() {
    super.initState();
    _isFilterEnabled = widget.initialFilterState;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text(
                "Activar filtro de color",
                style: TextStyle(color: Colors.white),
              ),
              trailing: Switch(
                value: _isFilterEnabled,
                onChanged: (value) {
                  setState(() {
                    _isFilterEnabled = value;
                  });
                  widget.onFilterToggle(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
