import 'package:flutter/material.dart';

import 'success_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Form key
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  // Form state
  bool _obscurePassword = true;
  DateTime? _birthDate;
  bool _submitting = false;

  // AI Signup Coach state
  bool _isLoadingTip = false;
  bool _simulateFailure = false;
  String? _tip;
  String? _tipError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // Mock AI service: does not send any form data
  Future<String> _fetchSignupTip({required bool shouldFail}) async {
    await Future.delayed(const Duration(seconds: 1));

    if (shouldFail) {
      throw Exception('Mock failure');
    }

    return 'Use a long, unique password and avoid reusing '
        'passwords across different accounts.';
  }

  // Request an AI signup tip
  Future<void> _getSignupTip() async {
    if (_isLoadingTip) return;

    setState(() {
      _isLoadingTip = true;
      _tip = null;
      _tipError = null;
    });

    try {
      final tip = (await _fetchSignupTip(
        shouldFail: _simulateFailure,
      ).timeout(const Duration(seconds: 10))).trim();

      if (tip.isEmpty) {
        throw Exception('Empty tip');
      }

      if (!mounted) return;

      setState(() {
        _tip = tip.length > 240 ? tip.substring(0, 240) : tip;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _tipError = "Couldn't load a tip. Please try again.";
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingTip = false;
        });
      }
    }
  }

  // Open birth date picker
  Future<void> _selectBirthDate() async {
    final today = DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      initialDate:
          _birthDate ?? DateTime(today.year - 18, today.month, today.day),
      firstDate: DateTime(1900),
      lastDate: today,
    );

    if (selectedDate != null && mounted) {
      setState(() {
        _birthDate = selectedDate;
        _dateController.text =
            '${selectedDate.month}/${selectedDate.day}/${selectedDate.year}';
      });
    }
  }

  // Validate and submit signup
  Future<void> _submitSignup() async {
    if (_submitting || !_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _submitting = true;
    });

    // Simulated signup processing
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SuccessScreen(userName: _nameController.text.trim()),
      ),
    );
  }

  // AI Signup Coach UI
  Widget _buildTipSection() {
    return Column(
      children: [
        const Text(
          'Need help creating a password?',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),

        OutlinedButton(
          onPressed: _isLoadingTip ? null : _getSignupTip,
          child: const Text('Get a signup tip'),
        ),

        SwitchListTile(
          title: const Text('Simulate tip failure (testing)'),
          value: _simulateFailure,
          onChanged: _isLoadingTip
              ? null
              : (value) {
                  setState(() {
                    _simulateFailure = value;
                  });
                },
        ),

        const SizedBox(height: 8),

        if (_isLoadingTip) const Text('Loading tip...'),

        if (_tip != null)
          Card(
            color: Colors.lightBlue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  const Text(
                    'Signup Tip (Mock)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(_tip!),
                  const SizedBox(height: 6),
                  const Text(
                    'General advice only. Signup validation happens separately.',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

        if (_tipError != null)
          Column(
            children: [
              Text(_tipError!, style: const TextStyle(color: Colors.red)),
              TextButton(
                onPressed: _isLoadingTip ? null : _getSignupTip,
                child: const Text('Retry'),
              ),
            ],
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Haunted Signup Lab'),
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Create Your Account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              // Full Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Password with visibility toggle
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Birth Date
              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: _selectBirthDate,
                decoration: const InputDecoration(
                  labelText: 'Birth Date',
                  prefixIcon: Icon(Icons.calendar_month),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (_birthDate == null) {
                    return 'Please select your birth date';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Sign Up Button
              ElevatedButton(
                onPressed: _submitting ? null : _submitSignup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  _submitting ? 'Submitting...' : 'Sign Up',
                  style: const TextStyle(fontSize: 18),
                ),
              ),

              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 8),

              // AI Signup Coach
              _buildTipSection(),
            ],
          ),
        ),
      ),
    );
  }
}
