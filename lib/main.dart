import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ID Card Generator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const InputPage(),
    );
  }
}

class InputPage extends StatefulWidget {
  const InputPage({super.key});
  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final nameController = TextEditingController();
  final idController = TextEditingController();
  File? profileImage;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => profileImage = File(pickedFile.path));
    }
  }

  void goToCard() {
    final id = idController.text;
    if (nameController.text.isEmpty ||
        id.length != 9 ||
        int.tryParse(id) == null ||
        !['1', '2', '4', '5', '6'].contains(id[4]) ||
        profileImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Enter valid details:\n- Name required\n- Student ID must be 9 digits, numbers only\n- 5th digit must be one of 1,2,4,5,6\n- Profile photo required')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IDCardPage(
          name: nameController.text,
          studentId: id,
          image: profileImage!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create ID Card')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Student Name'),
          ),
          TextField(
            controller: idController,
            decoration: const InputDecoration(labelText: 'Student ID (9 digits)'),
            maxLength: 9,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: pickImage,
            child: const Text('Pick Profile Photo'),
          ),
          if (profileImage != null) ...[
            const SizedBox(height: 10),
            Image.file(profileImage!, height: 90),
          ],
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: goToCard,
            child: const Text('Generate ID Card'),
          ),
        ],
      ),
    );
  }
}

class IDCardPage extends StatelessWidget {
  final String name;
  final String studentId;
  final File image;

  const IDCardPage(
      {super.key, required this.name, required this.studentId, required this.image});

  Map<String, dynamic> getDeptInfo(String id) {
    final code = id[4];
    switch (code) {
      case '4':
        return {'dept': 'CSE', 'color': Colors.blue, 'program': 'B.Sc. in CSE'};
      case '2':
        return {'dept': 'EEE', 'color': Colors.yellow, 'program': 'B.Sc. in EEE'};
      case '1':
        return {'dept': 'MPE', 'color': Colors.red, 'program': 'B.Sc. in MPE'};
      case '5':
        return {'dept': 'CEE', 'color': Colors.green, 'program': 'B.Sc. in CEE'};
      case '6':
        return {'dept': 'BTM', 'color': Colors.purple, 'program': 'B.Sc. in BTM'};
      default:
        return {'dept': 'Unknown', 'color': Colors.grey, 'program': 'Unknown'};
    }
  }

  @override
  Widget build(BuildContext context) {
    final info = getDeptInfo(studentId);

    return Scaffold(
      appBar: AppBar(title: const Text('ID Card')),
      body: Center(
        child: Container(
          width: 340,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 3),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/iut_logo.png', height: 52),
              const SizedBox(height: 8),
              const Text('ISLAMIC UNIVERSITY OF TECHNOLOGY',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                width: 120,
                height: 140,
                decoration: BoxDecoration(
                  color: info['color'],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(image, width: 90, height: 100, fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Icon(Icons.vpn_key, size: 18),
                  const SizedBox(width: 6),
                  const Text('Student ID', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(studentId, style: const TextStyle(color: Colors.white, fontSize: 18)),
              ),
              Row(
                children: [
                  const Icon(Icons.person, size: 18),
                  const SizedBox(width: 6),
                  const Text('Student Name', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.school, size: 18),
                  const SizedBox(width: 6),
                  const Text('Program ', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(info['program']),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.apartment, size: 18),
                  const SizedBox(width: 6),
                  const Text('Department ', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(info['dept']),
                ],
              ),
              Row(
                children: const [
                  Icon(Icons.location_on, size: 18),
                  SizedBox(width: 6),
                  Text('Bangladesh'),
                ],
              ),
              const SizedBox(height: 6),
              const Text('A subsidiary organ of OIC', style: TextStyle(fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }
}
