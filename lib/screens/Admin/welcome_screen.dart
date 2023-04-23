import 'package:flutter/material.dart';
import 'package:mpdam_job_finder/screens/Admin/home_screen.dart';
import 'package:mpdam_job_finder/screens/Admin/widgets/navbar_roots.dart';

class WelcomeScreenAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(height: 15),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NavBarRoots(),
                      ),
                    );
                  },
                  child: Text(
                    "SKIP",
                    style: TextStyle(
                      color: Color(0xFF4DB6AC),
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),
              Padding(
                padding: EdgeInsets.all(20),
                child: Image.asset("assets/images/recrutement.png"),
              ),
              SizedBox(height: 50),
              Text(
                "Recruits are so Simple",
                style: TextStyle(
                  color: Color(0xFF4DB6AC),
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  wordSpacing: 2,
                ),
              ),
              SizedBox(height: 15),
              Text(
                "Find The Best Talent",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Material(
                    color: Color(0xFF4DB6AC),
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: () {},
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: Color(0xFF4DB6AC),
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: () {},
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                        child: Text(
                          "sing up",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
