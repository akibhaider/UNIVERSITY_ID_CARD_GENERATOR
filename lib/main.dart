import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IUT ID Card',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const CreateIDPage(),
    );
  }
}

class CreateIDPage extends StatefulWidget {
  const CreateIDPage({super.key});

  @override
  State<CreateIDPage> createState() => _CreateIDPageState();
}

class _CreateIDPageState extends State<CreateIDPage> {
  final nameController = TextEditingController();
  final idController = TextEditingController();
  File? profileImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
      });
    }
  }

  void goToCard() {
    if (nameController.text.isEmpty || idController.text.isEmpty || profileImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select an image')),
      );
      return;
    }
    if (idController.text.length != 9) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student ID must be 9 digits')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IDCardPage(
          name: nameController.text,
          studentId: idController.text,
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
            const SizedBox(height: 8)
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

class IDCardPage extends StatefulWidget {
  final String name;
  final String studentId;
  final File image;

  const IDCardPage({
    super.key,
    required this.name,
    required this.studentId,
    required this.image,
  });

  @override
  State<IDCardPage> createState() => _IDCardPageState();
}

class _IDCardPageState extends State<IDCardPage> {
  int currentFontIndex = 0;
  int currentColorIndex = 0;

  // List of 7 different fonts
  final List<Map<String, dynamic>> fonts = [
    {'name': 'Roboto', 'style': GoogleFonts.roboto()},
    {'name': 'Poppins', 'style': GoogleFonts.poppins()},
    {'name': 'Montserrat', 'style': GoogleFonts.montserrat()},
    {'name': 'Open Sans', 'style': GoogleFonts.openSans()},
    {'name': 'Lato', 'style': GoogleFonts.lato()},
    {'name': 'Raleway', 'style': GoogleFonts.raleway()},
    {'name': 'Ubuntu', 'style': GoogleFonts.ubuntu()},
  ];

  // List of 7 light shaded colors
  final List<Map<String, dynamic>> cardColors = [
    {'name': 'White', 'color': Colors.white},
    {'name': 'Beige', 'color': Color(0xFFF5F5DC)},
    {'name': 'Pearl', 'color': Color(0xFFFAF9F6)},
    {'name': 'Ivory', 'color': Color(0xFFFFFFF0)},
    {'name': 'Cream', 'color': Color(0xFFFFFDD0)},
    {'name': 'Eggshell', 'color': Color(0xFFF0EAD6)},
    {'name': 'Vanilla', 'color': Color(0xFFF3E5AB)},
  ];

  void changeFont() {
    setState(() {
      currentFontIndex = (currentFontIndex + 1) % fonts.length;
    });
  }

  void changeCardColor() {
    setState(() {
      currentColorIndex = (currentColorIndex + 1) % cardColors.length;
    });
  }

  Map<String, dynamic> getDeptInfo(String id) {
    final code = id[4];
    switch (code) {
      case '4':
        return {'dept': 'CSE', 'program': 'B.Sc. in CSE', 'color': Colors.blueAccent};
      case '2':
        return {'dept': 'EEE', 'program': 'B.Sc. in EEE', 'color': Colors.yellow};
      case '1':
        return {'dept': 'MPE', 'program': 'B.Sc. in MPE', 'color': Colors.redAccent};
      case '5':
        return {'dept': 'CEE', 'program': 'B.Sc. in CEE', 'color': Colors.greenAccent};
      case '6':
        return {'dept': 'BTM', 'program': 'B.Sc. in BTM', 'color': Colors.purpleAccent};
      default:
        return {'dept': 'Unknown', 'program': 'Unknown', 'color': Colors.grey};
    }
  }

  @override
  Widget build(BuildContext context) {
    final info = getDeptInfo(widget.studentId);
    const darkGreen = Color(0xFF06402B);
    final dynamicColorDeptwise = info['color'] as Color;
    final currentFont = fonts[currentFontIndex]['style'] as TextStyle;
    final currentCardColor = cardColors[currentColorIndex]['color'] as Color;

    return Scaffold(
      backgroundColor: dynamicColorDeptwise,
      appBar: AppBar(
        title: const Text('ID Card'),
        backgroundColor: darkGreen,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          width: 380,
          margin: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 15,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Main card container
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Green header section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 12, bottom: 70),
                    decoration: const BoxDecoration(
                      color: darkGreen,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Logo placeholder
                        Container(
                          height: 70,
                          width: 70,
                          decoration: const BoxDecoration(
                            color: darkGreen,
                          ),
                          child: Image.asset('assets/images/iut_logo.png', fit: BoxFit.contain),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'ISLAMIC UNIVERSITY OF TECHNOLOGY',
                          textAlign: TextAlign.center,
                          style: currentFont.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // White content section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 85, 20, 0),
                    decoration: BoxDecoration(
                      color: currentCardColor,
                    ),
                    child: Column(
                      children: [
                        // Student ID Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.vpn_key, size: 18, color: Colors.black87),
                            const SizedBox(width: 6),
                            Text(
                              'Student ID',
                              style: currentFont.copyWith(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: dynamicColorDeptwise,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                widget.studentId,
                                style: currentFont.copyWith(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Student Name
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.person, size: 18, color: Colors.black87),
                            const SizedBox(width: 6),
                            Text(
                              'Student Name',
                              style: currentFont.copyWith(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          widget.name.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: currentFont.copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Program
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.school, size: 18, color: Colors.black87),
                            const SizedBox(width: 6),
                            Text(
                              'Program ',
                              style: currentFont.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              info['program'],
                              style: currentFont.copyWith(fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Department
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.apartment, size: 18, color: Colors.black87),
                            const SizedBox(width: 6),
                            Text(
                              'Department ',
                              style: currentFont.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              info['dept'],
                              style: currentFont.copyWith(fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Location
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.location_on, size: 18, color: Colors.black87),
                            const SizedBox(width: 6),
                            Text(
                              'Bangladesh',
                              style: currentFont.copyWith(fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),

                  // Green footer section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(
                      color: darkGreen,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Text(
                      'A subsidiary organ of OIC',
                      textAlign: TextAlign.center,
                      style: currentFont.copyWith(
                        fontSize: 13,
                        color: Colors.white70,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),

              // Profile image positioned using Stack
              Positioned(
                top: 120,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 120,
                    height: 145,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: darkGreen, width: 5),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: Image.file(
                        widget.image,
                        width: 140,
                        height: 145,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            onPressed: changeCardColor,
            backgroundColor: darkGreen,
            heroTag: 'colorButton',
            icon: const Icon(Icons.palette, color: Colors.white),
            label: Text(
              cardColors[currentColorIndex]['name'],
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            onPressed: changeFont,
            backgroundColor: darkGreen,
            heroTag: 'fontButton',
            icon: const Icon(Icons.font_download, color: Colors.white),
            label: Text(
              fonts[currentFontIndex]['name'],
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}