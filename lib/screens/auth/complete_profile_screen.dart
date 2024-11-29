// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class CompleteProfileScreen extends ConsumerStatefulWidget {
//   final Map<String, dynamic> basicInfo; // Passed data from previous screen

//   const CompleteProfileScreen({super.key, required this.basicInfo});

//   @override
//   ConsumerState<CompleteProfileScreen> createState() =>
//       _CompleteProfileScreenState();
// }

// class _CompleteProfileScreenState extends ConsumerState<CompleteProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _expertiseController = TextEditingController();
//   String? _selectedAccountType;
//   bool _isUsernameValid = true;

//   // Real-time username validation
//   Future<void> _checkUsernameAvailability(String username) async {
//     final querySnapshot = await FirebaseFirestore.instance
//         .collection('users')
//         .where('username', isEqualTo: username)
//         .get();

//     setState(() {
//       _isUsernameValid = querySnapshot.docs.isEmpty;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text("Complete Your Profile"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const SizedBox(height: 20),

//               // Username Field
//               TextFormField(
//                 controller: _usernameController,
//                 decoration: InputDecoration(
//                   labelText: "Username (Optional)",
//                   filled: true,
//                   fillColor: const Color(0xFFF5F5F5),
//                   border: const OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(8)),
//                   ),
//                   suffixIcon: _isUsernameValid
//                       ? const Icon(Icons.check, color: Colors.green)
//                       : const Icon(Icons.close, color: Colors.red),
//                 ),
//                 onChanged: _checkUsernameAvailability,
//               ),
//               if (!_isUsernameValid)
//                 const Text(
//                   'Username is already taken',
//                   style: TextStyle(color: Colors.red),
//                 ),
//               const SizedBox(height: 20),

//               // Title Field
//               TextFormField(
//                 controller: _titleController,
//                 decoration: const InputDecoration(
//                   labelText: "Title",
//                   filled: true,
//                   fillColor: Color(0xFFF5F5F5),
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // Expertise Field
//               TextFormField(
//                 controller: _expertiseController,
//                 decoration: const InputDecoration(
//                   labelText: "Expertise",
//                   filled: true,
//                   fillColor: Color(0xFFF5F5F5),
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // Account Type Dropdown
//               DropdownButtonFormField<String>(
//                 value: _selectedAccountType,
//                 items: const [
//                   DropdownMenuItem(
//                     value: "Individual",
//                     child: Text("Individual"),
//                   ),
//                   DropdownMenuItem(
//                     value: "Business",
//                     child: Text("Business"),
//                   ),
//                 ],
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedAccountType = value;
//                   });
//                 },
//                 decoration: const InputDecoration(
//                   labelText: "Account Type",
//                   filled: true,
//                   fillColor: Color(0xFFF5F5F5),
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 30),

//               // Submit Button
//               ElevatedButton(
//                 onPressed: () async {
//                   if (_formKey.currentState!.validate() && _isUsernameValid) {
//                     try {
//                       // Save to Firestore
//                       await FirebaseFirestore.instance
//                           .collection('users')
//                           .doc(widget.basicInfo['uid'])
//                           .set({
//                         'firstName': widget.basicInfo['firstName'],
//                         'lastName': widget.basicInfo['lastName'],
//                         'email': widget.basicInfo['email'],
//                         'username': _usernameController.text,
//                         'title': _titleController.text,
//                         'expertise': _expertiseController.text,
//                         'accountType': _selectedAccountType,
//                         'createdAt': DateTime.now().toIso8601String(),
//                       });

//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Profile completed!')),
//                       );

//                       // Navigate to home screen
//                       context.go('/home');
//                     } catch (e) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Error: ${e.toString()}')),
//                       );
//                     }
//                   }
//                 },
//                 child: const Text("Submit"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_providers.dart';
import './widgets/block_button.dart';

class CompleteProfileScreen extends ConsumerStatefulWidget {
  final String userId; // Pass the user's UID from the previous screen

  const CompleteProfileScreen({super.key, required this.userId});

  @override
  ConsumerState<CompleteProfileScreen> createState() =>
      _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends ConsumerState<CompleteProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _expertiseController = TextEditingController();
  String? _selectedAccountType;

  bool _isCheckingUsername = false;
  bool _isUsernameValid = false;

  final List<String> _accountTypes = ['Standard', 'Premium', 'Business'];

  // Real-time username validation
  Future<void> _validateUsername() async {
    final authService = ref.read(authServiceProvider);

    setState(() {
      _isCheckingUsername = true;
    });

    bool isAvailable = await authService.isUsernameAvailable(
      _usernameController.text.trim(),
    );

    setState(() {
      _isCheckingUsername = false;
      _isUsernameValid = isAvailable;
    });
  }

  // Submit user profile
  Future<void> _submitProfile() async {
    final authService = ref.read(authServiceProvider);

    try {
      await authService.completeUserProfile(
        uid: widget.userId,
        username: _usernameController.text.trim(),
        title: _titleController.text.trim(),
        expertise: _expertiseController.text.trim(),
        accountType: _selectedAccountType,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );

      context.replace('/sign-in'); // Navigate to home screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
          "Error: $e",
          style: const TextStyle(
            color: Colors.white,
            backgroundColor: Colors.redAccent,
          ),
        )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Image(
            image: AssetImage("assets/images/onboard/bg.png"),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(28, 26, 74, 1),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      "Complete Your Profile",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1B1949),
                          ),
                    ),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: () {},
                      child: const CircleAvatar(
                        radius: 40,
                        backgroundColor: Color.fromARGB(255, 235, 233, 233),
                        child: Icon(
                          Icons.person_add,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    TextField(
                      controller: _usernameController,
                      onChanged: (value) => _validateUsername(),
                      decoration: InputDecoration(
                        labelText: "Username (Optional)",
                        suffixIcon: _isCheckingUsername
                            ? const CircularProgressIndicator()
                            : Icon(
                                _isUsernameValid
                                    ? Icons.check_circle
                                    : Icons.error_outline,
                                color: _isUsernameValid
                                    ? Colors.green
                                    : Colors.redAccent,
                              ),
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: "Title",
                        filled: true,
                        fillColor: Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _expertiseController,
                      decoration: const InputDecoration(
                        labelText: "Expertise",
                        filled: true,
                        fillColor: Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      value: _selectedAccountType,
                      hint: const Text("Select Account Type"),
                      items: _accountTypes.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedAccountType = value;
                        });
                      },
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    BlockButton(
                      onPressed: _submitProfile,
                      text: 'Submit',
                    ),
                    const SizedBox(
                      height: 70,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
