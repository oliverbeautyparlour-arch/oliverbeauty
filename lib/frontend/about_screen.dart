import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webui/frontend/api.dart';
import 'app_theme.dart';

class AboutScreen extends StatelessWidget {
   final String title;
  const AboutScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF8B4A43),
            Color(0xFFB5736A),
            Color(0xFFD4AF7A),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 20, 20),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  fontFamily: 'Georgia',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
Widget _sectionCard({required Widget child}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: AppTheme.bgCard,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: AppTheme.divider),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: child,
  );
}

// ═══════════════════════════════════════════════════════════════════════
// FORGOT PASSWORD SCREEN
// ═══════════════════════════════════════════════════════════════════════
// class ForgotPasswordScreen extends StatefulWidget {
//   const ForgotPasswordScreen({super.key});

//   @override
//   State<ForgotPasswordScreen> createState() => _ResetPasswordScreenState();
// }

// class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailCtrl = TextEditingController();
//   bool _sending = false;
//   bool _sent = false;

//   @override
//   void dispose() {
//     _emailCtrl.dispose();
//     super.dispose();
//   }

//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _sending = true);
//     try {
//       final result = await ApiService().forgotPassword(
//         email: _emailCtrl.text.trim(),
//       );

//       if (!mounted) return;

//       if (result["success"] == true) {
//         setState(() => _sent = true);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(result["message"] ?? "Something went wrong"),
//           ),
//         );
//       }
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Could not send reset link. Try again later."),
//         ),
//       );
//     } finally {
//       if (mounted) setState(() => _sending = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.bg,
//       body: Column(
//         children: [
//           const AboutScreen(title: "Forgot Password"),
//           Expanded(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(20),
//               child: _sent ? _buildSuccessState() : _buildFormState(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFormState() {
//     return Form(
//       key: _formKey,
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       child: _sectionCard(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: 56,
//               height: 56,
//               decoration: BoxDecoration(
//                 color: AppTheme.primary.withValues(alpha: 0.12),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(Icons.lock_reset_rounded,
//                   color: AppTheme.primary, size: 28),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               "Reset your password",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w800,
//                 color: AppTheme.textDark,
//                 fontFamily: 'Georgia',
//               ),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               "Enter the email linked to your account and we'll send you a link to reset your password.",
//               style: TextStyle(
//                 fontSize: 13,
//                 color: AppTheme.textDark.withValues(alpha: 0.65),
//                 height: 1.4,
//               ),
//             ),
//             const SizedBox(height: 20),
//             TextFormField(
//               controller: _emailCtrl,
//               keyboardType: TextInputType.emailAddress,
//               style: TextStyle(color: AppTheme.textDark),
//               decoration: InputDecoration(
//                 hintText: "Enter your email",
//                 prefixIcon: Icon(Icons.email_outlined, color: AppTheme.primary),
//                 filled: true,
//                 fillColor: AppTheme.surface,
//                 contentPadding: const EdgeInsets.symmetric(
//                     vertical: 14, horizontal: 12),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(14),
//                   borderSide: BorderSide.none,
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(14),
//                   borderSide: BorderSide.none,
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(14),
//                   borderSide: BorderSide(color: AppTheme.primary, width: 1.5),
//                 ),
//               ),
//               validator: (value) {
//                 if (value == null || value.trim().isEmpty) {
//                   return "Email is required";
//                 }
//                 final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
//                 if (!emailRegex.hasMatch(value.trim())) {
//                   return "Enter a valid email";
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 22),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppTheme.primary,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                 ),
//                 onPressed: _sending ? null : _submit,
//                 child: _sending
//                     ? const SizedBox(
//                         width: 22,
//                         height: 22,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2.4,
//                           color: Colors.white,
//                         ),
//                       )
//                     : const Text(
//                         "Send Reset Link",
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.white,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSuccessState() {
//     return _sectionCard(
//       child: Column(
//         children: [
//           Container(
//             width: 64,
//             height: 64,
//             decoration: BoxDecoration(
//               color: Colors.green.withValues(alpha: 0.12),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(Icons.mark_email_read_rounded,
//                 color: Colors.green, size: 32),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             "Check your inbox",
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w800,
//               color: AppTheme.textDark,
//               fontFamily: 'Georgia',
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             "We've sent a password reset link to ${_emailCtrl.text.trim()}",
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 13,
//               color: AppTheme.textDark.withValues(alpha: 0.65),
//               height: 1.4,
//             ),
//           ),
//           const SizedBox(height: 20),
//           TextButton(
//             onPressed: () => setState(() => _sent = false),
//             child: Text(
//               "Didn't get it? Send again",
//               style: TextStyle(
//                 color: AppTheme.primary,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    if (_emailCtrl.text.trim().isEmpty || _passwordCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields.")),
      );
      return;
    }
    if (_passwordCtrl.text != _confirmCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords don't match.")),
      );
      return;
    }

    setState(() => _isLoading = true);
    final result = await ApiService().resetPasswordDirect(
      email: _emailCtrl.text.trim(),
      newPassword: _passwordCtrl.text,
    );
    setState(() => _isLoading = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result["message"] ?? "Something went wrong.")),
    );

    if (result["success"] == true) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420),
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTheme.divider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock_reset_rounded, color: AppTheme.primary),
              ),
              const SizedBox(height: 20),
              const Text(
                'Reset your password',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Georgia',
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter your email and choose a new password.',
                style: TextStyle(fontSize: 13, color: AppTheme.textLight),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailCtrl,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  filled: true,
                  fillColor: AppTheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'New password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  filled: true,
                  fillColor: AppTheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _confirmCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Confirm new password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  filled: true,
                  fillColor: AppTheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Reset Password',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// ═══════════════════════════════════════════════════════════════════════
// HELP & SUPPORT SCREEN
// ═══════════════════════════════════════════════════════════════════════
class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  static const List<Map<String, String>> _faqs = [
    {
      "q": "How do I book a service?",
      "a": "Go to the Services tab, pick the service you'd like, choose a date and time, and confirm your booking from the checkout screen.",
    },
    {
      "q": "Can I reschedule or cancel a booking?",
      "a": "Yes. Open Bookings from the bottom navigation, select the appointment, and choose Reschedule or Cancel. Cancellations made close to the appointment time may be subject to our cancellation policy.",
    },
  
    {
      "q": "How do I update my profile details?",
      "a": "Go to Profile, tap Edit on the Profile Information card, make your changes, then tap Done to save.",
    },
  ];

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: Column(
        children: [
          const AboutScreen(title: "Help & Support"),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _sectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Get in touch",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textDark,
                          fontFamily: 'Georgia',
                        ),
                      ),
                      const SizedBox(height: 14),
                      _ContactTile(
                        icon: Icons.call_outlined,
                        label: "Call us",
                        value: "+91 98765 43210",
                        onTap: () => _launch("tel:+919876543210"),
                      ),
                      const Divider(height: 24),
                      _ContactTile(
                        icon: Icons.email_outlined,
                        label: "Email us",
                        value: "support@oliverbeautyparlour.com",
                        onTap: () =>
                            _launch("mailto:support@oliverbeautyparlour.com"),
                      ),
                      const Divider(height: 24),
                      _ContactTile(
                        icon: Icons.chat_bubble_outline_rounded,
                        label: "WhatsApp",
                        value: "Chat with us",
                        onTap: () => _launch("https://wa.me/919876543210"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Frequently Asked Questions",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textDark,
                    fontFamily: 'Georgia',
                  ),
                ),
                const SizedBox(height: 12),
                ..._faqs.map((f) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _FaqTile(question: f["q"]!, answer: f["a"]!),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _ContactTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppTheme.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textDark.withValues(alpha: 0.55),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded,
              color: AppTheme.textDark.withValues(alpha: 0.3)),
        ],
      ),
    );
  }
}

