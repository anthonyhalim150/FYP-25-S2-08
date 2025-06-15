import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool isEditing = false;

  // hard coded user data, avatar and background
  String firstName = "Pittzza";
  String lastName = "Bull";
  String username = "@PitBulk101";
  String dateOfBirth = "12 May 1998";
  String email = "pitbulk@gmail.com";
  String level = "Intermediate";
  String accountType = "Premium";

  final String profileImage = "assets/avatars/free/free1.png";
  final String backgroundImage = "assets/background/bg1.jpg";

  // Controllers
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController usernameController;
  late TextEditingController dobController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: firstName);
    lastNameController = TextEditingController(text: lastName);
    usernameController = TextEditingController(text: username);
    dobController = TextEditingController(text: dateOfBirth);
    emailController = TextEditingController(text: email);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    dobController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void startEditing() {
    setState(() => isEditing = true);
  }

  void saveEdits() {
    setState(() {
      firstName = firstNameController.text;
      lastName = lastNameController.text;
      username = usernameController.text;
      dateOfBirth = dobController.text;
      email = emailController.text;
      isEditing = false;
    });
  }

  void cancelEdits() {
    setState(() {
      firstNameController.text = firstName;
      lastNameController.text = lastName;
      usernameController.text = username;
      dobController.text = dateOfBirth;
      emailController.text = email;
      isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCF2),
      body: Stack(
        children: [
          // 🏞 Background at top
          Container(
            height: 250,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(backgroundImage),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 👇 Scrollable content
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Profile title & back arrow
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
                        const SizedBox(width: 48), // Spacer to balance layout
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Avatar w/ background + card
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Card
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
                              // Centered user info
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
                                    const Text(
                                      'Premium',
                                      style: TextStyle(
                                        color: Colors.amber,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text(
                                      'Lvl. 27',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),

                              // 🧾 Personal Details + Edit button
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
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Fields
                              dataItem("First Name", isEditing ? buildField(firstNameController) : firstName),
                              dataItem("Last Name", isEditing ? buildField(lastNameController) : lastName),
                              dataItem("Username", isEditing ? buildField(usernameController) : username, isGrey: !isEditing),
                              dataItem("Date of Birth", isEditing ? buildField(dobController) : dateOfBirth),
                              dataItem("Email", isEditing ? buildField(emailController) : email),
                              const SizedBox(height: 20),

                              // 🧾 Account Section
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

                    // Avatar with circular background behind it
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

          // 💾 Save / Cancel buttons
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

  Widget dataItem(String label, dynamic value,
      {bool isGrey = false, bool isBold = false}) {
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
}