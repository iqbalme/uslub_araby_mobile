import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:uslub_araby/providers/theme_provider.dart';
import 'package:uslub_araby/providers/saved_words_provider.dart';
import 'package:uslub_araby/providers/flashcard_deck_provider.dart';
import 'package:uslub_araby/services/notification_service.dart';
import 'package:uslub_araby/services/data_export_import_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _learningReminderEnabled = false;
  bool _newWordReminderEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    final learningEnabled = await NotificationService()
        .isLearningReminderEnabled();
    final newWordEnabled = await NotificationService()
        .isNewWordReminderEnabled();
    setState(() {
      _learningReminderEnabled = learningEnabled;
      _newWordReminderEnabled = newWordEnabled;
    });
  }

  Future<void> _toggleLearningReminder(bool value) async {
    setState(() => _learningReminderEnabled = value);
    await NotificationService().scheduleDailyLearningReminder(value);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value
              ? 'Pengingat belajar diaktifkan'
              : 'Pengingat belajar dinonaktifkan',
        ),
      ),
    );
  }

  Future<void> _toggleNewWordReminder(bool value) async {
    setState(() => _newWordReminderEnabled = value);
    await NotificationService().scheduleDailyNewWordReminder(value);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value
              ? 'Pengingat kata baru diaktifkan'
              : 'Pengingat kata baru dinonaktifkan',
        ),
      ),
    );
  }

  Future<void> _exportData() async {
    try {
      final savedWordsProvider = Provider.of<SavedWordsProvider>(
        context,
        listen: false,
      );
      final flashcardProvider = Provider.of<FlashcardDeckProvider>(
        context,
        listen: false,
      );
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

      final exportService = DataExportImportService();
      final filePath = await exportService.exportData(
        savedWordsProvider: savedWordsProvider,
        flashcardProvider: flashcardProvider,
        themeProvider: themeProvider,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Data berhasil diekspor ke: ${filePath?.split('/').last ?? 'file'}',
          ),
          action: SnackBarAction(label: 'OK', onPressed: () {}),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengekspor data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _importData() async {
    try {
      // Show confirmation dialog first
      final shouldImport = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Impor Data'),
          content: const Text(
            'Apakah Anda yakin ingin mengimpor data? Data yang ada akan digantikan dengan data dari file backup. Tindakan ini tidak dapat dibatalkan.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Impor'),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
          ],
        ),
      );

      if (shouldImport != true) return;

      final savedWordsProvider = Provider.of<SavedWordsProvider>(
        context,
        listen: false,
      );
      final flashcardProvider = Provider.of<FlashcardDeckProvider>(
        context,
        listen: false,
      );
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

      final importService = DataExportImportService();
      final success = await importService.importData(
        savedWordsProvider: savedWordsProvider,
        flashcardProvider: flashcardProvider,
        themeProvider: themeProvider,
      );

      if (!mounted) return;

      if (success) {
        // Reload notification settings after import
        await _loadNotificationSettings();

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Data berhasil diimpor')));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Impor dibatalkan')));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengimpor data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Tampilan',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),

              // Theme Mode
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mode Tema',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildThemeOption(
                              context,
                              'Terang',
                              Icons.light_mode,
                              themeProvider.themeMode == ThemeMode.light,
                              () => themeProvider.setThemeMode(ThemeMode.light),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildThemeOption(
                              context,
                              'Gelap',
                              Icons.dark_mode,
                              themeProvider.themeMode == ThemeMode.dark,
                              () => themeProvider.setThemeMode(ThemeMode.dark),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildThemeOption(
                              context,
                              'Otomatis',
                              Icons.brightness_auto,
                              themeProvider.themeMode == ThemeMode.system,
                              () =>
                                  themeProvider.setThemeMode(ThemeMode.system),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Notifikasi',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),

              // Notification Settings
              _buildSettingItem(
                context,
                'Pengingat Belajar',
                'Dapatkan notifikasi untuk belajar harian',
                Icons.notifications,
                _learningReminderEnabled,
                _toggleLearningReminder,
              ),

              _buildSettingItem(
                context,
                'Pengingat Kata Baru',
                'Notifikasi untuk kata baru setiap hari',
                Icons.add_alert,
                _newWordReminderEnabled,
                _toggleNewWordReminder,
              ),

              const SizedBox(height: 24),

              const Text(
                'Data',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),

              // Data Management
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.refresh, color: Colors.blue),
                      title: const Text('Reset Progress'),
                      subtitle: const Text('Hapus semua kata tersimpan'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        _showResetDialog(context);
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.school, color: Colors.orange),
                      title: const Text('Reset Flashcard Progress'),
                      subtitle: const Text(
                        'Reset status dipelajari dan dikuasai',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        _showResetFlashcardDialog(context);
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.download, color: Colors.green),
                      title: const Text('Ekspor Data'),
                      subtitle: const Text('Simpan data ke file'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _exportData,
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.upload, color: Colors.blue),
                      title: const Text('Impor Data'),
                      subtitle: const Text('Muat data dari file backup'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _importData,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Tentang',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),

              // App Info
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kamus Uslub',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('Versi 1.0.0', style: TextStyle(color: Colors.grey)),
                      SizedBox(height: 4),
                      Text(
                        'Aplikasi untuk belajar ungkapan Arab dengan mudah',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    String label,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SwitchListTile(
        secondary: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    PanaraConfirmDialog.show(
      context,
      title: 'Reset Progress',
      message:
          'Apakah Anda yakin ingin menghapus semua kata yang tersimpan? Tindakan ini tidak dapat dibatalkan.',
      confirmButtonText: 'Reset',
      cancelButtonText: 'Batal',
      onTapConfirm: () {
        // Reset saved words
        final savedWordsProvider = Provider.of<SavedWordsProvider>(
          context,
          listen: false,
        );
        savedWordsProvider.clearAllSavedWords();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Progress berhasil direset')),
        );
        Navigator.of(context, rootNavigator: true).pop();
      },
      onTapCancel: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
      panaraDialogType: PanaraDialogType.warning,
      barrierDismissible: false,
    );
  }

  void _showResetFlashcardDialog(BuildContext context) {
    PanaraConfirmDialog.show(
      context,
      title: 'Reset Flashcard Progress',
      message:
          'Apakah Anda yakin ingin mereset semua progress flashcard? Status "dipelajari" dan "dikuasai" akan dihapus dari semua kartu. Tindakan ini tidak dapat dibatalkan.',
      confirmButtonText: 'Reset',
      cancelButtonText: 'Batal',
      onTapConfirm: () {
        // Reset flashcard progress
        final flashcardProvider = Provider.of<FlashcardDeckProvider>(
          context,
          listen: false,
        );
        flashcardProvider.resetFlashcardProgress();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Progress flashcard berhasil direset')),
        );
        Navigator.of(context, rootNavigator: true).pop();
      },
      onTapCancel: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
      panaraDialogType: PanaraDialogType.warning,
      barrierDismissible: false,
    );
  }
}
