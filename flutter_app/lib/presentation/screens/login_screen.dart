import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_controller.dart';
import '../../core/utils/validators.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _otpSent = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp(AuthController controller) async {
    if (!_formKey.currentState!.validate()) return;
    await controller.sendOtp(_phoneController.text.trim());
    if (controller.verificationId != null) {
      setState(() => _otpSent = true);
    }
  }

  Future<void> _verifyOtp(AuthController controller) async {
    await controller.verifyOtp(_otpController.text.trim());
    if (controller.currentUser != null && mounted) {
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AuthController>();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Text(
                'Welcome to E-Library & Printing',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Text(
                'Sign in with your phone number to continue.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        hintText: '+234 812 345 6789',
                      ),
                      validator: (value) =>
                          Validators.requiredField(value, 'Phone number is required'),
                    ),
                    const SizedBox(height: 16),
                    if (_otpSent)
                      TextFormField(
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'OTP Code',
                        ),
                        validator: (value) =>
                            Validators.requiredField(value, 'OTP code is required'),
                      ),
                    const SizedBox(height: 24),
                    if (controller.errorMessage != null)
                      Text(
                        controller.errorMessage!,
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.isLoading
                            ? null
                            : () => _otpSent
                                ? _verifyOtp(controller)
                                : _sendOtp(controller),
                        child: Text(controller.isLoading
                            ? 'Please wait...'
                            : _otpSent
                                ? 'Verify OTP'
                                : 'Send OTP'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
