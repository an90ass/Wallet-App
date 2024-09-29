import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/controller/user_controller.dart';
import '../../../config/items/app_colors.dart';
import '../../../config/routes/route_name.dart';

class ProfileSettings extends StatefulWidget {
  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}
class _ProfileSettingsState extends State<ProfileSettings> {
  File? _profileImage;
  String? _profileImageUrl;
  final TextEditingController _nameController = TextEditingController();
  bool _isEditingName = false;
  bool _isUploading = false; 

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final userController = Provider.of<UserController>(context, listen: false);
    String? userName = await userController.getUserName();
    String? profileImageUrl = await userController.getProfileImageUrl();

    setState(() {
      _nameController.text = userName ?? '';
      _profileImageUrl = profileImageUrl;
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null && image.path.isNotEmpty) {
      setState(() {
        _profileImage = File(image.path);
      });
      await _uploadProfileImage();
    } else {
      _showMessage('No image selected or invalid file path.', Colors.red);
    }
  }

  Future<void> _uploadProfileImage() async {
    if (_profileImage != null) {
      setState(() {
        _isUploading = true;      
      });
      try {
        await Provider.of<UserController>(context, listen: false)
            .uploadProfileImage(_profileImage!);
        String? imageUrl =
            await Provider.of<UserController>(context, listen: false)
                .getProfileImageUrl();
        setState(() {
          _profileImageUrl = imageUrl;
        });
        _showMessage('Profile image updated successfully!', Colors.green);
      } catch (e) {
        _showMessage('Failed to upload image: $e', Colors.red);
      } finally {
        setState(() {
          _isUploading = false;  
        });
      }
    }
  }

  Future<void> _updateUserName() async {
    if (_nameController.text.isNotEmpty) {
      try {
        await Provider.of<UserController>(context, listen: false)  
            .updateUserName(_nameController.text);
        setState(() {
          _isEditingName = false;
        });
        _showMessage('Name updated successfully!', Colors.green);
      } catch (e) {
        _showMessage('Failed to update name: $e', Colors.red);
      }
    }
  }

  Future<void> _deleteAccount() async {
    String? password = await _showPasswordInputDialog(context);
    if (password != null) {
      try {
        await Provider.of<UserController>(context, listen: false)
            .reauthenticateUser(password: password);
        await Provider.of<UserController>(context, listen: false)
            .deleteAccount();
        _showMessage('Account deleted successfully', Colors.green);

        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteNames.signIn,
          (Route<dynamic> route) => false,
        );
      } catch (e) {
        if (e.toString().contains("wrong-password") ||
            e.toString().contains("invalid-credential")) {
          _showMessage('The password entered is incorrect. Please try again.', Colors.red);
        } else if (e.toString().contains("requires-recent-login")) {
          _showMessage('For security reasons, please log in again to confirm the action.', Colors.red);
        } else {
          _showMessage('Failed to delete account: $e', Colors.red);
        }
      }
    } else {
      _showMessage('Password is required to delete the account.', Colors.red);
    }
  }

  Future<String?> _showPasswordInputDialog(BuildContext context) async {
    String? password;
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter your password'),
          content: TextField(
            onChanged: (value) {
              password = value;
            },
            obscureText: true,
            decoration: InputDecoration(hintText: 'Password'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                if (password == null || password!.isEmpty) {
                  _showMessage('Please enter your password to proceed.', Colors.red);
                } else {
                  Navigator.of(context).pop(password);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: AppColors.containerColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildPictureAvatar(),
                SizedBox(height: 10),
                _isUploading
                    ? CircularProgressIndicator()     
                    : buildCangePictureButton(),
                SizedBox(height: 20),
                buildChangeUserNameField(),
                SizedBox(height: 80),
                buildDeleteAccountButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPictureAvatar() {
    return CircleAvatar(
      radius: 50,
      backgroundImage: _profileImage != null
          ? FileImage(_profileImage!)
          : (_profileImageUrl != null && _profileImageUrl!.isNotEmpty
              ? NetworkImage(_profileImageUrl!)
              : AssetImage('assets/images/profile.png')) as ImageProvider,
    );
  }

  Widget buildCangePictureButton() {
    return TextButton.icon(
      onPressed: _isUploading ? null : _pickImage, 
      icon: Icon(Icons.camera_alt, color: Colors.deepPurple),
      label: Text(
        'Change Profile Picture',
        style: TextStyle(color: Colors.deepPurple),
      ),
    );
  }

  Widget buildChangeUserNameField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _isEditingName
            ? Container(
                width: 150,
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(hintText: 'Enter Name'),
                ),
              )
            : Text(
                _nameController.text,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
        SizedBox(width: 10),
        IconButton(
          icon: Icon(
            _isEditingName ? Icons.check : Icons.edit,
            color: Colors.deepPurple,
          ),
          onPressed: () {
            if (_isEditingName) {
              _updateUserName();
            } else {
              setState(() {
                _isEditingName = true;
              });
            }
          },
        ),
      ],
    );
  }

  Widget buildDeleteAccountButton() {
    return ElevatedButton(
      onPressed: _deleteAccount,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      child: Column(
        children: [
          Icon(
            Icons.delete_forever,
            color: AppColors.darkPurpleColor,
            size: 30,
          ),
          SizedBox(height: 8),
          Text(
            'Delete Account',
            style: TextStyle(
              fontSize: 20,
              color: AppColors.darkPurpleColor,
            ),
          ),
        ],
      ),
    );
  }
}
