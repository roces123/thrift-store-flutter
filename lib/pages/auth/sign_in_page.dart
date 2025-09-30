// lib/pages/sign_in_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/supabase_service.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final svc = Provider.of<SupabaseService>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Gradient Header
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF28C59A), // vibrant pink
                        Color(0xFFFF96F0), // deep purple
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Text(
                    '🏷️ KC Thrift Store',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dancingScript(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        TextField(
                          controller: _emailCtrl,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.email, color: Color(0xFF3A0CA3)),
                            labelText: 'Email',
                            labelStyle: GoogleFonts.montserrat(color: Colors.grey[600]),
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passCtrl,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock, color: Color(0xFF3A0CA3)),
                            labelText: 'Password',
                            labelStyle: GoogleFonts.montserrat(color: Colors.grey[600]),
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF81A89C),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                            ),
                            onPressed: _loading
                                ? null
                                : () async {
                              setState(() => _loading = true);
                              await svc.signIn(
                                _emailCtrl.text.trim(),
                                _passCtrl.text.trim(),
                              );
                              setState(() => _loading = false);
                              if (svc.error == null) {
                                Navigator.pushReplacementNamed(context, '/items');
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(svc.error!),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              }
                            },
                            child: _loading
                                ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            )
                                : Text(
                              'Sign In',
                              style: GoogleFonts.gentiumBookPlus(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/signup'),
                          child: Text(
                            'Don’t have an account? Sign Up',
                            style: GoogleFonts.montserrat(
                              color: const Color(0xFF3A0CA3),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
