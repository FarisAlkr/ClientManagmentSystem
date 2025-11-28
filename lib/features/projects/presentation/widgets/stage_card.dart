import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/domain/models/project.dart';
import '../../../../core/theme/app_theme.dart';

class StageCard extends StatefulWidget {
  final ProjectStage stage;
  final int stageNumber;
  final String clientId;
  final Function(String itemId, bool isCompleted, String notes) onStageItemUpdate;
  final Function(String title, bool isTextOnly) onAddCustomItem;
  final Function(String itemId) onDeleteItem;
  final VoidCallback? onDeleteStage;
  final Function(String newTitle)? onEditStageTitle;

  const StageCard({
    super.key,
    required this.stage,
    required this.stageNumber,
    required this.clientId,
    required this.onStageItemUpdate,
    required this.onAddCustomItem,
    required this.onDeleteItem,
    this.onDeleteStage,
    this.onEditStageTitle,
  });

  @override
  State<StageCard> createState() => _StageCardState();
}

class _StageCardState extends State<StageCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final completionPercentage = widget.stage.completionPercentage;
    final isComplete = completionPercentage == 1.0;

    return Card(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isComplete
                          ? AppTheme.doneColor.withValues(alpha: 0.1)
                          : AppTheme.neutral.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: isComplete
                          ? const Icon(
                              Icons.check_circle,
                              color: AppTheme.doneColor,
                              size: 24,
                            )
                          : Text(
                              '${widget.stageNumber}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppTheme.neutral,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.stage.title,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (widget.onEditStageTitle != null)
                              IconButton(
                                icon: const Icon(Icons.edit, size: 18),
                                onPressed: () => _showEditTitleDialog(context),
                                color: AppTheme.primaryBlue,
                                tooltip: 'Edit stage title',
                              ),
                            if (widget.onDeleteStage != null)
                              IconButton(
                                icon: const Icon(Icons.delete, size: 18),
                                onPressed: widget.onDeleteStage,
                                color: AppTheme.error,
                                tooltip: 'Delete stage',
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              '${(completionPercentage * 100).round()}% הושלם',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: isComplete ? AppTheme.doneColor : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '(${widget.stage.items.where((item) => !item.isTextOnly && item.isCompleted).length}/${widget.stage.items.where((item) => !item.isTextOnly).length})',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: completionPercentage,
                          backgroundColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isComplete ? AppTheme.doneColor : Theme.of(context).colorScheme.primary,
                          ),
                          minHeight: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ...widget.stage.items.map((item) {
                    return _StageItemTile(
                      item: item,
                      onUpdate: (isCompleted, notes) {
                        widget.onStageItemUpdate(item.id, isCompleted, notes);
                      },
                      onDelete: item.id.startsWith('custom_')
                          ? () => widget.onDeleteItem(item.id)
                          : null,
                    );
                  }),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showAddItemDialog(context, false),
                          icon: const Icon(Icons.add),
                          label: Text(AppLocalizations.of(context)!.addTask),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showAddItemDialog(context, true),
                          icon: const Icon(Icons.text_fields),
                          label: Text(AppLocalizations.of(context)!.addNote),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showAddItemDialog(BuildContext context, bool isTextOnly) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isTextOnly ? AppLocalizations.of(context)!.addNote : AppLocalizations.of(context)!.addTask),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: isTextOnly ? AppLocalizations.of(context)!.writeNote : AppLocalizations.of(context)!.writeTask,
          ),
          maxLines: isTextOnly ? 3 : 1,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                widget.onAddCustomItem(controller.text.trim(), isTextOnly);
                Navigator.of(context).pop();
              }
            },
            child: Text(AppLocalizations.of(context)!.add),
          ),
        ],
      ),
    );
  }

  void _showEditTitleDialog(BuildContext context) {
    final controller = TextEditingController(text: widget.stage.title);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.editStageTitle),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.stageTitle,
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty && widget.onEditStageTitle != null) {
                widget.onEditStageTitle!(controller.text.trim());
                Navigator.of(context).pop();
              }
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }
}

class _StageItemTile extends StatefulWidget {
  final ProjectStageItem item;
  final Function(bool isCompleted, String notes) onUpdate;
  final VoidCallback? onDelete;

  const _StageItemTile({
    required this.item,
    required this.onUpdate,
    this.onDelete,
  });

  @override
  State<_StageItemTile> createState() => _StageItemTileState();
}

