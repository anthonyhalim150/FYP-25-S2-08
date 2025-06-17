import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wise_workout_app/services/profile_edit_service.dart';

class EditProfileScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String username;
  final String dob;
  final String email;
  final String level;
  final String accountType;
  final String profileImage;
  final String backgroundImage;

  const EditProfileScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.dob,
    required this.email,
    required this.level,
    required this.accountType,
    required this.profileImage,
    required this.backgroundImage,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool isEditing = false;

  late String firstName;
  late String lastName;
  late String username;
  late String dateOfBirth;
  late String email;
  late String level;
  late String accountType;
  late String profileImage;
  late String backgroundImage;

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController dobController;
  late TextEditingController usernameController;

  @override
  void initState() {
    super.initState();
    firstName = widget.firstName;
    lastName = widget.lastName;
    username = widget.username;
    dateOfBirth = widget.dob;
    email = widget.email;
    level = widget.level;
    accountType = widget.accountType;
    profileImage = widget.profileImage;
    backgroundImage = widget.backgroundImage;

    firstNameController = TextEditingController(text: firstName);
    lastNameController = TextEditingController(text: lastName);
    dobController = TextEditingController(
      text: _formatIncomingDOB(dateOfBirth),
    );
    usernameController = TextEditingController(text: username);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    dobController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  void startEditing() {
    setState(() => isEditing = true);
  }

  void saveEdits() async {
    setState(() {
      firstName = firstNameController.text.trim();
      lastName = lastNameController.text.trim();
      username = usernameController.text.trim();
      dateOfBirth = dobController.text;
      isEditing = false;
    });

    final isoDOB = _parseToISODate(dateOfBirth);

    final success = await ProfileEditService().updateProfile(
      username: username,
      firstName: firstName,
      lastName: lastName,
      dob: isoDOB,
    );

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  void cancelEdits() {
    setState(() {
      firstNameController.text = firstName;
      lastNameController.text = lastName;
      dobController.text = dateOfBirth;
      isEditing = false;
    });
  }
  String _formatIncomingDOB(String dob) {
    try {
      final parsed = DateTime.parse(dob);
      return DateFormat('dd MMM yyyy').format(parsed);
    } catch (_) {
      return dob; 
    }
  }


  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate =
        DateTime.tryParse(_parseToISODate(dobController.text)) ?? DateTime(1990, 1, 1);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      String formatted = DateFormat('dd MMM yyyy').format(picked);
      setState(() {
        dobController.text = formatted;
      });
    }
  }

  String _parseToISODate(String value) {
    try {
      final parsed = DateFormat('dd MMM yyyy').parse(value);
      return DateFormat('yyyy-MM-dd').format(parsed);
    } catch (_) {
      return DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCF2),
      body: Stack(
        children: [
          Container(
            height: 250,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(backgroundImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Text(
                            'Profile',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 55),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 70, bottom: 30, left: 20, right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Column(
                                  children: [
                                    Text(
                                      username,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      accountType,
                                      style: const TextStyle(
                                        color: Colors.amber,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Lvl. $level',
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Personal Details",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (!isEditing)
                                    ElevatedButton.icon(
                                      onPressed: startEditing,
                                      icon: const Icon(Icons.edit, size: 16),
                                      label: const Text("Edit"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.amber,
                                        foregroundColor: Colors.black,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 12),
                                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              dataItem("First Name", isEditing ? buildField(firstNameController) : firstName),
                              dataItem("Last Name", isEditing ? buildField(lastNameController) : lastName),
                              dataItem("Username", isEditing ? buildField(usernameController) : username),
                              dataItem("Date of Birth", isEditing ? buildDOBField(context, dobController) : _formatIncomingDOB(dateOfBirth)),
                              dataItem("Email", email, isGrey: true),
                              const SizedBox(height: 20),
                              const Text(
                                "Account Details",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              dataItem("Level", level, isGrey: true),
                              dataItem("Account", accountType, isGrey: true),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipOval(
                            child: Image.asset(
                              backgroundImage,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          CircleAvatar(
                            radius: 54,
                            backgroundImage: AssetImage(profileImage),
                            backgroundColor: Colors.transparent,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isEditing)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: saveEdits,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Save"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: cancelEdits,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0C1A63),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget dataItem(String label, dynamic value, {bool isGrey = false, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          value is String
              ? Text(
                  value,
                  style: TextStyle(
                    fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                    color: isGrey ? Colors.grey : Colors.black,
                  ),
                )
              : SizedBox(width: 180, child: value),
        ],
      ),
    );
  }

  Widget buildField(TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: 14),
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
      ),
    );
  }

  Widget buildDOBField(BuildContext context, TextEditingController controller) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: TextField(
          controller: controller,
          readOnly: true,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            suffixIcon: Icon(Icons.calendar_today, size: 18, color: Colors.grey[700]),
          ),
        ),
      ),
    );
  }
}