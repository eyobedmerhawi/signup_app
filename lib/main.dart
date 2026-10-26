import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// 🧓 Great-Grandparent
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fun Signup App',
      theme: ThemeData(primarySwatch: Colors.lightBlue),
      home: const SignupPage(),
    );
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // 🔑 The Global Key - acts like a remote control for the form
  final _formKey = GlobalKey<FormState>();

  // 📝 Controllers to track what the user types
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 💡 Signup Coach state (independent of the form controllers)
  bool _isLoadingTip = false;
  bool _simulateFailure = false; // test-only switch
  String? _tip;
  String? _tipError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 🤖 Mock service: sends nothing from the form, returns a fixed tip
  Future<String> _fetchSignupTip({required bool shouldFail}) async {
    await Future.delayed(const Duration(seconds: 1));
    if (shouldFail) throw Exception('Mock failure');
    return 'Use a long, unique password and avoid reusing '
        'passwords across different accounts.';
  }

  // 🎯 Request handler
  Future<void> _getSignupTip() async {
    if (_isLoadingTip) return; // blocks duplicate taps

    setState(() {
      _isLoadingTip = true;
      _tip = null;
      _tipError = null;
    });

    try {
      final tip = (await _fetchSignupTip(
        shouldFail: _simulateFailure,
      ).timeout(const Duration(seconds: 10))).trim();
      if (tip.isEmpty) throw Exception('Empty tip');
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
      if (mounted) setState(() => _isLoadingTip = false);
    }
  }

  // 🧩 Tip section UI
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
              ? null // locked while a request is running
              : (value) => setState(() => _simulateFailure = value),
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
      // 👨 Parent
      appBar: AppBar(
        title: const Text('Join Us Today for the Cash Money!'),
        backgroundColor: Colors.lightBlue,
      ),
      // Scrollable so the keyboard / new section doesn't cover content
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          // 👶 Child
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Create Your Account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // 👤 Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 📧 Email Field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 🔒 Password Field
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
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
              const SizedBox(height: 24),

              // 🚀 Sign Up Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Demo signup complete — your form passed validation!',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                ),
                child: const Text('Sign Up', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 8),

              // 💡 Signup Coach section
              _buildTipSection(),
            ],
          ),
        ),
      ),
    );
  }
}
