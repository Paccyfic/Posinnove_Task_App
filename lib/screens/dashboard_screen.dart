import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import 'login.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic>? userData;
  String welcomeMessage = '';
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      // Get user data from local storage first
      final user = await AuthService.getUser();
      if (user != null) {
        setState(() {
          userData = user;
        });
      }

      // Fetch dashboard data from server
      final result = await AuthService.getDashboard();
      
      if (result['success']) {
        setState(() {
          welcomeMessage = result['data']['welcomeMessage'] ?? 'Welcome to your dashboard!';
          if (result['data']['user'] != null) {
            userData = result['data']['user'];
          }
        });
      } else {
        setState(() {
          errorMessage = result['message'];
        });
        
        // If token is invalid, redirect to login
        if (result['message'].contains('token') || result['message'].contains('Invalid')) {
          await AuthService.logout();
          Get.offAll(() => const LoginScreen());
        }
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load dashboard: ${e.toString()}';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _handleLogout() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await AuthService.logout();
                Get.offAll(() => const LoginScreen());
                Get.snackbar(
                  'Success',
                  'Logged out successfully',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Logout', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 18, 20, 22),
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF303030),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: _loadDashboard,
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
          IconButton(
            onPressed: _handleLogout,
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : errorMessage.isNotEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error Loading Dashboard',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade400,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            errorMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _loadDashboard,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF303030),
                          ),
                          child: const Text(
                            'Retry',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Welcome Card
                        Card(
                          color: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: const Color(0xFF303030),
                                      radius: 30,
                                      child: Text(
                                        userData?['username']?.substring(0, 1).toUpperCase() ?? 'U',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Welcome back!',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                          Text(
                                            userData?['username'] ?? 'User',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF303030),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF303030).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    welcomeMessage.isNotEmpty
                                        ? welcomeMessage
                                        : 'Welcome to your dashboard!',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF303030),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // User Info Card
                        Card(
                          color: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Account Information',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF303030),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _buildInfoRow(
                                  Icons.person_outline,
                                  'Username',
                                  userData?['username'] ?? 'N/A',
                                ),
                                const SizedBox(height: 12),
                                _buildInfoRow(
                                  Icons.email_outlined,
                                  'Email',
                                  userData?['email'] ?? 'N/A',
                                ),
                                const SizedBox(height: 12),
                                _buildInfoRow(
                                  Icons.verified_user_outlined,
                                  'Status',
                                  'Active',
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // Actions Card
                        Card(
                          color: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Quick Actions',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF303030),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: _loadDashboard,
                                        icon: const Icon(Icons.refresh, color: Colors.white),
                                        label: const Text(
                                          'Refresh',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF303030),
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: _handleLogout,
                                        icon: const Icon(Icons.logout, color: Colors.white),
                                        label: const Text(
                                          'Logout',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF303030), size: 20),
        const SizedBox(width: 12),
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF303030),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}