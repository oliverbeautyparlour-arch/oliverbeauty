import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webui/admin_panel/admin_home.dart';
import 'package:webui/frontend/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webui/frontend/app_theme.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  bool islogin;

  LoginScreen({super.key, required this.islogin});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

Future<void> saveUserSession(Map<String, dynamic> user) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString("userId", user["_id"] ?? "");
  await prefs.setString("name", user["name"] ?? "");
  await prefs.setString("email", user["email"] ?? "");
  await prefs.setBool("isLoggedIn", true);
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
      prefixIcon: Icon(icon, color: AppTheme.primaryLight),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white.withOpacity(0.08),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: AppTheme.primaryLight, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xFFFFC857), width: 1.4),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xFFFFC857), width: 1.8),
      ),
      errorStyle: const TextStyle(
        color: Color(0xFFFFC857),
        fontSize: 12.5,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
      ),
      errorMaxLines: 2,
    );
  }

  Widget containerbox({required Text child, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        splashColor: AppTheme.primaryDark.withOpacity(0.3),
        highlightColor: AppTheme.primaryDark.withOpacity(0.15),
        child: Container(
          width: 53,
          height: 53,
          decoration: BoxDecoration(
            color: AppTheme.primaryLight,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryDark,
                blurRadius: 8,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: Center(child: child),
        ),
      ),
    );
  }

  List<Widget> circleside() {
    List<Widget> circles = [];
    double width = MediaQuery.of(context).size.width;

    if (width > 900) {
      for (var i = 0; i < 6; i++) {
        double top = i == 0 ? -10 : i * 100;

        circles.add(
          Positioned(
            top: top,
            right: 480,
            child: _decorCircle(120, AppTheme.primaryDark),
          ),
        );

        circles.add(
          Positioned(
            top: top,
            left: 480,
            child: _decorCircle(120, AppTheme.primary),
          ),
        );
      }
    }

    return circles;
  }

  void _showForgotPasswordDialog() {
    final forgotEmailController = TextEditingController();
    final forgotFormKey = GlobalKey<FormState>();
    bool sending = false;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppTheme.primary, AppTheme.primaryDark],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Form(
                  key: forgotFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Reset Password",
                        style: TextStyle(
                          color: AppTheme.textDark,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Georgia',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Enter your account email and we'll send you a reset link.",
                        style: TextStyle(
                          color: AppTheme.textDark.withOpacity(0.85),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        controller: forgotEmailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.white),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: _fieldDecoration(
                          hint: "Email",
                          icon: Icons.email_outlined,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Email is required";
                          }
                          final emailRegex =
                              RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegex.hasMatch(value.trim())) {
                            return "Enter a valid email";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: sending
                                ? null
                                : () => Navigator.pop(dialogContext),
                            child: Text(
                              "Cancel",
                              style: TextStyle(color: AppTheme.textDark),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.bgCard,
                            ),
                            onPressed: sending
                                ? null
                                : () async {
                                    if (!forgotFormKey.currentState!
                                        .validate()) {
                                      return;
                                    }
                                    setDialogState(() => sending = true);
                                    try {
                                      final api = ApiService();
                                      // NOTE: add a `forgotPassword` method
                                      // to ApiService that POSTs to your
                                      // backend's password-reset endpoint.
                                      final result = await api.forgotPassword(
                                        email:
                                            forgotEmailController.text.trim(),
                                      );
                                      Navigator.pop(dialogContext);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            result["success"] == true
                                                ? "Reset link sent to your email"
                                                : (result["message"] ??
                                                    "Something went wrong"),
                                          ),
                                        ),
                                      );
                                    } catch (e) {
                                      setDialogState(() => sending = false);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Could not send reset link. Try again later.",
                                          ),
                                        ),
                                      );
                                    }
                                  },
                            child: sending
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    "Send Link",
                                    style: TextStyle(color: AppTheme.primary),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
 Future<void> _handleGoogleSignIn() async {
  try {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email'],
    );

    final GoogleSignInAccount? account = await googleSignIn.signIn();

    if (account == null) {
      return;
    }

    final GoogleSignInAuthentication auth =
        await account.authentication;

    final accessToken = auth.accessToken;

    if (accessToken == null) {
      _showMessage("Unable to get Google Access Token");
      return;
    }

    final api = ApiService();

    final result = await api.googleLogin(accessToken);

    if (result["success"] == true) {
      await saveUserSession(result["user"]);

      if (!mounted) return;

      context.read<AuthProvider>().login(
        id: result["user"]["_id"],
        userName: result["user"]["name"],
        userEmail: result["user"]["email"],
      );

      Navigator.pop(context, true);
    } else {
      _showMessage(result["message"]);
    }
  } catch (e) {
    _showMessage(e.toString());
  }
}
//  Future<void> _handleGoogleSignIn() async {
//   try {
//     // final GoogleSignIn googleSignIn = GoogleSignIn(
//     //   scopes: ['email'],
//     // );
//     final GoogleSignIn googleSignIn = GoogleSignIn(
//   clientId: "590642734390-o0tr2lfctpe3s3otctv9le8evmjp8b93.apps.googleusercontent.com",
//   scopes: ['email'],
// );

