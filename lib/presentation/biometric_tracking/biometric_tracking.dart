import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/activities_card_widget.dart';
import './widgets/quick_entry_widget.dart';
import './widgets/symptoms_card_widget.dart';
import './widgets/trend_chart_widget.dart';
import './widgets/vitals_card_widget.dart';
import './widgets/wearable_sync_widget.dart';

class BiometricTracking extends StatefulWidget {
  const BiometricTracking({super.key});

  @override
  State<BiometricTracking> createState() => _BiometricTrackingState();
}

class _BiometricTrackingState extends State<BiometricTracking>
    with TickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  int _selectedBottomTab = 2; // Tracking tab active
  String _selectedMetric = 'heart_rate';

  // Mock data for biometric tracking
  final List<Map<String, dynamic>> _vitalsData = [
    {
      "id": 1,
      "type": "blood_pressure",
      "systolic": 120,
      "diastolic": 80,
      "timestamp": DateTime.now().subtract(Duration(hours: 2)),
      "source": "manual",
    },
    {
      "id": 2,
      "type": "heart_rate",
      "value": 72,
      "timestamp": DateTime.now().subtract(Duration(hours: 1)),
      "source": "apple_watch",
    },
    {
      "id": 3,
      "type": "temperature",
      "value": 98.6,
      "timestamp": DateTime.now().subtract(Duration(minutes: 30)),
      "source": "manual",
    },
  ];

  final List<Map<String, dynamic>> _symptomsData = [
    {
      "id": 1,
      "type": "pain_level",
      "value": 3,
      "location": "headache",
      "timestamp": DateTime.now().subtract(Duration(hours: 3)),
    },
    {
      "id": 2,
      "type": "mood",
      "value": "good",
      "timestamp": DateTime.now().subtract(Duration(hours: 1)),
    },
    {
      "id": 3,
      "type": "energy",
      "value": 7,
      "timestamp": DateTime.now().subtract(Duration(minutes: 45)),
    },
  ];

  final List<Map<String, dynamic>> _activitiesData = [
    {
      "id": 1,
      "type": "sleep",
      "duration": 7.5,
      "quality": "good",
      "timestamp": DateTime.now().subtract(Duration(hours: 8)),
    },
    {
      "id": 2,
      "type": "exercise",
      "activity": "walking",
      "duration": 30,
      "timestamp": DateTime.now().subtract(Duration(hours: 2)),
    },
    {
      "id": 3,
      "type": "diet",
      "meal": "breakfast",
      "calories": 450,
      "timestamp": DateTime.now().subtract(Duration(hours: 4)),
    },
  ];

  final List<Map<String, dynamic>> _wearableDevices = [
    {
      "id": 1,
      "name": "Apple Watch Series 9",
      "type": "apple_watch",
      "connected": true,
      "last_sync": DateTime.now().subtract(Duration(minutes: 5)),
      "battery": 85,
    },
    {
      "id": 2,
      "name": "Fitbit Charge 5",
      "type": "fitbit",
      "connected": false,
      "last_sync": DateTime.now().subtract(Duration(hours: 2)),
      "battery": 45,
    },
  ];

  final List<Map<String, dynamic>> _trendData = [
    {"date": "Mon", "heart_rate": 68, "blood_pressure": 118, "steps": 8500},
    {"date": "Tue", "heart_rate": 72, "blood_pressure": 120, "steps": 9200},
    {"date": "Wed", "heart_rate": 70, "blood_pressure": 115, "steps": 7800},
    {"date": "Thu", "heart_rate": 74, "blood_pressure": 122, "steps": 10100},
    {"date": "Fri", "heart_rate": 69, "blood_pressure": 119, "steps": 8900},
    {"date": "Sat", "heart_rate": 71, "blood_pressure": 117, "steps": 12000},
    {"date": "Sun", "heart_rate": 73, "blood_pressure": 121, "steps": 6500},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
  }

  void _changeDate(int days) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: days));
    });
  }

  void _showQuickSymptomLogger() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: QuickEntryWidget(
          onSave: (data) {
            Navigator.pop(context);
            // Handle quick entry save
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildDateHeader(),
                  WearableSyncWidget(
                    devices: _wearableDevices,
                    isLoading: _isLoading,
                    onSync: _refreshData,
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 6.h,
                child: TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(text: 'Vitals'),
                    Tab(text: 'Symptoms'),
                    Tab(text: 'Activities'),
                  ],
                ),
              ),
            ),
            SliverFillRemaining(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildVitalsTab(),
                  _buildSymptomsTab(),
                  _buildActivitiesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showQuickSymptomLogger,
        child: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.lightTheme.colorScheme.onTertiary,
          size: 24,
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Biometric Tracking',
        style: AppTheme.lightTheme.textTheme.titleLarge,
      ),
      actions: [
        IconButton(
          onPressed: () {
            // Show trend analysis
          },
          icon: CustomIconWidget(
            iconName: 'analytics',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 24,
          ),
        ),
        IconButton(
          onPressed: () {
            // Show settings
          },
          icon: CustomIconWidget(
            iconName: 'settings',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildDateHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => _changeDate(-1),
            icon: CustomIconWidget(
              iconName: 'chevron_left',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
          ),
          Column(
            children: [
              Text(
                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              Text(
                _selectedDate.day == DateTime.now().day
                    ? 'Today'
                    : 'Historical Data',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
            ],
          ),
          IconButton(
            onPressed: _selectedDate.isBefore(DateTime.now())
                ? () => _changeDate(1)
                : null,
            icon: CustomIconWidget(
              iconName: 'chevron_right',
              color: _selectedDate.isBefore(DateTime.now())
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.3),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          VitalsCardWidget(
            vitalsData: _vitalsData,
            onUpdate: (data) {
              // Handle vitals update
            },
          ),
          SizedBox(height: 2.h),
          TrendChartWidget(
            data: _trendData,
            selectedMetric: _selectedMetric,
            onMetricChanged: (metric) {
              setState(() {
                _selectedMetric = metric;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          SymptomsCardWidget(
            symptomsData: _symptomsData,
            onUpdate: (data) {
              // Handle symptoms update
            },
          ),
          SizedBox(height: 2.h),
          _buildCorrelationInsights(),
        ],
      ),
    );
  }

  Widget _buildActivitiesTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          ActivitiesCardWidget(
            activitiesData: _activitiesData,
            onUpdate: (data) {
              // Handle activities update
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCorrelationInsights() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'insights',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Medication Correlations',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
              ],
            ),
            SizedBox(height: 2.h),
            _buildInsightItem(
              'Blood Pressure',
              'Lisinopril shows 15% improvement in morning readings',
              AppTheme.getSuccessColor(true),
            ),
            SizedBox(height: 1.h),
            _buildInsightItem(
              'Sleep Quality',
              'Melatonin correlation with 2hr earlier sleep onset',
              AppTheme.getSuccessColor(true),
            ),
            SizedBox(height: 1.h),
            _buildInsightItem(
              'Side Effects',
              'Mild headaches 2hrs after Metformin - consider timing',
              AppTheme.getWarningColor(true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightItem(String title, String description, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 1.w,
          height: 4.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.titleSmall,
              ),
              SizedBox(height: 0.5.h),
              Text(
                description,
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedBottomTab,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        setState(() {
          _selectedBottomTab = index;
        });

        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/health-dashboard');
            break;
          case 1:
            Navigator.pushNamed(context, '/medication-list');
            break;
          case 2:
            // Current screen - do nothing
            break;
          case 3:
            Navigator.pushNamed(context, '/add-medication');
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'dashboard',
            color: _selectedBottomTab == 0
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
            size: 24,
          ),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'medication',
            color: _selectedBottomTab == 1
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
            size: 24,
          ),
          label: 'Medications',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'monitor_heart',
            color: _selectedBottomTab == 2
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
            size: 24,
          ),
          label: 'Tracking',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'add_circle',
            color: _selectedBottomTab == 3
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
            size: 24,
          ),
          label: 'Add',
        ),
      ],
    );
  }
}
