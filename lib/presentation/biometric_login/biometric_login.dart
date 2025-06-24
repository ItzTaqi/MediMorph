import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/biometric_buttons_widget.dart';
import './widgets/biometric_icon_widget.dart';
import './widgets/biometric_logo_widget.dart';
import './widgets/emergency_access_widget.dart';
import './widgets/hipaa_compliance_widget.dart';

class BiometricLogin extends StatefulWidget {
  const BiometricLogin({super.key});

  @override
  State<BiometricLogin> createState() => _BiometricLoginState();
}

class _BiometricLoginState extends State<BiometricLogin>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isLoading = false;
  bool _showPasscodeOption = false;
  int _failedAttempts = 0;
  bool _isAccountLocked = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _authenticateWithBiometrics() async {
    if (_isAccountLocked) {
      _showAccountLockedDialog();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate biometric authentication
      await Future.delayed(const Duration(seconds: 2));

      // Simulate random success/failure for demo
      final isSuccess = DateTime.now().millisecond % 3 == 0;

      if (isSuccess) {
        _onAuthenticationSuccess();
      } else {
        _onAuthenticationFailure();
      }
    } catch (e) {
      _onAuthenticationError();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onAuthenticationSuccess() {
    HapticFeedback.lightImpact();
    Navigator.pushReplacementNamed(context, '/health-dashboard');
  }

  void _onAuthenticationFailure() {
    setState(() {
      _failedAttempts++;
      _showPasscodeOption = true;
      if (_failedAttempts >= 3) {
        _isAccountLocked = true;
      }
    });
    HapticFeedback.heavyImpact();
    _showFailureSnackBar();
  }

  void _onAuthenticationError() {
    setState(() {
      _showPasscodeOption = true;
    });
    _showErrorSnackBar();
  }

  void _showFailureSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _failedAttempts >= 3
              ? 'Account locked due to multiple failed attempts'
              : 'Biometric authentication failed. Try again.',
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Biometric authentication unavailable'),
        backgroundColor: AppTheme.warningLight,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showAccountLockedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Account Locked'),
        content: const Text(
          'Your account has been temporarily locked due to multiple failed authentication attempts. Please try again later or contact support.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              SystemNavigator.pop();
            },
            child: const Text('Exit App'),
          ),
        ],
      ),
    );
  }

  void _handlePasscodeLogin() {
    // Navigate to passcode entry or show passcode dialog
    _showPasscodeDialog();
  }

  void _showPasscodeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Passcode'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                'Enter your 6-digit passcode to access your health data'),
            SizedBox(height: 2.h),
            TextField(
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 6,
              decoration: const InputDecoration(
                hintText: 'Enter passcode',
                counterText: '',
              ),
              onSubmitted: (value) {
                if (value == '123456') {
                  Navigator.of(context).pop();
                  _onAuthenticationSuccess();
                } else {
                  Navigator.of(context).pop();
                  _showFailureSnackBar();
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _handleEmergencyAccess() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'warning',
              color: AppTheme.warningLight,
              size: 24,
            ),
            SizedBox(width: 2.w),
            const Text('Emergency Access'),
          ],
        ),
        content: const Text(
          'Emergency access provides limited functionality for critical health situations. Only medication reminders and emergency contacts will be available.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, '/health-dashboard');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.warningLight,
            ),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: SingleChildScrollView(
          child: Text(
            'MediMorph is committed to protecting your health information in compliance with HIPAA regulations. Your biometric data is stored securely on your device and never transmitted to our servers. All health data is encrypted and protected according to medical-grade security standards.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(minHeight: 100.h - 10.h),
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top section with logo
                Column(
                  children: [
                    SizedBox(height: 4.h),
                    BiometricLogoWidget(),
                    SizedBox(height: 6.h),

                    // Biometric icon with pulse animation
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: BiometricIconWidget(
                            isLoading: _isLoading,
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 4.h),

                    // Authentication status text
                    Text(
                      _isLoading
                          ? 'Authenticating...'
                          : _isAccountLocked
                              ? 'Account Locked'
                              : 'Secure Access to Your Health Data',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: _isAccountLocked
                            ? AppTheme.lightTheme.colorScheme.error
                            : AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 2.h),

                    Text(
                      _isLoading
                          ? 'Please wait while we verify your identity'
                          : _isAccountLocked
                              ? 'Multiple failed attempts detected'
                              : 'Use your biometric authentication to access your medical information securely',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                // Middle section with authentication buttons
                Column(
                  children: [
                    BiometricButtonsWidget(
                      onBiometricPressed: _authenticateWithBiometrics,
                      onPasscodePressed: _handlePasscodeLogin,
                      showPasscodeOption: _showPasscodeOption,
                      isLoading: _isLoading,
                      isAccountLocked: _isAccountLocked,
                    ),
                    SizedBox(height: 3.h),
                    EmergencyAccessWidget(
                      onEmergencyAccess: _handleEmergencyAccess,
                    ),
                  ],
                ),

                // Bottom section with HIPAA compliance
                Column(
                  children: [
                    HipaaComplianceWidget(
                      onPrivacyPolicyPressed: _showPrivacyPolicy,
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
