import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../providers/settings_provider.dart';
import '../screens/main_screen.dart';

class ProfileSetupController extends ChangeNotifier {
  final nameCtrl = TextEditingController();
  final contactCtrl = TextEditingController();
  String? imagePath;
  bool isLoading = false;

  void init(SettingsProvider sp, bool isEditing) {
    if (isEditing) {
      nameCtrl.text = sp.userName;
      contactCtrl.text = sp.userContact;
      imagePath = sp.userImagePath;
    }
  }

  Future<void> pickImage(BuildContext context) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        imagePath = picked.path;
        notifyListeners();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  Future<void> save(BuildContext context, SettingsProvider sp, bool isEditing) async {
    if (nameCtrl.text.trim().isEmpty) return;
    
    isLoading = true;
    notifyListeners();

    await sp.saveProfile(
      name: nameCtrl.text.trim(),
      contact: contactCtrl.text.trim(),
      imagePath: imagePath,
    );
    
    if (!context.mounted) return;
    
    if (isEditing) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    contactCtrl.dispose();
    super.dispose();
  }
}
