import 'package:flutter/material.dart';
import 'package:frontend_aplication/widgets/register_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "DOGGY DETECTIVE",
              style: GoogleFonts.cherryBombOne(
                fontWeight: FontWeight.bold,
                fontSize: 60.0,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/background.jpg'),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            const Expanded(child: RegisterWidget()),
          ],
        ),
      ),
    );
  }
}
