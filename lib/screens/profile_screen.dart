import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          AppStrings.profile,
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            
            // Avatar Section
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withOpacity(0.2),
                        ],
                      ),
                    ),
                    child: const CircleAvatar(
                      radius: 60,
                      backgroundColor: Color(0xFF1E262E),
                      child: Text('👨🏻‍💻', style: TextStyle(fontSize: 60)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'User1234',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 60),
            
            // Profile Fields
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildProfileItem(
                    label: AppStrings.name.split(' ')[1], // "Username"
                    value: AppStrings.usernamePlaceholder,
                  ),
                  _buildProfileItem(
                    label: AppStrings.email,
                    value: AppStrings.emailPlaceholder,
                  ),
                  _buildProfileItem(
                    label: AppStrings.mobileNumber,
                    value: AppStrings.mobilePlaceholder,
                  ),
                  _buildProfileItem(
                    label: AppStrings.password,
                    value: AppStrings.passwordPlaceholder,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 16,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: AppColors.white.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            Icons.arrow_forward_ios,
            color: AppColors.white.withOpacity(0.5),
            size: 16,
          ),
        ],
      ),
    );
  }
}