class _StageItemTileState extends State<_StageItemTile> {
  late TextEditingController _notesController;
  bool _showNotes = false;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.item.notes);
    _showNotes = widget.item.notes.isNotEmpty;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.item.isTextOnly) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.primaryBlue.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.info_outline,
              size: 16,
              color: AppTheme.primaryBlue,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.item.title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primaryBlueDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (widget.onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete, size: 16),
                onPressed: widget.onDelete,
                color: AppTheme.error,
              ),
          ],
        ),
      );
    }

    final isCompleted = widget.item.isCompleted;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCompleted
              ? AppTheme.doneColor.withValues(alpha: 0.3)
              : AppTheme.neutral.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            leading: Checkbox(
              value: isCompleted,
              onChanged: (value) {
                widget.onUpdate(value ?? false, _notesController.text);
              },
              activeColor: AppTheme.doneColor,
            ),
            title: Text(
              widget.item.title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                decoration: isCompleted ? TextDecoration.lineThrough : null,
                color: isCompleted ? AppTheme.neutralDark : null,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.attach_file,
                    size: 20,
                    color: AppTheme.success,
                  ),
                  onPressed: () => _showFileManager(context),
                  tooltip: AppLocalizations.of(context)!.fileManagement,
                ),
                IconButton(
                  icon: Icon(
                    _showNotes ? Icons.note : Icons.note_add,
                    size: 20,
                    color: _showNotes ? AppTheme.primaryBlue : AppTheme.neutral,
                  ),
                  onPressed: () {
                    setState(() {
                      _showNotes = !_showNotes;
                    });
                  },
                ),
                if (widget.onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20),
                    onPressed: widget.onDelete,
                    color: AppTheme.error,
                  ),
              ],
            ),
          ),
          if (_showNotes)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: TextField(
                controller: _notesController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.addNotes,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
                maxLines: 3,
                onChanged: (value) {
                  widget.onUpdate(widget.item.isCompleted, value);
                },
              ),
            ),
        ],
      ),
    );
  }

  void _showFileManager(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _FileManagerDialog(
        itemId: widget.item.id,
        itemTitle: widget.item.title,
      ),
    );
  }
}

class _FileManagerDialog extends StatefulWidget {
  final String itemId;
  final String itemTitle;

  const _FileManagerDialog({
    required this.itemId,
    required this.itemTitle,
  });

  @override
  State<_FileManagerDialog> createState() => _FileManagerDialogState();
}

class _FileManagerDialogState extends State<_FileManagerDialog> {
  List<Reference> _files = [];
  bool _isLoading = false;
  bool _storageEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    print('Starting _loadFiles...');
    setState(() => _isLoading = true);

