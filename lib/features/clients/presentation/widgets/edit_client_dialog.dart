import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/domain/models/client.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/clients_repository.dart';
import '../providers/clients_provider.dart';
import '../../../cities/presentation/providers/cities_provider.dart';

class EditClientDialog extends ConsumerStatefulWidget {
  final Client client;

  const EditClientDialog({
    super.key,
    required this.client,
  });

  @override
  ConsumerState<EditClientDialog> createState() => _EditClientDialogState();
}

class _EditClientDialogState extends ConsumerState<EditClientDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _idController;
  late final TextEditingController _committeeController;
  String? _selectedCommittee;
  bool _isLoading = false;
  bool _showCommitteeDropdown = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.client.name);
    _addressController = TextEditingController(text: widget.client.propertyAddress);
    _idController = TextEditingController(text: widget.client.idNumber);
    _committeeController = TextEditingController(text: widget.client.handlingCommittee);
    _selectedCommittee = widget.client.handlingCommittee;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _idController.dispose();
    _committeeController.dispose();
    super.dispose();
  }


  void _selectCommittee(String committee) {
    setState(() {
      _selectedCommittee = committee;
      _committeeController.text = committee;
      _showCommitteeDropdown = false;
    });
  }

  Future<void> _updateClient() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final repository = ref.read(clientsRepositoryProvider);
      final committeeValue = _selectedCommittee ?? _committeeController.text.trim();
      if (committeeValue.isEmpty) {
        throw Exception(AppLocalizations.of(context)!.pleaseSelectHandlingCommittee);
      }

      await repository.updateClient(
        widget.client.id,
        name: _nameController.text.trim(),
        propertyAddress: _addressController.text.trim(),
        idNumber: _idController.text.trim(),
        handlingCommittee: committeeValue,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.clientDetailsUpdatedSuccessfully),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppLocalizations.of(context)!.error}: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String? _validateIdNumber(String? value) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return l10n.pleaseEnterIdNumber;
    }

    final cleanValue = value.trim();
    if (cleanValue.length != 9) {
      return l10n.idMustBe9Digits;
    }

    if (!RegExp(r'^\d{9}$').hasMatch(cleanValue)) {
      return l10n.idMustContainOnlyDigits;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: 550,
        constraints: const BoxConstraints(maxHeight: 700),
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
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange,
                          Colors.deepOrange,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      '${l10n.editClientDetails} ${widget.client.name}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2D3748),
                        fontSize: 18,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Form
              Flexible(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: l10n.clientNameLabel,
                              hintText: l10n.fullName,
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.orange,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              labelStyle: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return l10n.pleaseEnterClientName;
                              }
                              if (value.trim().length < 2) {
                                return l10n.clientNameMin2Chars;
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: TextFormField(
                            controller: _addressController,
                            decoration: InputDecoration(
                              labelText: l10n.propertyAddressLabel,
                              hintText: l10n.streetNumberCity,
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              prefixIcon: Icon(
                                Icons.home,
                                color: Colors.orange,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              labelStyle: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            maxLines: 2,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return l10n.pleaseEnterPropertyAddress;
                              }
                              if (value.trim().length < 5) {
                                return l10n.propertyAddressMin5Chars;
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: TextFormField(
                            controller: _idController,
                            decoration: InputDecoration(
                              labelText: l10n.idNumberLabel,
                              hintText: '123456789',
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              prefixIcon: Icon(
                                Icons.badge,
                                color: Colors.orange,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              labelStyle: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: _validateIdNumber,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: TextFormField(
                                controller: _committeeController,
                                decoration: InputDecoration(
                                  labelText: l10n.handlingCommitteeLabel,
                                  hintText: l10n.searchOrSelectCommittee,
                                  hintStyle: TextStyle(color: Colors.grey[500]),
                                  prefixIcon: Icon(
                                    Icons.business,
                                    color: Colors.orange,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _showCommitteeDropdown
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: Colors.orange,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _showCommitteeDropdown = !_showCommitteeDropdown;
                                      });
                                    },
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCommittee = null;
                                    _showCommitteeDropdown = true;
                                  });
                                },
                                onTap: () {
                                  setState(() {
                                    _showCommitteeDropdown = true;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return l10n.pleaseSelectHandlingCommittee;
                                  }
                                  _selectedCommittee = value.trim();
                                  return null;
                                },
                              ),
                            ),
                            if (_showCommitteeDropdown) ...[
                              const SizedBox(height: 8),
                              Consumer(
                                builder: (context, ref, child) {
                                  final citiesAsync = ref.watch(citiesStreamProvider);
                                  return citiesAsync.when(
                                    data: (cities) {
                                      final query = _committeeController.text.toLowerCase();
                                      final filtered = query.isEmpty
                                          ? cities
                                          : cities
                                              .where((c) => c.name.toLowerCase().contains(query))
                                              .toList();

                                      return Container(
                                        constraints: const BoxConstraints(maxHeight: 200),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey.shade300),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: filtered.isEmpty
                                            ? Padding(
                                                padding: const EdgeInsets.all(16),
                                                child: Text(
                                                  l10n.noCommitteesFound,
                                                  style: const TextStyle(color: Colors.grey),
                                                  textAlign: TextAlign.center,
                                                ),
                                              )
                                            : ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: filtered.length,
                                                itemBuilder: (context, index) {
                                                  final city = filtered[index];
                                                  return ListTile(
                                                    dense: true,
                                                    title: Text(city.name),
                                                    onTap: () => _selectCommittee(city.name),
                                                    selected: _selectedCommittee == city.name,
                                                    selectedTileColor: Colors.orange.withValues(alpha: 0.1),
                                                  );
                                                },
                                              ),
                                      );
                                    },
                                    loading: () => const Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Center(child: CircularProgressIndicator()),
                                    ),
                                    error: (_, __) => Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Text(
                                        l10n.errorLoadingCommittees,
                                        style: const TextStyle(color: Colors.red),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.requiredFields,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      l10n.cancel,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.orange, Colors.deepOrange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _updateClient,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              l10n.updateDetails,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
