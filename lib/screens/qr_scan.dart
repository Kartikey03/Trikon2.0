import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';

class MealTrackerHome extends StatefulWidget {
  const MealTrackerHome({super.key});

  @override
  State<MealTrackerHome> createState() => _MealTrackerHomeState();
}

class _MealTrackerHomeState extends State<MealTrackerHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Hackathon Meal Tracker'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/trikon_logo.jpg', // Add your hackathon logo here
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
        automaticallyImplyLeading: false,
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
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {

  // Add this method to the _AdminDashboardState class to handle storage permissions
  Future<bool> _requestStoragePermission() async {
    var status = await Permission.storage.status;

    // If permission is already granted, return true
    if (status.isGranted) {
      return true;
    }

    // If permission was previously denied but can be requested, show dialog first
    if (status.isDenied) {
      // Show explanation dialog
      bool shouldRequest = await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Storage Permission Required'),
          content: const Text(
              'To export participant data as a CSV file, this app needs permission to access device storage. '
                  'Please grant storage permission on the next screen.'
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Continue'),
            ),
          ],
        ),
      ) ?? false;

      if (!shouldRequest) {
        return false;
      }

      // Request permission
      status = await Permission.storage.request();
      return status.isGranted;
    }

    // If permission is permanently denied, direct user to settings
    if (status.isPermanentlyDenied) {
      bool openSettings = await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Storage Permission Required'),
          content: const Text(
              'Storage permission is required to export participant data. '
                  'Please enable it in the app settings.'
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Open Settings'),
            ),
          ],
        ),
      ) ?? false;

      if (openSettings) {
        await openAppSettings();
        // Re-check permission after returning from settings
        return await Permission.storage.status.isGranted;
      }
      return false;
    }

    return false;
  }