class _FaqTile extends StatefulWidget {
  final String question;
  final String answer;
  const _FaqTile({required this.question, required this.answer});

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => setState(() => _open = !_open),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _open ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(Icons.keyboard_arrow_down_rounded,
                        color: AppTheme.primary),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState:
                _open ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.answer,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: AppTheme.textDark.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ),
            secondChild: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// ABOUT US SCREEN
// ═══════════════════════════════════════════════════════════════════════
class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: Column(
        children: [
          const AboutScreen(title: "About Us"),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _sectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF8B4A43),
                                  Color(0xFFD4AF7A),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Center(
                              child: Text('✨', style: TextStyle(fontSize: 26)),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              "Oliver Beauty Parlour",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textDark,
                                fontFamily: 'Georgia',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Oliver Beauty Parlour brings salon-quality hair, skin and beauty services to your fingertips. From quick touch-ups to full bridal packages, we make it simple to discover, book and manage every appointment in one place.",
                        style: TextStyle(
                          fontSize: 13.5,
                          height: 1.55,
                          color: AppTheme.textDark.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _sectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Our Mission",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textDark,
                          fontFamily: 'Georgia',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "To make premium beauty care accessible, transparent and effortless — connecting clients with trusted stylists and a booking experience that feels as good as the service itself.",
                        style: TextStyle(
                          fontSize: 13.5,
                          height: 1.55,
                          color: AppTheme.textDark.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _sectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "App Info",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textDark,
                          fontFamily: 'Georgia',
                        ),
                      ),
                      const SizedBox(height: 14),
                      _InfoRow(label: "Version", value: "1.0.0"),
                      const Divider(height: 22),
                      _InfoRow(label: "Website", value: "oliverbeautyparlour.com"),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _sectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Follow Us",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textDark,
                          fontFamily: 'Georgia',
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          _SocialButton(
                            icon: Icons.camera_alt_outlined,
                            onTap: () => _launch(
                                "https://instagram.com/oliverbeautyparlour"),
                          ),
                          const SizedBox(width: 12),
                          _SocialButton(
                            icon: Icons.facebook_outlined,
                            onTap: () => _launch(
                                "https://facebook.com/oliverbeautyparlour"),
                          ),
                          const SizedBox(width: 12),
                          _SocialButton(
                            icon: Icons.language_rounded,
                            onTap: () =>
                                _launch("https://oliverbeautyparlour.com"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    "Made with 💛 by the Oliver team",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textDark.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.5,
            color: AppTheme.textDark.withValues(alpha: 0.6),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            color: AppTheme.textDark,
          ),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _SocialButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: AppTheme.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: AppTheme.primary, size: 20),
      ),
    );
  }
}