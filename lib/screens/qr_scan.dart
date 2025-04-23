import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';

class MealTrackerHome extends StatefulWidget {
  const MealTrackerHome({Key? key}) : super(key: key);

  @override
  State<MealTrackerHome> createState() => _MealTrackerHomeState();
}

class _MealTrackerHomeState extends State<MealTrackerHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hackathon Meal Tracker'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png', // Add your hackathon logo here
              height: 150,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.qr_code_scanner, size: 150, color: Theme.of(context).primaryColor),
            ),
            const SizedBox(height: 30),
            const Text(
              'Hackathon Meal Tracker',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Scan participant QR code to verify and update meal status',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Scan Participant QR'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const QrScan(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AdminLoginScreen(),
                  ),
                );
              },
              child: const Text('Admin Panel'),
            ),
          ],
        ),
      ),
    );
  }
}

// Admin login screen (simple implementation)
class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({Key? key}) : super(key: key);

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _attemptLogin() {
    if (_formKey.currentState!.validate()) {
      // For demo purposes using hardcoded credentials
      // In production, use proper authentication
      if (_usernameController.text == 'admin' && _passwordController.text == '123456') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const AdminDashboard(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid credentials')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Login'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _attemptLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Admin dashboard to view stats and manage participants
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  Map<String, dynamic> _stats = {
    'totalParticipants': 0,
    'breakfastServed': 0,
    'lunchServed': 0,
    'dinnerServed': 0,
  };
  List<Map<String, dynamic>> _participants = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get participants data
      final usersSnapshot = await _database.child('users').get();
      if (usersSnapshot.exists) {
        final users = usersSnapshot.value as Map<dynamic, dynamic>;
        _participants = [];
        int breakfastCount = 0;
        int lunchCount = 0;
        int dinnerCount = 0;

        users.forEach((key, value) {
          final userData = value as Map<dynamic, dynamic>;
          final participant = {
            'name': userData['name'] ?? 'Unknown',
            'email': userData['email'] ?? 'Unknown',
            'phone': userData['phone'] ?? 'Unknown',
            'year': userData['year'] ?? 'Unknown',
            'department': userData['department'] ?? 'Unknown',
            'breakfast': userData['breakfast'] ?? false,
            'lunch': userData['lunch'] ?? false,
            'dinner': userData['dinner'] ?? false,
          };

          _participants.add(participant);

          if (participant['breakfast']) breakfastCount++;
          if (participant['lunch']) lunchCount++;
          if (participant['dinner']) dinnerCount++;
        });

        setState(() {
          _stats = {
            'totalParticipants': _participants.length,
            'breakfastServed': breakfastCount,
            'lunchServed': lunchCount,
            'dinnerServed': dinnerCount,
          };
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Meal Status Overview',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatCard(
                            'Total Participants',
                            _stats['totalParticipants'].toString(),
                            Icons.people,
                            Colors.blue,
                          ),
                          _buildStatCard(
                            'Breakfast',
                            '${_stats['breakfastServed']}/${_stats['totalParticipants']}',
                            Icons.free_breakfast,
                            Colors.orange,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatCard(
                            'Lunch',
                            '${_stats['lunchServed']}/${_stats['totalParticipants']}',
                            Icons.lunch_dining,
                            Colors.green,
                          ),
                          _buildStatCard(
                            'Dinner',
                            '${_stats['dinnerServed']}/${_stats['totalParticipants']}',
                            Icons.dinner_dining,
                            Colors.purple,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Participants List',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.download),
                            label: const Text('Export CSV'),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Export feature to be implemented')),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Name')),
                            DataColumn(label: Text('Department')),
                            DataColumn(label: Text('Year')),
                            DataColumn(label: Text('Breakfast')),
                            DataColumn(label: Text('Lunch')),
                            DataColumn(label: Text('Dinner')),
                          ],
                          rows: _participants.map((participant) {
                            return DataRow(
                              cells: [
                                DataCell(Text(participant['name'])),
                                DataCell(Text(participant['department'])),
                                DataCell(Text(participant['year'])),
                                DataCell(_buildStatusIcon(participant['breakfast'])),
                                DataCell(_buildStatusIcon(participant['lunch'])),
                                DataCell(_buildStatusIcon(participant['dinner'])),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(bool status) {
    return status
        ? const Icon(Icons.check_circle, color: Colors.green)
        : const Icon(Icons.cancel, color: Colors.red);
  }
}

// Custom overlay painter for scanner
class ScannerOverlay extends CustomPainter {
  final double scannerSize;
  final Color borderColor;

  ScannerOverlay(this.scannerSize, this.borderColor);

  @override
  void paint(Canvas canvas, Size size) {
    final Rect scannerRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: scannerSize,
      height: scannerSize,
    );

    final Paint backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    // Draw background with hole
    final Path backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRect(scannerRect);

    canvas.drawPath(
      backgroundPath,
      backgroundPaint,
    );

    // Draw border
    canvas.drawRect(
      scannerRect,
      borderPaint,
    );

    // Draw corner markers
    const double cornerSize = 24;
    const double lineWidth = 4;

    final Paint cornerPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth;

    // Top left corner
    canvas.drawPath(
      Path()
        ..moveTo(scannerRect.left, scannerRect.top + cornerSize)
        ..lineTo(scannerRect.left, scannerRect.top)
        ..lineTo(scannerRect.left + cornerSize, scannerRect.top),
      cornerPaint,
    );

    // Top right corner
    canvas.drawPath(
      Path()
        ..moveTo(scannerRect.right - cornerSize, scannerRect.top)
        ..lineTo(scannerRect.right, scannerRect.top)
        ..lineTo(scannerRect.right, scannerRect.top + cornerSize),
      cornerPaint,
    );

    // Bottom left corner
    canvas.drawPath(
      Path()
        ..moveTo(scannerRect.left, scannerRect.bottom - cornerSize)
        ..lineTo(scannerRect.left, scannerRect.bottom)
        ..lineTo(scannerRect.left + cornerSize, scannerRect.bottom),
      cornerPaint,
    );

    // Bottom right corner
    canvas.drawPath(
      Path()
        ..moveTo(scannerRect.right - cornerSize, scannerRect.bottom)
        ..lineTo(scannerRect.right, scannerRect.bottom)
        ..lineTo(scannerRect.right, scannerRect.bottom - cornerSize),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class QrScan extends StatefulWidget {
  const QrScan({Key? key}) : super(key: key);

  @override
  State<QrScan> createState() => _QrScanState();
}

class _QrScanState extends State<QrScan> {
  String scanStatus = 'Ready to scan';
  bool hasPermission = false;
  bool isLoading = false;
  bool isSuccess = false;
  bool isError = false;
  String mealType = 'breakfast'; // Default meal type
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      hasPermission = status.isGranted;
    });

    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Camera permission is required to scan QR codes'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  // Process the scanned QR data
  Future<void> _processQrData(String qrData) async {
    try {
      setState(() {
        isLoading = true;
        scanStatus = 'Processing...';
        isSuccess = false;
        isError = false;
      });

      // Parse the JSON data from QR code
      final Map<String, dynamic> qrJson = json.decode(qrData);

      // if (!qrJson.containsKey('id')) {
      //   throw Exception('Invalid QR code format. Missing ID field.');
      // }

      final String participantId = qrJson['id'];

      // Query the database for this participant
      final participantSnapshot = await _database.child('users').child(participantId).get();

      if (!participantSnapshot.exists) {
        throw Exception('Participant not found in database');
      }

      final participant = participantSnapshot.value as Map<dynamic, dynamic>;

      // Check if the meal has already been served
      if (participant[mealType] == true) {
        setState(() {
          scanStatus = 'This ${mealType.capitalize()} has already been served to ${participant['name']}';
          isLoading = false;
          isError = true;
        });
        return;
      }

      // Update the meal status in Firebase
      await _database.child('users').child(participantId).update({
        mealType: true,
      });

      setState(() {
        scanStatus = 'Success! ${mealType.capitalize()} marked for ${participant['name']}';
        isLoading = false;
        isSuccess = true;
      });

    } catch (e) {
      setState(() {
        scanStatus = 'Error: ${e.toString()}';
        isLoading = false;
        isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Participant QR'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Meal type selector
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text('Select meal: ', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: mealType,
                  items: ['breakfast', 'lunch', 'dinner'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value.capitalize()),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      mealType = newValue!;
                    });
                  },
                ),
              ],
            ),
          ),

          // Status display
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isSuccess
                  ? Colors.green.withOpacity(0.1)
                  : isError
                  ? Colors.red.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSuccess
                    ? Colors.green
                    : isError
                    ? Colors.red
                    : Colors.grey,
              ),
            ),
            child: Row(
              children: [
                isLoading
                    ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2))
                    : isSuccess
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : isError
                    ? const Icon(Icons.error, color: Colors.red)
                    : const Icon(Icons.info, color: Colors.grey),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    scanStatus,
                    style: TextStyle(
                      color: isSuccess
                          ? Colors.green
                          : isError
                          ? Colors.red
                          : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Scanner view
          Expanded(
            child: hasPermission
                ? Stack(
              children: [
                MobileScanner(
                  controller: MobileScannerController(),
                  onDetect: (BarcodeCapture capture) {
                    final List<Barcode> barcodes = capture.barcodes;
                    if (barcodes.isNotEmpty && !isLoading) {
                      final String? code = barcodes.first.rawValue;
                      if (code != null) {
                        _processQrData(code);
                      }
                    }
                  },
                  errorBuilder: (context, error, child) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 60, color: Colors.red),
                          const SizedBox(height: 16),
                          const Text(
                            'Scanner Error',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(error.errorDetails?.message ?? 'Unknown error occurred'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const QrScan()),
                              );
                            },
                            child: const Text('Try Again'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                CustomPaint(
                  painter: ScannerOverlay(
                    MediaQuery.of(context).size.width * 0.8,
                    Theme.of(context).primaryColor,
                  ),
                  child: const SizedBox.expand(),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: const Text(
                          'Position the QR code in the frame',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
                : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.camera_alt_sharp, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Camera permission required'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _requestCameraPermission,
                    child: const Text('Grant Permission'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: isSuccess || isError
              ? () {
            setState(() {
              scanStatus = 'Ready to scan';
              isSuccess = false;
              isError = false;
            });
          }
              : null,
          child: const Text('Scan Next'),
        ),
      ),
    );
  }
}

// Extension to capitalize first letter of string
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}