import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NotesSectionWidget extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const NotesSectionWidget({
    Key? key,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<NotesSectionWidget> createState() => _NotesSectionWidgetState();
}

class _NotesSectionWidgetState extends State<NotesSectionWidget> {
  bool _isListening = false;
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'note_alt',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Notes et observations',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: CustomIconWidget(
                  iconName: _isExpanded ? 'expand_less' : 'expand_more',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ],
          ),
          if (_isExpanded) ...[
            SizedBox(height: 3.h),
            TextFormField(
              controller: widget.controller,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Ajouter des notes sur cette mesure...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: AppTheme.lightTheme.colorScheme.surface,
                contentPadding: EdgeInsets.all(3.w),
              ),
              style: TextStyle(
                fontSize: 14.sp,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              onChanged: (value) => widget.onChanged(),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _toggleVoiceInput,
                    icon: CustomIconWidget(
                      iconName: _isListening ? 'mic_off' : 'mic',
                      color: _isListening
                          ? AppTheme.lightTheme.colorScheme.error
                          : AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 16,
                    ),
                    label: Text(_isListening ? 'Arrêter' : 'Vocal'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isListening
                          ? AppTheme.lightTheme.colorScheme.error
                          : AppTheme.lightTheme.colorScheme.secondary,
                      foregroundColor:
                          AppTheme.lightTheme.colorScheme.onSecondary,
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                ElevatedButton.icon(
                  onPressed: _addQuickNote,
                  icon: CustomIconWidget(
                    iconName: 'add',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 16,
                  ),
                  label: Text('Modèle'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                    foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            _buildQuickNotes(),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickNotes() {
    final quickNotes = [
      'Mesure conforme aux spécifications',
      'Légère usure observée',
      'Nécessite surveillance',
      'Remplacement recommandé',
      'Inspection approfondie requise',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notes rapides:',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: quickNotes.map((note) {
            return GestureDetector(
              onTap: () => _addQuickNoteText(note),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  note,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _toggleVoiceInput() {
    setState(() {
      _isListening = !_isListening;
    });

    if (_isListening) {
      // Simulate voice input
      Future.delayed(Duration(seconds: 3), () {
        if (_isListening) {
          widget.controller.text += (widget.controller.text.isEmpty
                  ? ''
                  : '\n') +
              'Note vocale: Pression légèrement élevée mais dans les limites acceptables.';
          widget.onChanged();
          setState(() {
            _isListening = false;
          });
        }
      });
    }
  }

  void _addQuickNote() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Modèles de notes',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 2.h),
            ...[
              'Inspection visuelle: RAS',
              'Mesure dans les normes',
              'Attention: surveillance requise',
              'Défaut mineur détecté',
              'Maintenance préventive recommandée',
              'Pièce à remplacer prochainement',
            ].map((template) => ListTile(
                  title: Text(template),
                  onTap: () {
                    Navigator.pop(context);
                    _addQuickNoteText(template);
                  },
                )),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _addQuickNoteText(String note) {
    final currentText = widget.controller.text;
    final newText = currentText.isEmpty ? note : '$currentText\n$note';
    widget.controller.text = newText;
    widget.onChanged();
  }
}