// Add this method to check Android version and request appropriate permissions
  Future<bool> _checkAndRequestStoragePermissions() async {
    // First try regular storage permissions
    bool hasRegularPermission = await _requestStoragePermission();
    if (hasRegularPermission) {
      return true;
    }

    // If that fails, guide the user to settings
    bool shouldRequestManageStorage = await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Additional Permission Required'),
        content: const Text(
            'Exporting files requires additional permissions. '
                'Please enable file access for this app in the next screen.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Continue'),
          ),
        ],
      ),
    ) ?? false;

    if (shouldRequestManageStorage) {
      await openAppSettings();
      return true;
    }

    return false;
  }

  Future<void> _exportToCsv() async {
    try {
      // Check if all required storage permissions are granted
      bool hasPermission = await _checkAndRequestStoragePermissions();
      if (!hasPermission) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission is required to export CSV')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      // Create CSV header - Updated to include new meal types
      String csvData = 'Name,Email,Phone,Department,Year,Check In,Breakfast,Breakfast2,Lunch,Dinner\n';

      // Add participant data - Updated to include new meal types
      for (var participant in _participants) {
        csvData += '${_escapeCsvField(participant['name'])},';
        csvData += '${_escapeCsvField(participant['email'])},';
        csvData += '${_escapeCsvField(participant['phone'])},';
        csvData += '${_escapeCsvField(participant['department'])},';
        csvData += '${_escapeCsvField(participant['year'])},';
        csvData += '${participant['check_in'] ? 'Yes' : 'No'},';
        csvData += '${participant['breakfast'] ? 'Yes' : 'No'},';
        csvData += '${participant['breakfast2'] ? 'Yes' : 'No'},';
        csvData += '${participant['lunch'] ? 'Yes' : 'No'},';
        csvData += '${participant['dinner'] ? 'Yes' : 'No'}\n';
      }

      // Try saving to Downloads folder first (preferred location)
      Directory? directory;
      try {
        // Get downloads directory (works on Android)
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          // Fallback to app documents directory
          directory = await getApplicationDocumentsDirectory();
        }
      } catch (e) {
        // Fallback to app documents directory
        directory = await getApplicationDocumentsDirectory();
      }

      final now = DateTime.now();
      final formatter = DateFormat('yyyyMMdd_HHmmss');
      final String fileName = 'participants_${formatter.format(now)}.csv';
      final File file = File('${directory.path}/$fileName');

      // Write to file
      await file.writeAsString(csvData);

      // Show success dialog with file location
      await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('CSV Export Successful'),
          content: Text('File saved to:\n${file.path}\n\nWould you like to share this file?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Share.shareXFiles(
                  [XFile(file.path)],
                  text: 'Hackathon Participants Data',
                );
              },
              child: const Text('Share'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error exporting CSV: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

// Helper method to properly escape CSV fields
  String _escapeCsvField(dynamic value) {
    if (value == null) return '';
    String stringValue = value.toString();
    // If the field contains commas, quotes, or newlines, enclose it in quotes
    if (stringValue.contains(',') || stringValue.contains('"') || stringValue.contains('\n')) {
      // Double up any quotes
      stringValue = stringValue.replaceAll('"', '""');
      // Enclose in quotes
      return '"$stringValue"';
    }
    return stringValue;
  }


  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  Map<String, dynamic> _stats = {
    'totalParticipants': 0,
    'checkInCount': 0,     // Added for check_in
    'breakfastServed': 0,
    'breakfast2Served': 0, // Added for breakfast2
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
        int checkInCount = 0;       // Added for check_in
        int breakfastCount = 0;
        int breakfast2Count = 0;    // Added for breakfast2
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
            'check_in': userData['check_in'] ?? false,     // Added for check_in
            'breakfast': userData['breakfast'] ?? false,
            'breakfast2': userData['breakfast2'] ?? false, // Added for breakfast2
            'lunch': userData['lunch'] ?? false,
            'dinner': userData['dinner'] ?? false,
          };

          _participants.add(participant);

          if (participant['check_in']) checkInCount++;       // Added for check_in
          if (participant['breakfast']) breakfastCount++;
          if (participant['breakfast2']) breakfast2Count++;  // Added for breakfast2
          if (participant['lunch']) lunchCount++;
          if (participant['dinner']) dinnerCount++;
        });

        setState(() {
          _stats = {
            'totalParticipants': _participants.length,
            'checkInCount': checkInCount,               // Added for check_in
            'breakfastServed': breakfastCount,
            'breakfast2Served': breakfast2Count,        // Added for breakfast2
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
        automaticallyImplyLeading: false,
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
                            'Check In',
                            '${_stats['checkInCount']}/${_stats['totalParticipants']}',
                            Icons.app_registration,
                            Colors.teal,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatCard(
                            'Breakfast',
                            '${_stats['breakfastServed']}/${_stats['totalParticipants']}',
                            Icons.free_breakfast,
                            Colors.orange,
                          ),
                          _buildStatCard(
                            'Breakfast 2',
                            '${_stats['breakfast2Served']}/${_stats['totalParticipants']}',
                            Icons.coffee,
                            Colors.brown,
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
                            onPressed: _exportToCsv,
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
                            DataColumn(label: Text('Check In')),
                            DataColumn(label: Text('Breakfast')),
                            DataColumn(label: Text('Breakfast 2')),
                            DataColumn(label: Text('Lunch')),
                            DataColumn(label: Text('Dinner')),
                          ],
                          rows: _participants.map((participant) {
                            return DataRow(
                              cells: [
                                DataCell(Text(participant['name'])),
                                DataCell(Text(participant['department'])),
                                DataCell(Text(participant['year'])),
                                DataCell(_buildStatusIcon(participant['check_in'])),
                                DataCell(_buildStatusIcon(participant['breakfast'])),
                                DataCell(_buildStatusIcon(participant['breakfast2'])),
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
  String mealType = 'check_in'; // Default changed to check_in
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

      // Check if the QR code contains an email field
      if (!qrJson.containsKey('email')) {
        throw Exception('Invalid QR code format. Missing email field.');
      }

      final String participantEmail = qrJson['email'];

      // We need to query all users and find the one with matching email
      final usersSnapshot = await _database.child('users').get();

      if (!usersSnapshot.exists) {
        throw Exception('No users found in database');
      }

      // Convert all users to a map
      final usersData = usersSnapshot.value as Map<dynamic, dynamic>;

      // Variables to store matched participant details
      String? participantId;
      Map<dynamic, dynamic>? participant;

      // Find the user with matching email
      usersData.forEach((key, value) {
        if (value is Map && value.containsKey('email') && value['email'] == participantEmail) {
          participantId = key;
          participant = value;
        }
      });

      // Check if a matching participant was found
      if (participantId == null || participant == null) {
        throw Exception('No participant found with email: $participantEmail');
      }

      // Check if the meal has already been served
      if (participant![mealType] == true) {
        setState(() {
          // Format the message based on meal type
          String mealTypeName = mealType;
          if (mealType == 'check_in') {
            mealTypeName = 'Check In';
          } else if (mealType == 'breakfast2') {
            mealTypeName = 'Breakfast 2';
          } else {
            mealTypeName = mealType.capitalize();
          }

          scanStatus = 'This $mealTypeName has already been recorded for ${participant!['name']}';
          isLoading = false;
          isError = true;
        });
        return;
      }

      // Update the meal status in Firebase
      await _database.child('users').child(participantId!).update({
        mealType: true,
      });

      setState(() {
        // Format the message based on meal type
        String mealTypeName = mealType;
        if (mealType == 'check_in') {
          mealTypeName = 'Check In';
        } else if (mealType == 'breakfast2') {
          mealTypeName = 'Breakfast 2';
        } else {
          mealTypeName = mealType.capitalize();
        }

        scanStatus = 'Success! $mealTypeName marked for ${participant!['name']}';
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
          // Meal type selector - Updated to include new meal types
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text('Select type: ', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: mealType,
                  items: ['check_in', 'breakfast', 'breakfast2', 'lunch', 'dinner'].map((String value) {
                    String displayName = value;
                    if (value == 'check_in') {
                      displayName = 'Check In';
                    } else if (value == 'breakfast2') {
                      displayName = 'Breakfast 2';
                    } else {
                      displayName = value.capitalize();
                    }

                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(displayName),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        mealType = newValue;
                      });
                    }
                  },
                ),
              ],
            ),
          ),

          // QR scanner view
          Expanded(
            child: hasPermission
                ? Stack(
              alignment: Alignment.center,
              children: [
                // QR scanner
                MobileScanner(
                  onDetect: (capture) {
                    final barcodes = capture.barcodes;

                    // Only process if we're not already loading
                    if (barcodes.isNotEmpty && !isLoading) {
                      final qrData = barcodes.first.rawValue;
                      if (qrData != null && qrData.isNotEmpty) {
                        _processQrData(qrData);
                      }
                    }
                  },
                ),

                // Scanner overlay
                CustomPaint(
                  painter: ScannerOverlay(
                    300.0,
                    Theme.of(context).primaryColor,
                  ),
                  child: Container(),
                ),
              ],
            )
                : const Center(
              child: Text(
                'Camera permission not granted',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            ),
          ),

          // Status display
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: isSuccess
                ? Colors.green.shade100
                : isError
                ? Colors.red.shade100
                : Colors.grey.shade200,
            child: Column(
              children: [
                isLoading
                    ? const CircularProgressIndicator()
                    : Icon(
                  isSuccess
                      ? Icons.check_circle
                      : isError
                      ? Icons.error
                      : Icons.qr_code_scanner,
                  size: 36,
                  color: isSuccess
                      ? Colors.green
                      : isError
                      ? Colors.red
                      : Colors.grey,
                ),
                const SizedBox(height: 8),
                Text(
                  scanStatus,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSuccess
                        ? Colors.green.shade800
                        : isError
                        ? Colors.red.shade800
                        : Colors.black87,
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

// Extension to capitalize first letter of a string
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}