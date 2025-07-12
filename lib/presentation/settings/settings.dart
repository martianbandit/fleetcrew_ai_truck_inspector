import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/profile_header_widget.dart';
import './widgets/settings_item_widget.dart';
import './widgets/settings_section_widget.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _isFrenchLanguage = true;
  bool _isMetricUnits = true;
  bool _notificationsEnabled = true;
  bool _complianceAlertsEnabled = true;
  bool _systemUpdatesEnabled = false;
  bool _gpsEmbeddingEnabled = true;
  bool _autoSyncEnabled = true;
  String _photoQuality = 'Haute';
  String _storageLocation = 'Interne';
  String _reportFormat = 'PDF';

  final List<Map<String, dynamic>> _bluetoothDevices = [
    {
      "name": "Capteur TPMS #1",
      "type": "TPMS",
      "status": "Connecté",
      "batteryLevel": 85,
      "lastSync": "Il y a 2 min"
    },
    {
      "name": "Outil Diagnostic OBD",
      "type": "Diagnostic",
      "status": "Déconnecté",
      "batteryLevel": 0,
      "lastSync": "Il y a 1 heure"
    },
    {
      "name": "Scanner Code-barres",
      "type": "Scanner",
      "status": "Connecté",
      "batteryLevel": 92,
      "lastSync": "Il y a 5 min"
    }
  ];

  final Map<String, dynamic> _userProfile = {
    "name": "Jean-Pierre Dubois",
    "certification": "Inspecteur Certifié Niveau 3",
    "employeeId": "FC-2024-1157",
    "department": "Inspection Flotte",
    "avatar":
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
    "lastInspection": "2025-01-11 14:30:00",
    "totalInspections": 1247
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        foregroundColor: AppTheme.lightTheme.appBarTheme.foregroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        title: Text(
          'Paramètres',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showHelpDialog(),
            icon: CustomIconWidget(
              iconName: 'help_outline',
              color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
              size: 24,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            ProfileHeaderWidget(
              userProfile: _userProfile,
              onEditProfile: () => _navigateToEditProfile(),
            ),

            SizedBox(height: 3.h),

            // Language Settings
            SettingsSectionWidget(
              title: 'Langue et Région',
              children: [
                SettingsItemWidget(
                  title: 'Langue',
                  subtitle: _isFrenchLanguage ? 'Français' : 'English',
                  leadingIcon: 'language',
                  trailing: Switch(
                    value: _isFrenchLanguage,
                    onChanged: (value) => _toggleLanguage(value),
                    activeColor: AppTheme.lightTheme.colorScheme.primary,
                  ),
                  onTap: () => _toggleLanguage(!_isFrenchLanguage),
                ),
                SettingsItemWidget(
                  title: 'Unités de Mesure',
                  subtitle: _isMetricUnits
                      ? 'Métrique (km, L, kg)'
                      : 'Impérial (mi, gal, lb)',
                  leadingIcon: 'straighten',
                  trailing: Switch(
                    value: _isMetricUnits,
                    onChanged: (value) =>
                        setState(() => _isMetricUnits = value),
                    activeColor: AppTheme.lightTheme.colorScheme.primary,
                  ),
                  onTap: () => setState(() => _isMetricUnits = !_isMetricUnits),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Bluetooth Devices
            SettingsSectionWidget(
              title: 'Appareils Bluetooth',
              children: [
                ..._bluetoothDevices
                    .map((device) => SettingsItemWidget(
                          title: device["name"] as String,
                          subtitle:
                              '${device["type"]} • ${device["status"]} • ${device["lastSync"]}',
                          leadingIcon: _getDeviceIcon(device["type"] as String),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if ((device["batteryLevel"] as int) > 0) ...[
                                CustomIconWidget(
                                  iconName: 'battery_std',
                                  color: _getBatteryColor(
                                      device["batteryLevel"] as int),
                                  size: 16,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  '${device["batteryLevel"]}%',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: _getBatteryColor(
                                        device["batteryLevel"] as int),
                                  ),
                                ),
                                SizedBox(width: 2.w),
                              ],
                              Container(
                                width: 3.w,
                                height: 3.w,
                                decoration: BoxDecoration(
                                  color: (device["status"] as String) ==
                                          "Connecté"
                                      ? AppTheme.successLight
                                      : AppTheme.lightTheme.colorScheme.error,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                          onTap: () => _showBluetoothDeviceDialog(device),
                        ))
                    .toList(),
                SettingsItemWidget(
                  title: 'Ajouter un Appareil',
                  subtitle: 'Scanner les appareils disponibles',
                  leadingIcon: 'add_circle_outline',
                  trailing: CustomIconWidget(
                    iconName: 'chevron_right',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  onTap: () => _showBluetoothScanDialog(),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Camera Settings
            SettingsSectionWidget(
              title: 'Paramètres Caméra',
              children: [
                SettingsItemWidget(
                  title: 'Qualité Photo',
                  subtitle: _photoQuality,
                  leadingIcon: 'photo_camera',
                  trailing: CustomIconWidget(
                    iconName: 'chevron_right',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  onTap: () => _showPhotoQualityDialog(),
                ),
                SettingsItemWidget(
                  title: 'Intégration GPS',
                  subtitle: 'Inclure les coordonnées dans les photos',
                  leadingIcon: 'gps_fixed',
                  trailing: Switch(
                    value: _gpsEmbeddingEnabled,
                    onChanged: (value) =>
                        setState(() => _gpsEmbeddingEnabled = value),
                    activeColor: AppTheme.lightTheme.colorScheme.primary,
                  ),
                  onTap: () => setState(
                      () => _gpsEmbeddingEnabled = !_gpsEmbeddingEnabled),
                ),
                SettingsItemWidget(
                  title: 'Stockage',
                  subtitle: _storageLocation,
                  leadingIcon: 'storage',
                  trailing: CustomIconWidget(
                    iconName: 'chevron_right',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  onTap: () => _showStorageLocationDialog(),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Notifications
            SettingsSectionWidget(
              title: 'Notifications',
              children: [
                SettingsItemWidget(
                  title: 'Rappels d\'Inspection',
                  subtitle: 'Notifications pour les inspections programmées',
                  leadingIcon: 'notifications',
                  trailing: Switch(
                    value: _notificationsEnabled,
                    onChanged: (value) =>
                        setState(() => _notificationsEnabled = value),
                    activeColor: AppTheme.lightTheme.colorScheme.primary,
                  ),
                  onTap: () => setState(
                      () => _notificationsEnabled = !_notificationsEnabled),
                ),
                SettingsItemWidget(
                  title: 'Alertes de Conformité',
                  subtitle: 'Notifications pour les non-conformités',
                  leadingIcon: 'warning',
                  trailing: Switch(
                    value: _complianceAlertsEnabled,
                    onChanged: (value) =>
                        setState(() => _complianceAlertsEnabled = value),
                    activeColor: AppTheme.lightTheme.colorScheme.primary,
                  ),
                  onTap: () => setState(() =>
                      _complianceAlertsEnabled = !_complianceAlertsEnabled),
                ),
                SettingsItemWidget(
                  title: 'Mises à Jour Système',
                  subtitle: 'Notifications pour les nouvelles versions',
                  leadingIcon: 'system_update',
                  trailing: Switch(
                    value: _systemUpdatesEnabled,
                    onChanged: (value) =>
                        setState(() => _systemUpdatesEnabled = value),
                    activeColor: AppTheme.lightTheme.colorScheme.primary,
                  ),
                  onTap: () => setState(
                      () => _systemUpdatesEnabled = !_systemUpdatesEnabled),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Data Sync
            SettingsSectionWidget(
              title: 'Synchronisation des Données',
              children: [
                SettingsItemWidget(
                  title: 'Dernière Synchronisation',
                  subtitle: '11 janvier 2025, 14:30',
                  leadingIcon: 'sync',
                  trailing: TextButton(
                    onPressed: () => _performManualSync(),
                    child: Text(
                      'Synchroniser',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ),
                  onTap: () => _performManualSync(),
                ),
                SettingsItemWidget(
                  title: 'Synchronisation Automatique',
                  subtitle: 'Synchroniser automatiquement les données',
                  leadingIcon: 'sync_alt',
                  trailing: Switch(
                    value: _autoSyncEnabled,
                    onChanged: (value) =>
                        setState(() => _autoSyncEnabled = value),
                    activeColor: AppTheme.lightTheme.colorScheme.primary,
                  ),
                  onTap: () =>
                      setState(() => _autoSyncEnabled = !_autoSyncEnabled),
                ),
                SettingsItemWidget(
                  title: 'Stockage Hors Ligne',
                  subtitle: '2,4 Go utilisés sur 5 Go disponibles',
                  leadingIcon: 'storage',
                  trailing: TextButton(
                    onPressed: () => _showClearCacheDialog(),
                    child: Text(
                      'Vider',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.error,
                      ),
                    ),
                  ),
                  onTap: () => _showClearCacheDialog(),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Export Settings
            SettingsSectionWidget(
              title: 'Paramètres d\'Export',
              children: [
                SettingsItemWidget(
                  title: 'Format de Rapport',
                  subtitle: _reportFormat,
                  leadingIcon: 'description',
                  trailing: CustomIconWidget(
                    iconName: 'chevron_right',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  onTap: () => _showReportFormatDialog(),
                ),
                SettingsItemWidget(
                  title: 'Modèles de Conformité',
                  subtitle: 'Télécharger les derniers formulaires',
                  leadingIcon: 'download',
                  trailing: CustomIconWidget(
                    iconName: 'chevron_right',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  onTap: () => _downloadComplianceTemplates(),
                ),
                SettingsItemWidget(
                  title: 'Intégration Cloud',
                  subtitle: 'Configurer le stockage cloud',
                  leadingIcon: 'cloud',
                  trailing: CustomIconWidget(
                    iconName: 'chevron_right',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  onTap: () => _showCloudIntegrationDialog(),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Help & About
            SettingsSectionWidget(
              title: 'Aide et À Propos',
              children: [
                SettingsItemWidget(
                  title: 'Manuel d\'Utilisation',
                  subtitle: 'Guide complet de l\'application',
                  leadingIcon: 'menu_book',
                  trailing: CustomIconWidget(
                    iconName: 'chevron_right',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  onTap: () => _openUserManual(),
                ),
                SettingsItemWidget(
                  title: 'Tutoriels Vidéo',
                  subtitle: 'Formations interactives',
                  leadingIcon: 'play_circle_outline',
                  trailing: CustomIconWidget(
                    iconName: 'chevron_right',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  onTap: () => _openVideoTutorials(),
                ),
                SettingsItemWidget(
                  title: 'Support Technique',
                  subtitle: 'Contacter l\'équipe support',
                  leadingIcon: 'support_agent',
                  trailing: CustomIconWidget(
                    iconName: 'chevron_right',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  onTap: () => _contactSupport(),
                ),
                SettingsItemWidget(
                  title: 'À Propos',
                  subtitle: 'Version 2.1.4 (Build 2025.01.11)',
                  leadingIcon: 'info_outline',
                  trailing: CustomIconWidget(
                    iconName: 'chevron_right',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  onTap: () => _showAboutDialog(),
                ),
              ],
            ),

            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  String _getDeviceIcon(String deviceType) {
    switch (deviceType.toLowerCase()) {
      case 'tpms':
        return 'tire_repair';
      case 'diagnostic':
        return 'build';
      case 'scanner':
        return 'qr_code_scanner';
      default:
        return 'bluetooth';
    }
  }

  Color _getBatteryColor(int batteryLevel) {
    if (batteryLevel > 50) return AppTheme.successLight;
    if (batteryLevel > 20) return AppTheme.warningLight;
    return AppTheme.lightTheme.colorScheme.error;
  }

  void _toggleLanguage(bool isFrench) {
    setState(() => _isFrenchLanguage = isFrench);
    _showLanguageChangeDialog();
  }

  void _showLanguageChangeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.dialogBackgroundColor,
        title: Text(
          'Changement de Langue',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: Text(
          'L\'application doit être redémarrée pour appliquer le changement de langue.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Plus tard'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Simulate app restart
            },
            child: Text('Redémarrer'),
          ),
        ],
      ),
    );
  }

  void _showBluetoothDeviceDialog(Map<String, dynamic> device) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.dialogBackgroundColor,
        title: Text(
          device["name"] as String,
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${device["type"]}'),
            Text('Statut: ${device["status"]}'),
            if ((device["batteryLevel"] as int) > 0)
              Text('Batterie: ${device["batteryLevel"]}%'),
            Text('Dernière sync: ${device["lastSync"]}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fermer'),
          ),
          if ((device["status"] as String) == "Déconnecté")
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Simulate connection
              },
              child: Text('Connecter'),
            ),
        ],
      ),
    );
  }

  void _showBluetoothScanDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.dialogBackgroundColor,
        title: Text(
          'Scanner les Appareils',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
            SizedBox(height: 2.h),
            Text('Recherche d\'appareils Bluetooth...'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
        ],
      ),
    );
  }

  void _showPhotoQualityDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.dialogBackgroundColor,
        title: Text(
          'Qualité Photo',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text('Haute (12MP)'),
              value: 'Haute',
              groupValue: _photoQuality,
              onChanged: (value) {
                setState(() => _photoQuality = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text('Moyenne (8MP)'),
              value: 'Moyenne',
              groupValue: _photoQuality,
              onChanged: (value) {
                setState(() => _photoQuality = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text('Basse (4MP)'),
              value: 'Basse',
              groupValue: _photoQuality,
              onChanged: (value) {
                setState(() => _photoQuality = value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showStorageLocationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.dialogBackgroundColor,
        title: Text(
          'Emplacement de Stockage',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text('Stockage Interne'),
              value: 'Interne',
              groupValue: _storageLocation,
              onChanged: (value) {
                setState(() => _storageLocation = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text('Carte SD'),
              value: 'SD',
              groupValue: _storageLocation,
              onChanged: (value) {
                setState(() => _storageLocation = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text('Cloud'),
              value: 'Cloud',
              groupValue: _storageLocation,
              onChanged: (value) {
                setState(() => _storageLocation = value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showReportFormatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.dialogBackgroundColor,
        title: Text(
          'Format de Rapport',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text('PDF'),
              value: 'PDF',
              groupValue: _reportFormat,
              onChanged: (value) {
                setState(() => _reportFormat = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text('Excel'),
              value: 'Excel',
              groupValue: _reportFormat,
              onChanged: (value) {
                setState(() => _reportFormat = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text('CSV'),
              value: 'CSV',
              groupValue: _reportFormat,
              onChanged: (value) {
                setState(() => _reportFormat = value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.dialogBackgroundColor,
        title: Text(
          'Vider le Cache',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: Text(
          'Êtes-vous sûr de vouloir vider le cache? Cette action supprimera toutes les données hors ligne.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Simulate cache clearing
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Vider'),
          ),
        ],
      ),
    );
  }

  void _showCloudIntegrationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.dialogBackgroundColor,
        title: Text(
          'Intégration Cloud',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: Text(
          'Configurez votre service de stockage cloud préféré pour la synchronisation automatique des données.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fermer'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to cloud integration setup
            },
            child: Text('Configurer'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.dialogBackgroundColor,
        title: Text(
          'Aide',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: Text(
          'Besoin d\'aide? Consultez notre manuel d\'utilisation ou contactez le support technique.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.dialogBackgroundColor,
        title: Text(
          'À Propos',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('FleetCrew AI Truck Inspector'),
            Text('Version: 2.1.4'),
            Text('Build: 2025.01.11'),
            SizedBox(height: 1.h),
            Text('© 2025 FleetCrew AI Inc.'),
            Text('Tous droits réservés.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _navigateToEditProfile() {
    // Navigate to profile editing screen
  }

  void _performManualSync() {
    // Perform manual data synchronization
  }

  void _downloadComplianceTemplates() {
    // Download latest compliance templates
  }

  void _openUserManual() {
    // Open user manual
  }

  void _openVideoTutorials() {
    // Open video tutorials
  }

  void _contactSupport() {
    // Contact technical support
  }
}
