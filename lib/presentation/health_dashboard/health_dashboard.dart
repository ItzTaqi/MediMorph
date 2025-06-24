import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/adherence_score_widget.dart';
import './widgets/ai_insights_widget.dart';
import './widgets/medication_card_widget.dart';
import './widgets/side_effects_alert_widget.dart';
import './widgets/vitals_card_widget.dart';

class HealthDashboard extends StatefulWidget {
  const HealthDashboard({super.key});

  @override
  State<HealthDashboard> createState() => _HealthDashboardState();
}

class _HealthDashboardState extends State<HealthDashboard>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isRefreshing = false;
  late TabController _tabController;

  // Mock data for dashboard
  final List<Map<String, dynamic>> todaysMedications = [
    {
      "id": 1,
      "name": "Metformin",
      "dosage": "500mg",
      "time": "08:00 AM",
      "taken": true,
      "nextDose": "08:00 PM",
      "color": 0xFF2E7D8F,
    },
    {
      "id": 2,
      "name": "Lisinopril",
      "dosage": "10mg",
      "time": "08:00 AM",
      "taken": false,
      "nextDose": "08:00 AM",
      "color": 0xFF5A9B7C,
    },
    {
      "id": 3,
      "name": "Atorvastatin",
      "dosage": "20mg",
      "time": "09:00 PM",
      "taken": false,
      "nextDose": "09:00 PM",
      "color": 0xFFE67E22,
    },
  ];

  final Map<String, dynamic> vitalsData = {
    "heartRate": 72,
    "bloodPressure": "120/80",
    "temperature": 98.6,
    "oxygenSaturation": 98,
    "lastUpdated": "2 minutes ago",
    "trends": [
      {"time": "6 AM", "heartRate": 68, "systolic": 118, "diastolic": 78},
      {"time": "12 PM", "heartRate": 75, "systolic": 122, "diastolic": 82},
      {"time": "6 PM", "heartRate": 72, "systolic": 120, "diastolic": 80},
    ]
  };

  final List<Map<String, dynamic>> sideEffects = [
    {
      "medication": "Metformin",
      "effect": "Mild nausea",
      "severity": "Low",
      "timestamp": "2 hours ago",
      "color": 0xFFF57C00,
    }
  ];

  final List<Map<String, dynamic>> aiInsights = [
    {
      "type": "recommendation",
      "title": "Optimal Medication Timing",
      "description":
          "Consider taking Metformin with meals to reduce nausea. Your adherence score could improve by 15%.",
      "priority": "medium",
      "icon": "lightbulb",
    },
    {
      "type": "alert",
      "title": "Blood Pressure Trend",
      "description":
          "Your morning readings are consistently higher. Discuss with your doctor about timing adjustments.",
      "priority": "high",
      "icon": "trending_up",
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _markMedicationTaken(int medicationId) {
    setState(() {
      final medicationIndex = todaysMedications
          .indexWhere((med) => (med["id"] as int) == medicationId);
      if (medicationIndex != -1) {
        todaysMedications[medicationIndex]["taken"] = true;
      }
    });
  }

  void _showQuickActions(BuildContext context, String cardType) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'visibility',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('View Details'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Share with Doctor'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'alarm',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Set Reminder'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Status bar with secure connection indicator
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'security',
                        color: AppTheme.getSuccessColor(true),
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'HIPAA Secure',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.getSuccessColor(true),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'bluetooth_connected',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      CustomIconWidget(
                        iconName: 'wifi',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 16,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Sticky header with date and adherence score
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Today',
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'December 15, 2024',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  AdherenceScoreWidget(
                    score: 85,
                    onTap: () => _showQuickActions(context, 'adherence'),
                  ),
                ],
              ),
            ),

            // Main scrollable content
            Expanded(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                color: AppTheme.lightTheme.colorScheme.primary,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Today's Medications Card
                      MedicationCardWidget(
                        medications: todaysMedications,
                        onMedicationTaken: _markMedicationTaken,
                        onLongPress: () =>
                            _showQuickActions(context, 'medication'),
                      ),

                      SizedBox(height: 3.h),

                      // Recent Vitals Card
                      VitalsCardWidget(
                        vitalsData: vitalsData,
                        onLongPress: () => _showQuickActions(context, 'vitals'),
                      ),

                      SizedBox(height: 3.h),

                      // Side Effects Alert (if any)
                      if (sideEffects.isNotEmpty) ...[
                        SideEffectsAlertWidget(
                          sideEffects: sideEffects,
                          onLongPress: () =>
                              _showQuickActions(context, 'side_effects'),
                        ),
                        SizedBox(height: 3.h),
                      ],

                      // AI Insights Card
                      AIInsightsWidget(
                        insights: aiInsights,
                        onLongPress: () =>
                            _showQuickActions(context, 'ai_insights'),
                      ),

                      SizedBox(height: 10.h), // Extra space for FAB
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
          unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          elevation: 0,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });

            switch (index) {
              case 0:
                // Already on Dashboard
                break;
              case 1:
                Navigator.pushNamed(context, '/medication-list');
                break;
              case 2:
                Navigator.pushNamed(context, '/biometric-tracking');
                break;
              case 3:
                // Navigate to profile (placeholder)
                break;
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'dashboard',
                color: _currentIndex == 0
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'medication',
                color: _currentIndex == 1
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              label: 'Medications',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'timeline',
                color: _currentIndex == 2
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              label: 'Tracking',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'person',
                color: _currentIndex == 3
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),

      // Floating Action Button for quick medication logging
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-medication');
        },
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        foregroundColor: AppTheme.lightTheme.colorScheme.onTertiary,
        child: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.lightTheme.colorScheme.onTertiary,
          size: 28,
        ),
      ),
    );
  }
}
