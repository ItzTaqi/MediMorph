import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/ai_suggestion_widget.dart';
import './widgets/camera_scanner_widget.dart';
import './widgets/drug_interaction_alert_widget.dart';
import './widgets/medication_form_widget.dart';

class AddMedication extends StatefulWidget {
  const AddMedication({super.key});

  @override
  State<AddMedication> createState() => _AddMedicationState();
}

class _AddMedicationState extends State<AddMedication>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _drugNameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _doctorController = TextEditingController();

  bool _isScanning = false;
  bool _showAdvancedOptions = false;
  bool _hasUnsavedChanges = false;
  String _selectedFrequency = 'Once daily';
  DateTime? _startDate;
  DateTime? _endDate;
  List<String> _detectedInteractions = [];
  List<String> _aiSuggestions = [];

  // Mock drug database for autocomplete
  final List<Map<String, dynamic>> _drugDatabase = [
    {
      "name": "Metformin",
      "commonDosages": ["500mg", "850mg", "1000mg"],
      "interactions": ["Alcohol", "Insulin"],
      "category": "Diabetes"
    },
    {
      "name": "Lisinopril",
      "commonDosages": ["5mg", "10mg", "20mg"],
      "interactions": ["Potassium supplements", "NSAIDs"],
      "category": "Blood Pressure"
    },
    {
      "name": "Atorvastatin",
      "commonDosages": ["10mg", "20mg", "40mg", "80mg"],
      "interactions": ["Grapefruit juice", "Warfarin"],
      "category": "Cholesterol"
    },
    {
      "name": "Omeprazole",
      "commonDosages": ["20mg", "40mg"],
      "interactions": ["Clopidogrel", "Warfarin"],
      "category": "Acid Reflux"
    },
    {
      "name": "Sertraline",
      "commonDosages": ["25mg", "50mg", "100mg"],
      "interactions": ["MAOIs", "Blood thinners"],
      "category": "Antidepressant"
    }
  ];

  final List<String> _frequencyOptions = [
    'Once daily',
    'Twice daily',
    'Three times daily',
    'Four times daily',
    'Every 8 hours',
    'Every 12 hours',
    'As needed',
    'Weekly',
    'Monthly'
  ];

  // Mock current medications for interaction checking
  final List<String> _currentMedications = [
    "Metformin 500mg",
    "Lisinopril 10mg"
  ];

  @override
  void initState() {
    super.initState();
    _drugNameController.addListener(_onDrugNameChanged);
    _dosageController.addListener(_onFormChanged);
    _instructionsController.addListener(_onFormChanged);
    _doctorController.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    _drugNameController.dispose();
    _dosageController.dispose();
    _instructionsController.dispose();
    _doctorController.dispose();
    super.dispose();
  }

  void _onDrugNameChanged() {
    setState(() {
      _hasUnsavedChanges = true;
    });
    _checkDrugInteractions();
    _generateAISuggestions();
  }

  void _onFormChanged() {
    setState(() {
      _hasUnsavedChanges = true;
    });
  }

  void _checkDrugInteractions() {
    final drugName = _drugNameController.text.toLowerCase();
    final interactions = <String>[];

    for (final drug in _drugDatabase) {
      if ((drug["name"] as String).toLowerCase().contains(drugName) &&
          drugName.isNotEmpty) {
        final drugInteractions = drug["interactions"] as List<String>;
        for (final currentMed in _currentMedications) {
          for (final interaction in drugInteractions) {
            if (currentMed.toLowerCase().contains(interaction.toLowerCase())) {
              interactions.add("Potential interaction with $currentMed");
            }
          }
        }
      }
    }

    setState(() {
      _detectedInteractions = interactions;
    });
  }

  void _generateAISuggestions() {
    final drugName = _drugNameController.text.toLowerCase();
    final suggestions = <String>[];

    if (drugName.isNotEmpty) {
      suggestions.add("Best taken with food to reduce stomach irritation");
      suggestions.add("Optimal timing: 30 minutes before breakfast");
      suggestions.add("Consider setting reminder for consistent daily timing");
    }

    setState(() {
      _aiSuggestions = suggestions;
    });
  }

  List<String> _getFilteredDrugs(String query) {
    if (query.isEmpty) return [];

    return _drugDatabase
        .where((drug) => (drug["name"] as String)
            .toLowerCase()
            .contains(query.toLowerCase()))
        .map((drug) => drug["name"] as String)
        .take(5)
        .toList();
  }

  List<String> _getCommonDosages(String drugName) {
    final drug = _drugDatabase.firstWhere(
      (drug) =>
          (drug["name"] as String).toLowerCase() == drugName.toLowerCase(),
      orElse: () => {"commonDosages": <String>[]},
    );
    return (drug["commonDosages"] as List<String>?) ?? [];
  }

  bool _isFormValid() {
    return _drugNameController.text.isNotEmpty &&
        _dosageController.text.isNotEmpty &&
        _selectedFrequency.isNotEmpty;
  }

  void _scanPrescription() {
    setState(() {
      _isScanning = true;
    });

    // Simulate scanning process
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isScanning = false;
        _drugNameController.text = "Metformin";
        _dosageController.text = "500mg";
        _selectedFrequency = "Twice daily";
        _hasUnsavedChanges = true;
      });
      _checkDrugInteractions();
      _generateAISuggestions();
    });
  }

  void _saveMedication() {
    if (_formKey.currentState?.validate() ?? false) {
      // Simulate saving medication
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Medication saved successfully!'),
          backgroundColor: AppTheme.getSuccessColor(true),
          action: SnackBarAction(
            label: 'Set Reminder',
            onPressed: () {
              // Navigate to reminder setup
            },
          ),
        ),
      );

      setState(() {
        _hasUnsavedChanges = false;
      });

      Navigator.pop(context);
    }
  }

  void _showUnsavedChangesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Unsaved Changes'),
        content:
            Text('You have unsaved changes. Are you sure you want to leave?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Stay'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Leave'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_hasUnsavedChanges) {
          _showUnsavedChangesDialog();
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            'Add Medication',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          leading: IconButton(
            onPressed: () {
              if (_hasUnsavedChanges) {
                _showUnsavedChangesDialog();
              } else {
                Navigator.pop(context);
              }
            },
            icon: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          actions: [
            TextButton(
              onPressed: _isFormValid() ? _saveMedication : null,
              child: Text(
                'Save',
                style: TextStyle(
                  color: _isFormValid()
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.textDisabledLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Camera Scanner Section
                CameraScannerWidget(
                  isScanning: _isScanning,
                  onScanPressed: _scanPrescription,
                ),

                SizedBox(height: 3.h),

                // Drug Interaction Alerts
                if (_detectedInteractions.isNotEmpty) ...[
                  DrugInteractionAlertWidget(
                    interactions: _detectedInteractions,
                  ),
                  SizedBox(height: 2.h),
                ],

                // AI Suggestions
                if (_aiSuggestions.isNotEmpty) ...[
                  AISuggestionWidget(
                    suggestions: _aiSuggestions,
                  ),
                  SizedBox(height: 2.h),
                ],

                // Medication Form
                MedicationFormWidget(
                  formKey: _formKey,
                  drugNameController: _drugNameController,
                  dosageController: _dosageController,
                  instructionsController: _instructionsController,
                  doctorController: _doctorController,
                  selectedFrequency: _selectedFrequency,
                  frequencyOptions: _frequencyOptions,
                  startDate: _startDate,
                  endDate: _endDate,
                  showAdvancedOptions: _showAdvancedOptions,
                  drugDatabase: _drugDatabase,
                  onFrequencyChanged: (value) {
                    setState(() {
                      _selectedFrequency = value;
                      _hasUnsavedChanges = true;
                    });
                  },
                  onStartDateChanged: (date) {
                    setState(() {
                      _startDate = date;
                      _hasUnsavedChanges = true;
                    });
                  },
                  onEndDateChanged: (date) {
                    setState(() {
                      _endDate = date;
                      _hasUnsavedChanges = true;
                    });
                  },
                  onAdvancedOptionsToggle: () {
                    setState(() {
                      _showAdvancedOptions = !_showAdvancedOptions;
                    });
                  },
                  getFilteredDrugs: _getFilteredDrugs,
                  getCommonDosages: _getCommonDosages,
                ),

                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
