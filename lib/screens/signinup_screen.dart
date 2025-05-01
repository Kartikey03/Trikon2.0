import 'package:flutter/material.dart';
import 'package:trikon2/screens/qr_scan.dart';
import '../widgets/team_dropdown.dart';
import 'admin_screen.dart';
import 'homescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  bool _passwordVisible = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  bool _checkingAuthStatus = true;
  bool _isResettingPassword = false;
  bool _isVerificationEmailSent = false;

  // Admin credentials
  final String _adminEmail = "intelliasociety@gmail.com";
  final String _adminPassword = "wow123";

  final String _guestEmail = "trikon@intellia.com";
  final String _guestPassword = "info@trikon";

  // List of years, departments and branches for dropdowns
  final List<String> _years = ['1st Year', '2nd Year', '3rd Year', '4th Year'];
  final List<String> _departments = ['CSE', 'ECE', 'EE', 'Bio Tech', 'B Pharma', 'MBA', 'Other'];
  final List<String> _branches = ['Core', 'AIML', 'AI', 'CSIT', 'DS', 'CS', 'Other'];

  String? _selectedYear;
  String? _selectedDepartment;
  String? _selectedBranch;
  String? _selectedTeam;  // Add this to track selected team

  // Firebase Realtime Database reference
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();

    // Check if user is already signed in when the page loads
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    try {
      // Get current user directly rather than using a listener
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Check if the user's email is verified
        if (currentUser.emailVerified || currentUser.email == _adminEmail || currentUser.email == _guestEmail) {
          // Check if the signed-in user is an admin
          if (currentUser.email == _adminEmail) {
            // Route to admin page
            Future.delayed(Duration.zero, () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const AdminScreen()),
                    (route) => false,
              );
            });
          }
          if (currentUser.email == _guestEmail) {
            // Route to admin page
            Future.delayed(Duration.zero, () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
              );
            });
          }
          else {
            // Route to regular user page
            Future.delayed(Duration.zero, () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
              );
            });
          }
        } else {
          // Show email verification needed message
          Future.delayed(Duration.zero, () {
            _showEmailVerificationNeededDialog(currentUser);
          });
        }
      }
    } catch (e) {
      print("Error checking authentication status: $e");
    } finally {
      // Update loading state regardless of result
      if (mounted) {
        setState(() {
          _checkingAuthStatus = false;
        });
      }
    }
  }

  // Show dialog for email verification needed
  void _showEmailVerificationNeededDialog(User user) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Email Verification Required'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Your email has not been verified yet. Please check your email for a verification link.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Text(
              'Email: ${user.email}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              // Sign out first
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pop();
            },
            child: const Text('Sign Out'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                setState(() {
                  _isLoading = true;
                });
                // Resend verification email
                await user.sendEmailVerification();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Verification email sent! Please check your inbox.'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error sending verification email: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              } finally {
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                  });
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.tealAccent.shade700,
              foregroundColor: Colors.white,
            ),
            child: const Text('Resend Verification Email'),
          ),
        ],
      ),
    );
  }

  // Show verification email sent dialog
  void _showVerificationEmailSentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Verify Your Email'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'A verification link has been sent to your email address. Please check your inbox and click the link to verify your email before logging in.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Text(
              'Email: ${_emailController.text}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Write user data to Realtime Database
  Future<void> _writeUserData(String uid, String name, String email, String phone,
      String year, String department, String branch, String? team, bool breakfast, bool lunch, bool dinner) async {
    try {
      await _databaseRef.child("users").child(uid).set({
        'name': name,
        'email': email,
        'phone': phone,
        'year': year,
        'department': department,
        'branch': branch,
        'team': team ?? "",
        'breakfast': false,
        'lunch': false,
        'dinner': false,
        'emailVerified': false,
        'createdAt': DateTime.now().toIso8601String(),
      });
      print("User data added to Realtime Database successfully");
    } catch (e) {
      print("Error writing to Realtime Database: $e");
      throw e; // Re-throw to handle in the calling function
    }
  }

  // Reset password method
  Future<void> _resetPassword(String email) async {
    setState(() {
      _isResettingPassword = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset email sent to your registered email'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Failed to send password reset email';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found with this email';
      } else if (e.message != null) {
        errorMessage = e.message!;
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isResettingPassword = false;
        });
      }
    }
  }

  // Send verification email
  Future<void> _sendVerificationEmail(User user) async {
    try {
      await user.sendEmailVerification();
      setState(() {
        _isVerificationEmailSent = true;
      });
    } catch (e) {
      print("Error sending verification email: $e");
      throw e;
    }
  }

  // Show reset password dialog
  void _showForgotPasswordDialog() {
    final TextEditingController resetEmailController = TextEditingController();
    resetEmailController.text = _emailController.text; // Pre-fill with email if available

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter your email address and we\'ll send you a link to reset your password.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: resetEmailController,
              decoration: InputDecoration(
                hintText: 'Email',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          _isResettingPassword
              ? const CircularProgressIndicator()
              : ElevatedButton(
            onPressed: () {
              final email = resetEmailController.text.trim();
              if (email.isNotEmpty) {
                Navigator.of(context).pop();
                _resetPassword(email);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter your email'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.tealAccent.shade700,
              foregroundColor: Colors.white,
            ),
            child: const Text('Send Reset Link'),
          ),
        ],
      ),
    );
  }

  // Check if email is verified (with reload for latest status)
  Future<bool> _checkEmailVerified(User user) async {
    await user.reload();
    User? refreshedUser = FirebaseAuth.instance.currentUser;
    return refreshedUser != null && refreshedUser.emailVerified;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _toggleAuthMode() {
    setState(() {
      isLogin = !isLogin;
      // Clear fields when toggling
      if (!isLogin) {
        _selectedYear = null;
        _selectedDepartment = null;
        _selectedBranch = null;
        _selectedTeam = null;
      }
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while checking authentication status
    if (_checkingAuthStatus) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Container(
                    width: 50,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/trikon_logo.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Title
                Text(
                  isLogin ? 'Welcome Back' : 'Join Us Today',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Subtitle
                Text(
                  isLogin
                      ? 'Sign in to access your account'
                      : 'Complete your profile to get started',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Registration fields
                      if (!isLogin) ...[
                        // Personal Info Section
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.teal.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Personal Information',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Name field
                              TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  hintText: 'Full Name',
                                  prefixIcon: const Icon(Icons.person_outline),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Phone field
                              TextFormField(
                                controller: _phoneController,
                                decoration: InputDecoration(
                                  hintText: 'Mobile Number',
                                  prefixIcon: const Icon(Icons.phone_outlined),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your Mobile number';
                                  }
                                  // Simple phone validation
                                  if (!RegExp(r'^\d{10}$').hasMatch(value) &&
                                      !RegExp(r'^\+\d{1,3}\d{10}$').hasMatch(value)) {
                                    return 'Please enter a valid phone number';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 16),

                              SearchableDropdown(
                                hintText: 'Select Your '
                                    'Team',
                                prefixIcon: const Icon(Icons.group),
                                value: _selectedTeam,
                                isLoading: _isLoading,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedTeam = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select your team';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Academic Info Section
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.teal.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Academic Information',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Year dropdown
                              DropdownButtonFormField<String>(
                                value: _selectedYear,
                                decoration: InputDecoration(
                                  hintText: 'Select Year',
                                  prefixIcon: const Icon(Icons.calendar_today),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                items: _years.map((String year) {
                                  return DropdownMenuItem<String>(
                                    value: year,
                                    child: Text(year),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedYear = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select your year';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Department dropdown
                              DropdownButtonFormField<String>(
                                value: _selectedDepartment,
                                decoration: InputDecoration(
                                  hintText: 'Select Department',
                                  prefixIcon: const Icon(Icons.business),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                items: _departments.map((String department) {
                                  return DropdownMenuItem<String>(
                                    value: department,
                                    child: Text(department),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedDepartment = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select your department';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Branch dropdown
                              DropdownButtonFormField<String>(
                                value: _selectedBranch,
                                decoration: InputDecoration(
                                  hintText: 'Select Branch',
                                  prefixIcon: const Icon(Icons.category),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                items: _branches.map((String branch) {
                                  return DropdownMenuItem<String>(
                                    value: branch,
                                    child: Text(branch),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedBranch = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select your branch';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Account Info Section (always visible)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isLogin ? Colors.white : Colors.teal.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: isLogin ? Border.all(color: Colors.grey.shade300) : null,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isLogin) ...[
                              const Text(
                                'Login Information',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                              const SizedBox(height: 16),
                            ] else ...[
                              const Text(
                                'Account Information',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],

                            // Email field
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: 'Email',
                                prefixIcon: const Icon(Icons.email_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                    .hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Password field with visibility toggle
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey.shade600,
                                  ),
                                  onPressed: _togglePasswordVisibility,
                                  tooltip: _passwordVisible
                                      ? 'Hide password'
                                      : 'Show password',
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              obscureText: !_passwordVisible,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (!isLogin && value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),

                      // Forgot password (only for login)
                      if (isLogin)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _showForgotPasswordDialog,
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(
                                color: Colors.tealAccent.shade700,
                              ),
                            ),
                          ),
                        ),

                      const SizedBox(height: 24),

                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });

                              final email = _emailController.text.trim();
                              final password = _passwordController.text.trim();

                              try {
                                if (isLogin) {
                                  // Check if the login is for admin credentials
                                  if (email == _adminEmail && password == _adminPassword) {
                                    // For admin login, we can either:
                                    // Option 1: Sign in with Firebase (if admin account exists)
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(email: email, password: password);

                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Admin signed in successfully')),
                                      );

                                      // Navigate to Admin page
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => const AdminScreen()),
                                      );
                                    }
                                  }
                                  else if (email == _guestEmail && password == _guestPassword) {
                                    // For admin login, we can either:
                                    // Option 1: Sign in with Firebase (if admin account exists)
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(email: email, password: password);

                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Guest signed in successfully')),
                                      );

                                      // Navigate to Admin page
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                                      );
                                    }
                                  }
                                  else {
                                    // Regular user login
                                    UserCredential userCredential = await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(email: email, password: password);

                                    // Check if email is verified
                                    if (userCredential.user != null && userCredential.user!.emailVerified) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Signed in successfully')),
                                        );

                                        // Navigate to regular user page
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                                        );
                                      }
                                    } else {
                                      // Email not verified
                                      if (mounted) {
                                        // Show dialog to verify email
                                        _showEmailVerificationNeededDialog(userCredential.user!);
                                      }
                                    }
                                  }
                                } else {
                                  // Sign up with additional info
                                  final name = _nameController.text.trim();
                                  final phone = _phoneController.text.trim();
                                  final year = _selectedYear ?? "";
                                  final department = _selectedDepartment ?? "";
                                  final branch = _selectedBranch ?? "";
                                  final team = _selectedTeam ?? "";  // Fixed to use _selectedTeam instead of _selectedYear
                                  final breakfast = false;
                                  final lunch = false;
                                  final dinner = false;

                                  // Create the user
                                  UserCredential userCredential = await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(email: email, password: password);

                                  // Update display name in Firebase Auth
                                  await userCredential.user!.updateDisplayName(name);

                                  // Send verification email
                                  await _sendVerificationEmail(userCredential.user!);

                                  // Store user details in Firebase Realtime Database
                                  await _writeUserData(
                                    userCredential.user!.uid,
                                    name,
                                    email,
                                    phone,
                                    year,
                                    department,
                                    branch,
                                    team,
                                    breakfast,
                                    lunch,
                                    dinner,
                                  );

                                  // Show verification email sent dialog
                                  if (mounted) {
                                    _showVerificationEmailSentDialog();
                                  }

                                  // Clear password field
                                  _passwordController.clear();

                                  if (mounted) {
                                    // Switch to login mode
                                    setState(() {
                                      isLogin = true;
                                      _isLoading = false;
                                    });

                                    // Show success message
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Account created successfully. Please verify your email before logging in.'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                }
                              } on FirebaseAuthException catch (e) {
                                String errorMessage = 'Authentication error';
                                if (e.message != null) {
                                  errorMessage = e.message!;
                                }
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(errorMessage),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error: ${e.toString()}'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.tealAccent.shade700,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : Text(
                            isLogin ? 'Sign In' : 'Create Account',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Toggle between login and signup
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isLogin
                                ? 'Don\'t have an account?'
                                : 'Already have an account?',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          TextButton(
                            onPressed: _toggleAuthMode,
                            child: Text(
                              isLogin ? 'Sign Up' : 'Sign In',
                              style: TextStyle(
                                color: Colors.tealAccent.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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