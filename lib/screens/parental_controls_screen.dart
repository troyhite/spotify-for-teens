import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/content_filter.dart';
import '../services/parental_controls_service.dart';
import '../services/spotify_service.dart';

class ParentalControlsScreen extends StatefulWidget {
  const ParentalControlsScreen({super.key});

  @override
  State<ParentalControlsScreen> createState() => _ParentalControlsScreenState();
}

class _ParentalControlsScreenState extends State<ParentalControlsScreen> {
  Future<void> _showPinDialog({bool isSetup = false}) async {
    final controller = TextEditingController();
    final parentalControls = context.read<ParentalControlsService>();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isSetup ? 'Set Parental PIN' : 'Enter PIN'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          obscureText: true,
          maxLength: 4,
          decoration: const InputDecoration(
            hintText: 'Enter 4-digit PIN',
            counterText: '',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.length == 4) {
                if (isSetup) {
                  parentalControls.setPin(controller.text);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('PIN set successfully')),
                  );
                } else {
                  if (parentalControls.verifyPin(controller.text)) {
                    Navigator.pop(context, true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Incorrect PIN'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Future<bool> _verifyPin() async {
    final parentalControls = context.read<ParentalControlsService>();
    
    if (!parentalControls.isPinSet) {
      await _showPinDialog(isSetup: true);
      return true;
    }

    final result = await _showPinDialog();
    return result == true;
  }

  Future<void> _showFilterOptions() async {
    if (!await _verifyPin()) return;

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Strict (Everyone)'),
              subtitle: const Text('Most restrictive filtering'),
              onTap: () {
                context.read<ParentalControlsService>().setFilter(ContentFilter.strict);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Default (Teen 13+)'),
              subtitle: const Text('Moderate filtering'),
              onTap: () {
                context.read<ParentalControlsService>().setFilter(ContentFilter.defaultFilter);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Custom'),
              subtitle: const Text('Configure your own filters'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to custom filter screen
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parental Controls'),
        elevation: 0,
        actions: [
          Consumer<SpotifyService>(
            builder: (context, spotify, _) => IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );

                if (confirmed == true && mounted) {
                  await spotify.logout();
                }
              },
            ),
          ),
        ],
      ),
      body: Consumer<ParentalControlsService>(
        builder: (context, parentalControls, _) {
          final filter = parentalControls.currentFilter;
          
          return ListView(
            children: [
              // Security Section
              const ListTile(
                title: Text(
                  'Security',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
              
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Parental PIN'),
                subtitle: Text(parentalControls.isPinSet ? 'Set' : 'Not Set'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showPinDialog(isSetup: true),
              ),

              const Divider(),

              // Content Filtering Section
              const ListTile(
                title: Text(
                  'Content Filtering',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),

              ListTile(
                leading: const Icon(Icons.filter_alt),
                title: const Text('Content Filter'),
                subtitle: Text(filter.blockExplicitContent ? 'Active' : 'Off'),
                trailing: const Icon(Icons.chevron_right),
                onTap: _showFilterOptions,
              ),

              SwitchListTile(
                secondary: const Icon(Icons.explicit),
                title: const Text('Block Explicit Content'),
                subtitle: const Text('Hide songs marked as explicit'),
                value: filter.blockExplicitContent,
                onChanged: (value) async {
                  if (await _verifyPin()) {
                    parentalControls.setFilter(
                      filter.copyWith(blockExplicitContent: value),
                    );
                  }
                },
              ),

              const Divider(),

              // Custom Filters Section
              const ListTile(
                title: Text(
                  'Custom Filters',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),

              ListTile(
                leading: const Icon(Icons.block),
                title: const Text('Blocked Keywords'),
                subtitle: Text('${filter.blockedKeywords.length} keywords'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  if (await _verifyPin()) {
                    // Navigate to blocked keywords screen
                  }
                },
              ),

              const Divider(),

              // About Section
              const ListTile(
                title: Text(
                  'About',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),

              const ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('Version'),
                subtitle: Text('1.0.0'),
              ),

              ListTile(
                leading: const Icon(Icons.restore),
                title: const Text('Reset to Defaults'),
                onTap: () async {
                  if (await _verifyPin()) {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Reset Settings'),
                        content: const Text(
                          'Are you sure you want to reset all parental control settings to defaults?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Reset'),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true && mounted) {
                      await parentalControls.resetToDefaults();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Settings reset to defaults'),
                          ),
                        );
                      }
                    }
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
