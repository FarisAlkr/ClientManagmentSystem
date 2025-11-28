import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../../../../l10n/app_localizations.dart';
import '../providers/settings_provider.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../cities/data/cities_repository.dart';
import '../../../cities/presentation/providers/cities_provider.dart';
import '../../../clients/data/clients_repository.dart';
import '../../../clients/presentation/providers/clients_provider.dart';
import '../../../projects/data/projects_repository.dart';
import '../../data/backup_service.dart';
import '../../data/user_profile_service.dart';
import '../../../auth/data/services/user_service.dart';
import '../../../auth/presentation/providers/user_provider.dart';
import '../../../../shared/domain/models/app_user.dart';
import '../../../../shared/presentation/widgets/profile_picture_widget.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    final themeMode = ref.watch(themeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;
    final currentLanguage = ref.watch(currentLanguageProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Section
            _buildProfileSection(context, user),
            const SizedBox(height: 24),

            // App Settings Section
            _buildSettingsSection(
              context,
              ref,
              l10n,
              isDarkMode,
              currentLanguage,
            ),
            const SizedBox(height: 24),

            // Backup & Restore Section
            _buildBackupSection(context, ref),
            const SizedBox(height: 24),

            // About Section
            _buildAboutSection(context, l10n),
            const SizedBox(height: 24),

            // Sign Out Button
            _buildSignOutButton(context, ref, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, User? user) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (user != null)
                  ref.watch(appUserProvider).when(
                        data: (appUser) {
                          return GestureDetector(
                            onTap: () => _showProfilePictureOptions(context, user),
                            child: ProfilePictureWidget(
                              imageUrl: appUser?.profilePictureUrl,
                              email: user.email ?? '',
                              size: 70,
                              enableUpload: true,
                              onUploadPressed: () => _showProfilePictureOptions(context, user),
                            ),
                          );
                        },
                        loading: () {
                          return CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.blue.withValues(alpha: 0.1),
                            child: const Icon(Icons.person, size: 30, color: Colors.blue),
                          );
                        },
                        error: (error, stack) {
                          return CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.red.withValues(alpha: 0.1),
                            child: const Icon(Icons.error, size: 30, color: Colors.red),
                          );
                        },
                      )
                else
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.blue.withValues(alpha: 0.1),
                    child: const Icon(Icons.person, size: 30, color: Colors.blue),
                  ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.displayName ?? l10n.user,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? l10n.unknown,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: user?.emailVerified == true ? Colors.green : Colors.orange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          user?.emailVerified == true ? l10n.verified : l10n.notVerified,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 16, color: Colors.blue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${l10n.registered}: ${_formatDate(user?.metadata.creationTime)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProfilePictureOptions(BuildContext context, User user) {
    print('🖼️ _showProfilePictureOptions dialog requested');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Profile Picture'),
        content: const Text('Choose an action'),
        actions: [
          TextButton(
            onPressed: () {
              print('❌ User canceled profile picture dialog');
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              print('🗑️ User selected Delete in dialog');
              Navigator.pop(context);
              _deleteProfilePicture(context, user);
            },
            child: const Text('Delete'),
          ),
          TextButton(
            onPressed: () {
              print('✅ User selected Upload in dialog');
              Navigator.pop(context);
              _uploadProfilePicture(context, user);
            },
            child: const Text('Upload'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteProfilePicture(BuildContext context, User user) async {
    try {
      print('🗑️ Starting profile picture deletion...');

      // Get current profile picture URL before deletion to clear from cache
      final appUser = await ref.read(appUserProvider.future);
      final oldUrl = appUser?.profilePictureUrl;

      final profileService = UserProfileService();
      await profileService.deleteProfilePicture(user.uid);
      print('✅ Profile picture deleted from storage and Firestore');

      if (context.mounted) {
        // Clear CachedNetworkImage cache for the old URL (non-web only)
        if (!kIsWeb && oldUrl != null && oldUrl.isNotEmpty) {
          await CachedNetworkImage.evictFromCache(oldUrl);
          print('✅ Evicted old profile picture from CachedNetworkImage cache (mobile)');
        }

        // Clear Flutter's image cache as well
        imageCache.clearLiveImages();
        imageCache.clear();
        print('✅ Cleared Flutter image cache');

        // Note: No need to invalidate provider since we're using StreamProvider
        // The Firestore stream will automatically update with the new data

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile picture deleted successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('❌ Error in _deleteProfilePicture: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting profile picture: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _uploadProfilePicture(BuildContext context, User user) async {
    try {
      print('📤 Starting profile picture upload...');

      // Get current profile picture URL before upload to clear from cache
      final oldAppUser = await ref.read(appUserProvider.future);
      final oldUrl = oldAppUser?.profilePictureUrl;

      // Show loading dialog FIRST before doing anything else
      if (!context.mounted) {
        return;
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Uploading profile picture...'),
            ],
          ),
        ),
      );

      // NOW pick files (with dialog already showing)
      print('📁 Opening file picker...');
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        print('❌ No file selected');
        if (context.mounted) Navigator.pop(context);
        return;
      }

      final file = result.files.first;
      print('✅ File selected: ${file.name}');

      if (file.bytes == null) {
        if (context.mounted) Navigator.pop(context);
        throw Exception('Cannot read file');
      }

      final profileService = UserProfileService();

      try {
        print('☁️ Uploading to Firebase...');
        final downloadUrl = await profileService
            .uploadProfilePicture(user.uid, file.bytes!)
            .timeout(
              const Duration(minutes: 2),
              onTimeout: () {
                throw Exception('Upload timeout - took longer than 2 minutes');
              },
            );

        print('✅ Upload complete, new URL: $downloadUrl');

        if (context.mounted) {
          Navigator.pop(context); // Close loading dialog
        }
      } on TimeoutException catch (e) {
        print('❌ Upload timeout: $e');
        if (context.mounted) {
          Navigator.pop(context); // Close loading dialog
        }
        throw Exception('Upload timeout: ${e.toString()}');
      }

      if (context.mounted) {
        // Clear CachedNetworkImage cache for the old URL (non-web only)
        if (!kIsWeb && oldUrl != null && oldUrl.isNotEmpty) {
          await CachedNetworkImage.evictFromCache(oldUrl);
          print('✅ Evicted old profile picture from CachedNetworkImage cache (mobile)');
        }

        // Clear Flutter's image cache to force reload of the new image
        imageCache.clearLiveImages();
        imageCache.clear();
        print('✅ Cleared Flutter image cache');

        // Note: No need to invalidate provider since we're using StreamProvider
        // The Firestore stream will automatically push the update with the new URL
        print('ℹ️ StreamProvider will automatically receive updated data from Firestore');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile picture updated successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('❌ Error in _uploadProfilePicture: $e');
      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog if still open
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading profile picture: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildSettingsSection(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    bool isDarkMode,
    String currentLanguage,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.appSettings,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Dark Mode Toggle
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: Colors.blue,
              ),
              title: Text(l10n.darkModeToggle),
              subtitle: Text(isDarkMode ? l10n.enabled : l10n.disabled),
              trailing: Switch(
                value: isDarkMode,
                onChanged: (value) {
                  ref.read(themeProvider.notifier).toggleTheme();
                },
              ),
            ),

            const Divider(),

            // Language Selection
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.language, color: Colors.blue),
              title: Text(l10n.language),
              subtitle: Text(currentLanguage == 'he' ? l10n.hebrew : l10n.english),
              trailing: DropdownButton<String>(
                value: currentLanguage,
                underline: const SizedBox(),
                items: [
                  DropdownMenuItem(value: 'he', child: Text(l10n.hebrew)),
                  DropdownMenuItem(value: 'en', child: Text(l10n.english)),
                ],
                onChanged: (value) {
                  if (value != null) {
                    ref.read(currentLanguageProvider.notifier).setLanguage(value);
                  }
                },
              ),
            ),

            const Divider(),

            // Manage Committees
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.gavel, color: Colors.blue),
              title: Text(l10n.manageCommittees),
              subtitle: Text(l10n.addEditDeleteCommittees),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                context.go('/committees');
              },
            ),

            const Divider(),

            // Export Data
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.download, color: Colors.blue),
              title: Text(l10n.exportData),
              subtitle: Text(l10n.exportAllYourData),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _showExportDialog(context, ref);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.aboutApp,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.info, color: Colors.blue),
              title: Text(l10n.version),
              subtitle: const Text('1.0.0'),
            ),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.business, color: Colors.blue),
              title: Text(l10n.clientManagementSystem),
            ),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.support, color: Colors.blue),
              title: Text(l10n.technicalSupport),
              subtitle: const Text('support@example.com'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Open email or support
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignOutButton(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showSignOutDialog(context, ref),
        icon: const Icon(Icons.logout),
        label: Text(l10n.disconnect),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.signOutTitle),
        content: Text(l10n.confirmSignOut),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await ref.read(settingsProvider.notifier).signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.disconnect),
          ),
        ],
      ),
    );
  }

  void _showExportDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.exportDataTitle),
        content: Text(l10n.exportDataConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _exportAllData(context, ref);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.exportDataButton),
          ),
        ],
      ),
    );
  }

  Future<void> _exportAllData(BuildContext context, WidgetRef ref) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Text(AppLocalizations.of(context)!.exportingData),
            ],
          ),
        ),
      );

      // Fetch all data
      final citiesRepo = CitiesRepository();
      final clientsRepo = ref.read(clientsRepositoryProvider);
      final projectsRepo = ProjectsRepository();
      final userService = UserService();
      final user = FirebaseAuth.instance.currentUser;

      // Get current user's data including profile picture
      AppUser? currentAppUser;
      Uint8List? profileImageBytes;
      if (user != null) {
        currentAppUser = await userService.getUserDocument(user.uid);
        // Pre-fetch profile image if it exists
        if (currentAppUser?.profilePictureUrl != null) {
          try {
            profileImageBytes = await _getImageBytes(currentAppUser!.profilePictureUrl!);
          } catch (e) {
            print('Error fetching profile image: $e');
          }
        }
      }

      final cities = await citiesRepo.getCities();

      // Get all clients for all cities
      final allClients = <dynamic>[];
      for (final city in cities) {
        try {
          final cityClients = await clientsRepo.getClientsByCity(city.id);
          for (final client in cityClients) {
            allClients.add({
              'client': client,
              'cityName': city.name,
            });
          }
        } catch (e) {
          print('Error fetching clients for city ${city.name}: $e');
        }
      }

      // Get all projects for all clients
      final allProjects = <dynamic>[];
      for (final clientData in allClients) {
        try {
          final projects = await projectsRepo.getProjectsByClient(clientData['client'].id);
          for (final project in projects) {
            allProjects.add({
              'project': project,
              'clientName': clientData['client'].name,
              'cityName': clientData['cityName'],
            });
          }
        } catch (e) {
          print('Error fetching projects for client ${clientData['client'].name}: $e');
        }
      }

      // Create PDF
      final pdf = pw.Document();

      // Add Overview Page
      pdf.addPage(
        pw.MultiPage(
          textDirection: pw.TextDirection.rtl,
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) => [
            // Header
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(
                    'ייצוא נתונים מלא',
                    style: pw.TextStyle(
                      fontSize: 28,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    'מערכת ניהול לקוחות ופרויקטים דרומיים',
                    style: pw.TextStyle(
                      fontSize: 16,
                      color: PdfColors.grey600,
                    ),
                  ),
                  pw.Divider(thickness: 2, color: PdfColors.blue),
                ],
              ),
            ),

            pw.SizedBox(height: 24),

            // User Information
            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // Profile Picture
                      if (profileImageBytes != null)
                        pw.Container(
                          width: 100,
                          height: 100,
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(color: PdfColors.blue),
                            borderRadius: pw.BorderRadius.circular(50),
                          ),
                          child: pw.Image(
                            pw.MemoryImage(profileImageBytes),
                          ),
                        ),
                      pw.SizedBox(width: 16),
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'פרטי המשתמש:',
                              style: pw.TextStyle(
                                fontSize: 18,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.SizedBox(height: 12),
                            _buildPdfDataRow('שם משתמש:', user?.displayName ?? 'לא ידוע'),
                            pw.SizedBox(height: 8),
                            _buildPdfDataRow('כתובת אימייל:', user?.email ?? 'לא ידוע'),
                            pw.SizedBox(height: 8),
                            _buildPdfDataRow('תאריך הצטרפות:', _formatDate(user?.metadata.creationTime)),
                            pw.SizedBox(height: 8),
                            _buildPdfDataRow('תאריך ייצוא:', _formatDate(DateTime.now())),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 24),

            // Statistics
            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                color: PdfColors.blue50,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'סטטיסטיקות כלליות:',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 12),
                  _buildPdfDataRow('סך הכל ערים:', '${cities.length}'),
                  pw.SizedBox(height: 8),
                  _buildPdfDataRow('סך הכל לקוחות:', '${allClients.length}'),
                  pw.SizedBox(height: 8),
                  _buildPdfDataRow('סך הכל פרויקטים:', '${allProjects.length}'),
                ],
              ),
            ),
          ],
        ),
      );

      // Add Cities Page
      if (cities.isNotEmpty) {
        pdf.addPage(
          pw.MultiPage(
            textDirection: pw.TextDirection.rtl,
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) => [
              pw.Text(
                'רשימת ערים וועדות',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 16),
              ...cities.map((city) => pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 12),
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      city.name,
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'נוצר: ${_formatDate(city.createdAt)}',
                      style: pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ],
          ),
        );
      }

      // Add Clients Pages
      if (allClients.isNotEmpty) {
        pdf.addPage(
          pw.MultiPage(
            textDirection: pw.TextDirection.rtl,
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) => [
              pw.Text(
                'רשימת לקוחות',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 16),
              ...allClients.map((clientData) {
                final client = clientData['client'];
                final cityName = clientData['cityName'];
                return pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 16),
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        client.name,
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 8),
                      _buildPdfDataRow('ת.ז:', client.idNumber),
                      pw.SizedBox(height: 4),
                      _buildPdfDataRow('כתובת:', client.propertyAddress),
                      pw.SizedBox(height: 4),
                      _buildPdfDataRow('ועדה:', client.handlingCommittee),
                      pw.SizedBox(height: 4),
                      _buildPdfDataRow('עיר:', cityName),
                      pw.SizedBox(height: 4),
                      _buildPdfDataRow('נוצר:', _formatDate(client.createdAt)),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        );
      }

      // Add Projects Pages
      if (allProjects.isNotEmpty) {
        pdf.addPage(
          pw.MultiPage(
            textDirection: pw.TextDirection.rtl,
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) => [
              pw.Text(
                'רשימת פרויקטים',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 16),
              ...allProjects.map((projectData) {
                final project = projectData['project'];
                final clientName = projectData['clientName'];
                final cityName = projectData['cityName'];
                return pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 16),
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        project.title,
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 8),
                      _buildPdfDataRow('לקוח:', clientName),
                      pw.SizedBox(height: 4),
                      _buildPdfDataRow('עיר:', cityName),
                      pw.SizedBox(height: 4),
                      _buildPdfDataRow('סטטוס:', project.status),
                      pw.SizedBox(height: 4),
                      _buildPdfDataRow('תאריך התחלה:', _formatDate(project.startDate)),
                      if (project.endDate != null) ...[
                        pw.SizedBox(height: 4),
                        _buildPdfDataRow('תאריך סיום:', _formatDate(project.endDate)),
                      ],
                      pw.SizedBox(height: 4),
                      _buildPdfDataRow('נוצר:', _formatDate(project.createdAt)),
                      if (project.description.isNotEmpty) ...[
                        pw.SizedBox(height: 8),
                        pw.Text(
                          'תיאור:',
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          project.description,
                          style: const pw.TextStyle(fontSize: 12),
                        ),
                      ],
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        );
      }

      // Close loading dialog
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      // Show PDF
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.dataExportedSuccessfully),
            backgroundColor: Colors.green,
          ),
        );
      }

    } catch (e) {
      // Close loading dialog if still open
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppLocalizations.of(context)!.errorExportingData}: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  pw.Widget _buildPdfDataRow(String label, String value) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          width: 100,
          child: pw.Text(
            label,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        pw.Expanded(
          child: pw.Text(
            value,
            style: const pw.TextStyle(
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildBackupSection(BuildContext context, WidgetRef ref) {
    final backupService = BackupService();
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.backup, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  l10n.backupAndRestore,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.backupAllData,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),

            // Export Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _exportData(context, backupService),
                icon: const Icon(Icons.download),
                label: Text(l10n.exportAllDataBackup),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Import Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _importData(context, ref, backupService),
                icon: const Icon(Icons.upload),
                label: Text(l10n.restoreDataFromBackup),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),

            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.amber, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'שחזור נתונים יוסיף את הנתונים מהגיבוי ללא מחיקת נתונים קיימים',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportData(BuildContext context, BackupService backupService) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      await backupService.exportAllData();

      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ ${AppLocalizations.of(context)!.dataExportedSuccessfully}!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ ${AppLocalizations.of(context)!.errorExportingData}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _importData(BuildContext context, WidgetRef ref, BackupService backupService) async {
    try {
      // Pick JSON file
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        return;
      }

      final file = result.files.first;
      if (file.bytes == null) {
        throw Exception('Cannot read file'); // Not in translation
      }

      final jsonContent = utf8.decode(file.bytes!);

      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      final importResult = await backupService.importData(jsonContent);

      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading

        if (importResult.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '✅ Data restored successfully!\n' // Not fully in translation
                'Cities: ${importResult.citiesImported}\n'
                'Clients: ${importResult.clientsImported}\n'
                'Projects: ${importResult.projectsImported}\n\n'
                'Refresh to see new data',
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 6),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ ${AppLocalizations.of(context)!.error}: ${importResult.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading if open
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ ${AppLocalizations.of(context)!.error}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Fetch image bytes from URL for PDF embedding
  /// Uses Firebase Storage API directly to avoid CORS issues with http.get()
  Future<Uint8List> _getImageBytes(String imageUrl) async {
    try {
      print('📥 Fetching image bytes for PDF from URL: $imageUrl');

      // Parse the URL to extract the file path
      // URL format: https://firebasestorage.googleapis.com/v0/b/bucket/o/users%2FUID%2Fprofile_pictures%2Favatar_timestamp.png?alt=media&token=...
      final uri = Uri.parse(imageUrl);

      // Extract the path from the URL (everything between '/o/' and '?')
      final pathSegments = uri.pathSegments;
      final oIndex = pathSegments.indexOf('o');
      if (oIndex == -1 || oIndex >= pathSegments.length - 1) {
        throw Exception('Invalid Firebase Storage URL format');
      }

      // Get the encoded path and decode it
      final encodedPath = pathSegments[oIndex + 1];
      final decodedPath = Uri.decodeComponent(encodedPath);
      print('📂 Extracted path: $decodedPath');

      // Use Firebase Storage's getData method which handles CORS properly
      final ref = FirebaseStorage.instance.ref(decodedPath);
      final bytes = await ref.getData(10 * 1024 * 1024); // 10MB max

      if (bytes != null) {
        print('✅ Image bytes fetched successfully: ${bytes.length} bytes');
        return bytes;
      } else {
        print('⚠️ getData returned null');
        throw Exception('Failed to fetch image bytes');
      }
    } catch (e) {
      print('❌ Error fetching image bytes for PDF: $e');
    }

    // Return a transparent 1x1 pixel as fallback
    print('ℹ️ Using transparent 1x1 pixel as fallback');
    return Uint8List.fromList([
      0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,
      0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
      0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
      0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
      0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41,
      0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
      0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00,
      0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE,
      0x42, 0x60, 0x82
    ]);
  }
}