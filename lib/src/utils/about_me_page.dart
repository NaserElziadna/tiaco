import 'package:contactus/contactus.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutMePage extends StatelessWidget {
  const AboutMePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(FontAwesomeIcons.arrowLeft)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * .05),
        child: ContactUs(
          avatarRadius: MediaQuery.of(context).size.height * .1,
          logo: const AssetImage("assets/NaserElziadna.jpg"),
          email: 'elzianda10@gmail.com',
          companyName: 'Naser Elzianda',
          phoneNumber: '+972584029927',
          dividerThickness: 2,
          website: 'https://www.nmmsoft.com',
          githubUserName: 'NaserElziadna',
          linkedinURL: 'https://www.linkedin.com/in/naser-hassan-b452411a1/',
          tagLine: 'Full Stack Developer',
          cardColor: Colors.white,
          companyColor: Colors.red,
          taglineColor: Colors.green,
          textColor: Colors.black,
        ),
      ),
    );
  }
}