    try {
      // Check if user is authenticated first
      final user = FirebaseAuth.instance.currentUser;
      print('Current user: ${user?.uid}');

      if (user == null) {
        throw Exception(AppLocalizations.of(context)!.userNotLoggedIn);
      }

      print('Creating storage reference...');
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('users')
          .child(user.uid)
          .child('projects')
          .child(widget.itemId);

      print('Storage path: ${storageRef.fullPath}');
      print('Calling listAll()...');

      final result = await storageRef.listAll().timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          print('TIMEOUT occurred - likely Storage rules issue');
          throw Exception('Firebase Storage not configured');
        },
      );

      print('listAll() completed. Files found: ${result.items.length}');
      setState(() {
        _files = result.items;
        _isLoading = false;
      });
    } catch (e) {
      print('ERROR in _loadFiles: $e');
      print('ERROR type: ${e.runtimeType}');

      // If it's a permission or timeout error, disable storage functionality
      if (e.toString().contains('Storage') || e.toString().contains('permission') || e.toString().contains('timeout')) {
        setState(() {
          _storageEnabled = false;
          _isLoading = false;
        });
        return;
      }

      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context)!.errorLoadingFiles}: $e')),
        );
      }
    }
  }

  Future<void> _uploadFile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception(AppLocalizations.of(context)!.userNotLoggedIn);
      }

      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true, // Allow multiple file selection
        type: FileType.any,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() => _isLoading = true);

        int uploadedCount = 0;
        int totalFiles = result.files.length;

        // Upload each file
        for (final file in result.files) {
          try {
            final storageRef = FirebaseStorage.instance
                .ref()
                .child('users')
                .child(user.uid)
                .child('projects')
                .child(widget.itemId)
                .child(file.name);

            await storageRef.putData(file.bytes!);
            uploadedCount++;

            // Update progress if there are multiple files
            if (totalFiles > 1 && mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${AppLocalizations.of(context)!.uploaded} $uploadedCount ${AppLocalizations.of(context)!.filesOf} $totalFiles ${AppLocalizations.of(context)!.attachedFiles}'),
                  duration: const Duration(milliseconds: 500),
                ),
              );
            }
          } catch (e) {
            print('Error uploading ${file.name}: $e');
          }
        }

        if (mounted) {
          final message = totalFiles == 1
              ? AppLocalizations.of(context)!.fileUploadedSuccessfully
              : '${AppLocalizations.of(context)!.uploaded} $uploadedCount ${AppLocalizations.of(context)!.filesOf} $totalFiles ${AppLocalizations.of(context)!.filesUploadedSuccessfully}';

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }

        await _loadFiles();
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context)!.errorUploadingFiles}: $e')),
        );
      }
    }
  }

  Future<void> _downloadFile(Reference fileRef) async {
    try {
      final url = await fileRef.getDownloadURL();
      // For web, we'll show the URL - user can right-click to save
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.downloadingFile),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${AppLocalizations.of(context)!.file}: ${fileRef.name}'),
              const SizedBox(height: 16),
              SelectableText(url),
              const SizedBox(height: 16),
              Text(AppLocalizations.of(context)!.copyLinkOrClickToDownload),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.close),
            ),
            ElevatedButton(
              onPressed: () async {
                // Open URL in new tab
                html.window.open(url, '_blank');
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.download),
            ),
          ],
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context)!.errorDownloadingFile}: $e')),
        );
      }
    }
  }

  Future<void> _downloadAllFiles() async {
    if (_files.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.noFilesToDownload)),
      );
      return;
    }

    try {
      setState(() => _isLoading = true);

      List<String> downloadUrls = [];
      int processedCount = 0;

      // Get download URLs for all files
      for (final file in _files) {
        try {
          final url = await file.getDownloadURL();
          downloadUrls.add(url);
          processedCount++;

          // Show progress
          if (mounted && _files.length > 1) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${AppLocalizations.of(context)!.preparingDownload}: $processedCount ${AppLocalizations.of(context)!.filesOf} ${_files.length} ${AppLocalizations.of(context)!.attachedFiles}'),
                duration: const Duration(milliseconds: 300),
              ),
            );
          }
        } catch (e) {
          print('Error getting download URL for ${file.name}: $e');
        }
      }

      setState(() => _isLoading = false);

      if (downloadUrls.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.cannotDownloadFiles)),
        );
        return;
      }

      // Show download dialog with all URLs
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.downloadAllFiles),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${downloadUrls.length} ${AppLocalizations.of(context)!.filesReady}'),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: downloadUrls.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.file_download),
                          title: Text(_files[index].name),
                          trailing: IconButton(
                            icon: const Icon(Icons.open_in_new),
                            onPressed: () {
                              html.window.open(downloadUrls[index], '_blank');
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.close),
            ),
            ElevatedButton(
              onPressed: () {
                // Open all URLs in new tabs
                for (final url in downloadUrls) {
                  html.window.open(url, '_blank');
                }
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${AppLocalizations.of(context)!.downloading} ${downloadUrls.length} ${AppLocalizations.of(context)!.attachedFiles}...')),
                );
              },
              child: Text(AppLocalizations.of(context)!.downloadAll),
            ),
          ],
        ),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context)!.error}: $e')),
        );
      }
    }
  }

  Future<void> _deleteFile(Reference fileRef) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deletingFile),
        content: Text('${AppLocalizations.of(context)!.confirmDeleteFile} ${fileRef.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          throw Exception(AppLocalizations.of(context)!.userNotLoggedIn);
        }

        setState(() => _isLoading = true);
        await fileRef.delete();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.fileDeletedSuccessfully)),
          );
        }

        await _loadFiles();
      } catch (e) {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${AppLocalizations.of(context)!.errorDeletingFile}: $e')),
          );
        }
      }
    }
  }

  IconData _getFileIcon(String fileName) {
    final extension = fileName.toLowerCase().split('.').last;
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image;
      case 'mp4':
      case 'avi':
      case 'mkv':
        return Icons.video_file;
      case 'mp3':
      case 'wav':
        return Icons.audio_file;
      case 'zip':
      case 'rar':
        return Icons.archive;
      case 'txt':
        return Icons.text_snippet;
      default:
        return Icons.insert_drive_file;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: 650,
        height: 600,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.grey.withOpacity(0.02),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryBlue,
                          AppTheme.primaryBlueDark,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryBlue.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.folder_open,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.fileManagement,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2D3748),
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          widget.itemTitle,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Upload Section
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primaryBlue.withOpacity(0.05),
                            AppTheme.primaryBlue.withOpacity(0.02),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.primaryBlue.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryBlue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.cloud_upload,
                                  color: AppTheme.primaryBlue,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                AppLocalizations.of(context)!.uploadNewFiles,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primaryBlueDark,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            AppLocalizations.of(context)!.uploadOneOrMoreFiles,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.primaryBlue,
                                    AppTheme.primaryBlueDark,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryBlue.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ElevatedButton.icon(
                                onPressed: (_isLoading || !_storageEnabled) ? null : _uploadFile,
                                icon: const Icon(Icons.upload_file, color: Colors.white),
                                label: Text(
                                  _storageEnabled ? AppLocalizations.of(context)!.chooseFilesToUpload : AppLocalizations.of(context)!.storageNotAvailable,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Divider with label
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.grey[300],
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            AppLocalizations.of(context)!.existingFiles,
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.grey[300],
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Files Section
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.success.withOpacity(0.05),
                            AppTheme.success.withOpacity(0.02),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.success.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.success.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.folder,
                                  color: AppTheme.success,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  '${AppLocalizations.of(context)!.attachedFiles} (${_files.length})',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.success,
                                  ),
                                ),
                              ),
                              if (_files.isNotEmpty)
                                OutlinedButton.icon(
                                  onPressed: (_isLoading || !_storageEnabled) ? null : _downloadAllFiles,
                                  icon: const Icon(Icons.download, size: 18),
                                  label: Text(AppLocalizations.of(context)!.downloadAll),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppTheme.success,
                                    side: BorderSide(color: AppTheme.success),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Files list or states
                          _isLoading
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(32),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const CircularProgressIndicator(),
                                        const SizedBox(height: 16),
                                        Text(AppLocalizations.of(context)!.loadingFiles),
                                      ],
                                    ),
                                  ),
                                )
                              : !_storageEnabled
                                  ? Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(32),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.cloud_off, size: 64, color: AppTheme.warning),
                                            const SizedBox(height: 16),
                                            Text(
                                              AppLocalizations.of(context)!.firebaseStorageNotConfigured,
                                              style: TextStyle(color: AppTheme.warning, fontSize: 18, fontWeight: FontWeight.w600),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              AppLocalizations.of(context)!.needToConfigureStorageRules,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(color: AppTheme.neutralDark),
                                            ),
                                            const SizedBox(height: 16),
                                            ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  _storageEnabled = true;
                                                });
                                                _loadFiles();
                                              },
                                              child: Text(AppLocalizations.of(context)!.tryAgain),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : _files.isEmpty
                                      ? Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(32),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.folder_open, size: 64, color: Colors.grey[400]),
                                                const SizedBox(height: 16),
                                                Text(
                                                  AppLocalizations.of(context)!.noFilesAttached,
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  AppLocalizations.of(context)!.uploadFilesUsingButtonAbove,
                                                  style: TextStyle(
                                                    color: Colors.grey[500],
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : Column(
                                          children: _files.map((file) {
                                            return Container(
                                              margin: const EdgeInsets.only(bottom: 8),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: Colors.grey.withOpacity(0.2),
                                                  width: 1,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.03),
                                                    blurRadius: 5,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: ListTile(
                                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                leading: Container(
                                                  padding: const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: AppTheme.success.withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Icon(
                                                    _getFileIcon(file.name),
                                                    color: AppTheme.success,
                                                    size: 24,
                                                  ),
                                                ),
                                                title: Text(
                                                  file.name,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  AppLocalizations.of(context)!.fileAttachedToTask,
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                trailing: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: AppTheme.success.withOpacity(0.1),
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      child: IconButton(
                                                        onPressed: () => _downloadFile(file),
                                                        icon: Icon(Icons.download, color: AppTheme.success, size: 20),
                                                        tooltip: AppLocalizations.of(context)!.downloadFile,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: AppTheme.error.withOpacity(0.1),
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      child: IconButton(
                                                        onPressed: () => _deleteFile(file),
                                                        icon: Icon(Icons.delete, color: AppTheme.error, size: 20),
                                                        tooltip: AppLocalizations.of(context)!.deleteFile,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}