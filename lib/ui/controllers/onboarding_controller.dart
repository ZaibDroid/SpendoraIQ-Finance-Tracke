import 'package:flutter/material.dart';
import '../../../data/local/shared_prefs_helper.dart';
import '../screens/profile_setup_screen.dart';

class OnboardingController extends ChangeNotifier {
  final PageController pageController = PageController();
  int currentPage = 0;

  void setPage(int page) {
    if (currentPage != page) {
      currentPage = page;
      notifyListeners();
    }
  }

  void next(BuildContext context, int totalPages) {
    if (currentPage < totalPages - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      finish(context);
    }
  }

  void previous() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Future<void> finish(BuildContext context) async {
    await SharedPrefsHelper.saveSetting('hasOnboarded', true);
    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ProfileSetupScreen()),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
