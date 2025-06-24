import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_state_widget.dart';
import './widgets/medication_card_widget.dart';
import './widgets/search_filter_widget.dart';

class MedicationList extends StatefulWidget {
  const MedicationList({super.key});

  @override
  State<MedicationList> createState() => _MedicationListState();
}

class _MedicationListState extends State<MedicationList>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isSearchActive = false;
  bool _isMultiSelectMode = false;
  bool _isRefreshing = false;
  String _selectedFilter = 'All';
  final List<String> _selectedMedications = [];

  // Mock medication data
  final List<Map<String, dynamic>> _medications = [
    {
      "id": "med_001",
      "name": "Metformin",
      "dosage": "500mg",
      "frequency": "Twice daily",
      "nextDose": "2:00 PM",
      "nextDoseTime": DateTime.now().add(Duration(hours: 2)),
      "adherenceRate": 95,
      "status": "Active",
      "interactions": ["Alcohol", "Contrast dye"],
      "sideEffects": ["Nausea", "Diarrhea"],
      "prescribedBy": "Dr. Sarah Johnson",
      "startDate": "2024-01-15",
      "refillDate": "2024-02-15",
      "imageUrl":
          "https://images.pexels.com/photos/3683074/pexels-photo-3683074.jpeg",
      "color": Color(0xFF2E7D8F),
      "hasInteractionWarning": true,
      "pillsRemaining": 28,
      "totalPills": 30,
    },
    {
      "id": "med_002",
      "name": "Lisinopril",
      "dosage": "10mg",
      "frequency": "Once daily",
      "nextDose": "8:00 AM",
      "nextDoseTime": DateTime.now().add(Duration(hours: 18)),
      "adherenceRate": 88,
      "status": "Active",
      "interactions": ["Potassium supplements"],
      "sideEffects": ["Dry cough", "Dizziness"],
      "prescribedBy": "Dr. Michael Chen",
      "startDate": "2024-01-10",
      "refillDate": "2024-02-10",
      "imageUrl":
          "https://images.pexels.com/photos/3683073/pexels-photo-3683073.jpeg",
      "color": Color(0xFF5A9B7C),
      "hasInteractionWarning": false,
      "pillsRemaining": 25,
      "totalPills": 30,
    },
    {
      "id": "med_003",
      "name": "Atorvastatin",
      "dosage": "20mg",
      "frequency": "Once daily",
      "nextDose": "9:00 PM",
      "nextDoseTime": DateTime.now().add(Duration(hours: 9)),
      "adherenceRate": 92,
      "status": "Active",
      "interactions": ["Grapefruit juice", "Warfarin"],
      "sideEffects": ["Muscle pain", "Headache"],
      "prescribedBy": "Dr. Sarah Johnson",
      "startDate": "2024-01-20",
      "refillDate": "2024-02-20",
      "imageUrl":
          "https://images.pexels.com/photos/3683056/pexels-photo-3683056.jpeg",
      "color": Color(0xFFE67E22),
      "hasInteractionWarning": true,
      "pillsRemaining": 22,
      "totalPills": 30,
    },
    {
      "id": "med_004",
      "name": "Omeprazole",
      "dosage": "40mg",
      "frequency": "Once daily",
      "nextDose": "7:00 AM",
      "nextDoseTime": DateTime.now().add(Duration(hours: 17)),
      "adherenceRate": 85,
      "status": "Paused",
      "interactions": ["Clopidogrel"],
      "sideEffects": ["Stomach pain", "Nausea"],
      "prescribedBy": "Dr. Emily Rodriguez",
      "startDate": "2024-01-05",
      "refillDate": "2024-02-05",
      "imageUrl":
          "https://images.pexels.com/photos/3683040/pexels-photo-3683040.jpeg",
      "color": Color(0xFF6B7280),
      "hasInteractionWarning": false,
      "pillsRemaining": 15,
      "totalPills": 30,
    },
    {
      "id": "med_005",
      "name": "Aspirin",
      "dosage": "81mg",
      "frequency": "Once daily",
      "nextDose": "8:00 AM",
      "nextDoseTime": DateTime.now().add(Duration(hours: 18)),
      "adherenceRate": 98,
      "status": "Discontinued",
      "interactions": ["Warfarin", "Ibuprofen"],
      "sideEffects": ["Stomach irritation"],
      "prescribedBy": "Dr. Michael Chen",
      "startDate": "2023-12-01",
      "refillDate": "2024-01-01",
      "imageUrl":
          "https://images.pexels.com/photos/3683089/pexels-photo-3683089.jpeg",
      "color": Color(0xFF9CA3AF),
      "hasInteractionWarning": false,
      "pillsRemaining": 0,
      "totalPills": 30,
    },
  ];

  List<Map<String, dynamic>> get _filteredMedications {
    List<Map<String, dynamic>> filtered = _medications;

    // Apply status filter
    if (_selectedFilter != 'All') {
      filtered =
          filtered.where((med) => med['status'] == _selectedFilter).toList();
    }

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      filtered = filtered
          .where((med) => (med['name'] as String)
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _isSearchActive = _searchController.text.isNotEmpty;
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Medication data updated'),
        backgroundColor: AppTheme.getSuccessColor(true),
      ),
    );
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  void _onMedicationTap(Map<String, dynamic> medication) {
    if (_isMultiSelectMode) {
      _toggleMedicationSelection(medication['id']);
    } else {
      // Navigate to medication detail with hero animation
      HapticFeedback.lightImpact();
      // TODO: Navigate to medication detail screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Opening ${medication['name']} details')),
      );
    }
  }

  void _onMedicationLongPress(Map<String, dynamic> medication) {
    HapticFeedback.mediumImpact();
    setState(() {
      _isMultiSelectMode = true;
      _selectedMedications.add(medication['id']);
    });
  }

  void _toggleMedicationSelection(String medicationId) {
    setState(() {
      if (_selectedMedications.contains(medicationId)) {
        _selectedMedications.remove(medicationId);
        if (_selectedMedications.isEmpty) {
          _isMultiSelectMode = false;
        }
      } else {
        _selectedMedications.add(medicationId);
      }
    });
  }

  void _exitMultiSelectMode() {
    setState(() {
      _isMultiSelectMode = false;
      _selectedMedications.clear();
    });
  }

  void _onMarkTaken(Map<String, dynamic> medication) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${medication['name']} marked as taken'),
        backgroundColor: AppTheme.getSuccessColor(true),
      ),
    );
  }

  void _onSkipDose(Map<String, dynamic> medication) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${medication['name']} dose skipped'),
        backgroundColor: AppTheme.getWarningColor(true),
      ),
    );
  }

  void _onEditMedication(Map<String, dynamic> medication) {
    // TODO: Navigate to edit medication screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Editing ${medication['name']}')),
    );
  }

  void _onDeleteMedication(Map<String, dynamic> medication) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Medication'),
        content: Text('Are you sure you want to delete ${medication['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _medications
                    .removeWhere((med) => med['id'] == medication['id']);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${medication['name']} deleted'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.error,
                ),
              );
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _onBulkAction(String action) {
    switch (action) {
      case 'share':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Sharing ${_selectedMedications.length} medications with doctor')),
        );
        break;
      case 'export':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Exporting ${_selectedMedications.length} medications')),
        );
        break;
      case 'reminder':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Setting group reminders for ${_selectedMedications.length} medications')),
        );
        break;
    }
    _exitMultiSelectMode();
  }

  @override
  Widget build(BuildContext context) {
    final filteredMeds = _filteredMedications;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: _buildBody(filteredMeds),
      floatingActionButton:
          _isMultiSelectMode ? null : _buildFloatingActionButton(),
      bottomNavigationBar: _isMultiSelectMode
          ? _buildMultiSelectBottomBar()
          : _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
      elevation: AppTheme.lightTheme.appBarTheme.elevation,
      title: _isMultiSelectMode
          ? Text('${_selectedMedications.length} selected')
          : Text(
              'Medications',
              style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
            ),
      leading: _isMultiSelectMode
          ? IconButton(
              onPressed: _exitMultiSelectMode,
              icon: CustomIconWidget(
                iconName: 'close',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
            )
          : null,
      actions: _isMultiSelectMode
          ? [
              IconButton(
                onPressed: () => _onBulkAction('share'),
                icon: CustomIconWidget(
                  iconName: 'share',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
              ),
            ]
          : null,
    );
  }

  Widget _buildBody(List<Map<String, dynamic>> filteredMeds) {
    return SafeArea(
      child: Column(
        children: [
          SearchFilterWidget(
            searchController: _searchController,
            selectedFilter: _selectedFilter,
            onFilterChanged: _onFilterChanged,
            isSearchActive: _isSearchActive,
          ),
          Expanded(
            child: filteredMeds.isEmpty
                ? EmptyStateWidget(
                    isSearchActive: _isSearchActive,
                    searchQuery: _searchController.text,
                    selectedFilter: _selectedFilter,
                  )
                : RefreshIndicator(
                    onRefresh: _onRefresh,
                    color: AppTheme.lightTheme.colorScheme.primary,
                    child: ListView.separated(
                      controller: _scrollController,
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      itemCount: filteredMeds.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 1.h),
                      itemBuilder: (context, index) {
                        final medication = filteredMeds[index];
                        final isSelected =
                            _selectedMedications.contains(medication['id']);

                        return MedicationCardWidget(
                          medication: medication,
                          isSelected: isSelected,
                          isMultiSelectMode: _isMultiSelectMode,
                          onTap: () => _onMedicationTap(medication),
                          onLongPress: () => _onMedicationLongPress(medication),
                          onMarkTaken: () => _onMarkTaken(medication),
                          onSkipDose: () => _onSkipDose(medication),
                          onEdit: () => _onEditMedication(medication),
                          onDelete: () => _onDeleteMedication(medication),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        HapticFeedback.lightImpact();
        Navigator.pushNamed(context, '/add-medication');
      },
      backgroundColor:
          AppTheme.lightTheme.floatingActionButtonTheme.backgroundColor,
      foregroundColor:
          AppTheme.lightTheme.floatingActionButtonTheme.foregroundColor,
      icon: CustomIconWidget(
        iconName: 'add',
        color: AppTheme.lightTheme.floatingActionButtonTheme.foregroundColor!,
        size: 24,
      ),
      label: Text(
        'Add Medication',
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMultiSelectBottomBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: AppTheme.lightTheme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildBulkActionButton(
            icon: 'share',
            label: 'Share',
            onPressed: () => _onBulkAction('share'),
          ),
          _buildBulkActionButton(
            icon: 'file_download',
            label: 'Export',
            onPressed: () => _onBulkAction('export'),
          ),
          _buildBulkActionButton(
            icon: 'alarm',
            label: 'Reminder',
            onPressed: () => _onBulkAction('reminder'),
          ),
        ],
      ),
    );
  }

  Widget _buildBulkActionButton({
    required String icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: AppTheme.lightTheme.bottomNavigationBarTheme.type,
      backgroundColor:
          AppTheme.lightTheme.bottomNavigationBarTheme.backgroundColor,
      selectedItemColor:
          AppTheme.lightTheme.bottomNavigationBarTheme.selectedItemColor,
      unselectedItemColor:
          AppTheme.lightTheme.bottomNavigationBarTheme.unselectedItemColor,
      elevation: AppTheme.lightTheme.bottomNavigationBarTheme.elevation,
      currentIndex: 1, // Medications tab active
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/health-dashboard');
            break;
          case 1:
            // Already on medications screen
            break;
          case 2:
            Navigator.pushNamed(context, '/biometric-tracking');
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'dashboard',
            color: AppTheme
                .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
            size: 24,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'dashboard',
            color:
                AppTheme.lightTheme.bottomNavigationBarTheme.selectedItemColor!,
            size: 24,
          ),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'medication',
            color: AppTheme
                .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
            size: 24,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'medication',
            color:
                AppTheme.lightTheme.bottomNavigationBarTheme.selectedItemColor!,
            size: 24,
          ),
          label: 'Medications',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'monitor_heart',
            color: AppTheme
                .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
            size: 24,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'monitor_heart',
            color:
                AppTheme.lightTheme.bottomNavigationBarTheme.selectedItemColor!,
            size: 24,
          ),
          label: 'Biometrics',
        ),
      ],
    );
  }
}