//     final GoogleSignInAccount? account =
//         await googleSignIn.signIn();

//     if (account == null) {
//       return;
//     }

//     // final GoogleSignInAuthentication auth =
//     //     await account.authentication;


//     final GoogleSignInAuthentication auth =
//     await account.authentication;
//     final idToken = auth.idToken;
// print("Access Token: ${auth.accessToken}");
// print("ID Token: ${auth.idToken}");
// print("Server Auth Code: ${auth.serverAuthCode}");

//     if (idToken == null) {
//       _showMessage("Unable to get Google token");
//       return;
//     }

//     final api = ApiService();

//     final result = await api.googleLogin(idToken);

//     if (result["success"] == true) {

//       await saveUserSession(result["user"]);

//       if (!mounted) return;

//       context.read<AuthProvider>().login(
//         id: result["user"]["_id"],
//         userName: result["user"]["name"],
//         userEmail: result["user"]["email"],
//       );

//       Navigator.pop(context, true);

//     } else {
//       _showMessage(result["message"]);
//     }

//   } catch (e) {
//     _showMessage(e.toString());
//   }
// }

  Future<void> _handleFacebookSignIn() async {
    // TODO: integrate flutter_facebook_auth — see step-by-step notes below.
    _showMessage("Facebook sign-in isn't set up yet");
  }

  Future<void> _handleXSignIn() async {
    // TODO: integrate X (Twitter) OAuth2 — see step-by-step notes below.
    _showMessage("X sign-in isn't set up yet");
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => isLoading = true);
    final api = ApiService();

    try {
      if (widget.islogin) {
        final result = await api.login(
          name: usernameController.text.trim(),
          password: passwordController.text.trim(),
        );

        if (result["success"] == true) {
          await saveUserSession(result["data"]);
          if (!mounted) return;
          context.read<AuthProvider>().login(
                userEmail: result["data"]["email"],
                userName: result["data"]["name"],
                id: result["data"]["_id"],
              );
          Navigator.pop(context, true);
          if (result["role"] == "admin") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => AdminHome()),
            );
          }
        } else {
          _showMessage(result["message"] ?? "Login failed");
        }
      } else {
        final result = await api.signup(
          name: usernameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        if (result["success"] == true) {
          await saveUserSession(result["data"]);
          if (!mounted) return;
          context.read<AuthProvider>().login(
                userEmail: result["data"]["email"],
                userName: result["data"]["name"],
                id: result["data"]["_id"],
              );
          _showMessage("Account Created Successfully");
          Navigator.pop(context, true);
        } else {
          _showMessage(result["message"] ?? "Sign up failed");
        }
      }
    } catch (e) {
      _showMessage("Something went wrong. Please try again.");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  widget.islogin ? "Login in to Oliver" : "Create Account",
                  style: TextStyle(
                    color: AppTheme.primaryDark,
                    fontSize: 21,
                    fontFamily: 'Georgia',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Stack(
                  children: [
                    ...circleside(),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width > 440
                            ? 400
                            : MediaQuery.of(context).size.width * 0.92,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.topRight,
                            colors: [AppTheme.primary, AppTheme.primaryDark],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 25,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Center(
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 20),
                                      Text(
                                        "Sign in with",
                                        style: TextStyle(
                                          color: AppTheme.textDark,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        "Or",
                                        style: TextStyle(
                                          color: AppTheme.primaryLight,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          containerbox(
                                            onTap: _handleGoogleSignIn,
                                            child: Text(
                                              'G',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: AppTheme.primaryDark,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 13),
                                          containerbox(
                                            onTap: _handleFacebookSignIn,
                                            child: Text(
                                              'f',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: AppTheme.primaryDark,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 13),
                                          containerbox(
                                            onTap: _handleXSignIn,
                                            child: Text(
                                              'X',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: AppTheme.primaryDark,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 15),
                                    ],
                                  ),
                                ),
                                Text(
                                  "Username",
                                  style: TextStyle(
                                    color: AppTheme.primaryLight,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: usernameController,
                                  keyboardType: TextInputType.name,
                                  textInputAction: TextInputAction.next,
                                  cursorColor: Colors.white,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: _fieldDecoration(
                                    hint: "Enter your username",
                                    icon: Icons.person_outline,
                                  ),
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().isEmpty) {
                                      return "Username is required";
                                    }
                                    if (value.trim().length < 3) {
                                      return "Minimum 3 characters";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 15),
                                if (!widget.islogin) ...[
                                  Text(
                                    "Email Id",
                                    style: TextStyle(
                                      color: AppTheme.primaryLight,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    cursorColor: Colors.white,
                                    style:
                                        const TextStyle(color: Colors.white),
                                    decoration: _fieldDecoration(
                                      hint: "Enter your email",
                                      icon: Icons.email_outlined,
                                    ),
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return "Email is required";
                                      }
                                      final emailRegex = RegExp(
                                        r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
                                      );
                                      if (!emailRegex
                                          .hasMatch(value.trim())) {
                                        return "Enter a valid email";
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 15),
                                ],
                                Text(
                                  "Password",
                                  style: TextStyle(
                                    color: AppTheme.primaryLight,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: passwordController,
                                  obscureText: hidePassword,
                                  keyboardType: TextInputType.visiblePassword,
                                  textInputAction: widget.islogin
                                      ? TextInputAction.done
                                      : TextInputAction.next,
                                  cursorColor: Colors.white,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: _fieldDecoration(
                                    hint: "Enter your password",
                                    icon: Icons.lock_outline,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        hidePassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: AppTheme.primaryLight,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          hidePassword = !hidePassword;
                                        });
                                      },
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Password is required";
                                    }
                                    if (value.length < 6) {
                                      return "Minimum 6 characters";
                                    }
                                    return null;
                                  },
                                ),
                                if (!widget.islogin) ...[
                                  const SizedBox(height: 15),
                                  Text(
                                    "Confirm Password",
                                    style: TextStyle(
                                      color: AppTheme.primaryLight,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: confirmPasswordController,
                                    obscureText: hideConfirmPassword,
                                    keyboardType:
                                        TextInputType.visiblePassword,
                                    textInputAction: TextInputAction.done,
                                    cursorColor: Colors.white,
                                    style:
                                        const TextStyle(color: Colors.white),
                                    decoration: _fieldDecoration(
                                      hint: "Re-enter your password",
                                      icon: Icons.lock_outline,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          hideConfirmPassword
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: AppTheme.primaryLight,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            hideConfirmPassword =
                                                !hideConfirmPassword;
                                          });
                                        },
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please confirm your password";
                                      }
                                      if (value != passwordController.text) {
                                        return "Passwords do not match";
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                                if (widget.islogin) ...[
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: _showForgotPasswordDialog,
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: const Size(0, 0),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(
                                        "Forgot Password?",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.bg,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text(
                                      widget.islogin
                                          ? "Don't have an account"
                                          : "Already have an account?",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.bg,
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    TextButton(
                                      onPressed: isLoading
                                          ? null
                                          : () {
                                              setState(() {
                                                widget.islogin =
                                                    !widget.islogin;
                                                _formKey.currentState
                                                    ?.reset();
                                              });
                                            },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: const Size(0, 0),
                                      ),
                                      child: Text(
                                        widget.islogin ? "Sign up" : "Login",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.bg,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 25),
                                Center(
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppTheme.bgCard,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 14),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                      ),
                                      onPressed:
                                          isLoading ? null : _handleSubmit,
                                      child: isLoading
                                          ? SizedBox(
                                              width: 22,
                                              height: 22,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.4,
                                                color: AppTheme.primary,
                                              ),
                                            )
                                          : Text(
                                              widget.islogin
                                                  ? "Login"
                                                  : "Create Account",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: AppTheme.primary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
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

PageRouteBuilder _slideRoute(Widget page) => PageRouteBuilder(
      pageBuilder: (_, a, __) => page,
      transitionsBuilder: (_, a, __, child) => SlideTransition(
        position: Tween(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic)),
        child: child,
      ),
      transitionDuration: const Duration(milliseconds: 350),
    );

Widget _decorCircle(double size, Color color) => Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );