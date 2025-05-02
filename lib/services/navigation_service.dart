// navigation_service.dart
import 'package:flutter/material.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static bool isAdminMode = false; // Track if user is in admin mode

  // Navigate to a named route
  static Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
  }

  // Replace the current route with a new one
  static Future<dynamic> navigateToReplace(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushReplacementNamed(routeName, arguments: arguments);
  }

  // Handle back button press based on current mode
  static Future<bool> handleBackPress(BuildContext context) async {
    if (isAdminMode) {
      // If in admin mode, show confirmation dialog
      return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Exit Admin Mode'),
          content: const Text('This will exit the admin mode. Are you sure?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        ),
      ) ?? false;
    }

    // Default behavior for non-admin screens
    return true;
  }
}