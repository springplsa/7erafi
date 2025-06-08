import 'package:flutter/material.dart';
import 'package:start_up/screens/artisan/home.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen width and height for responsive UI
    

    return Scaffold(
        backgroundColor: Colors.white, // Set background color
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center items
                children: [
              Image.asset("images/logo.png", width: 150.0), // Logo
              SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text("Recuperation de votre compte",
                          style: TextStyle(fontSize:20, fontWeight: FontWeight.bold),
                        )

                    ),
                  ),
                  SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text("Introduire votre numero de telephone ou adresse email.",
                          style: TextStyle(fontSize: 18),
                        )

                    ),
                  ),  SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Numero de telephone ou email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ), SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text("Vous allez recevoire un email ou un message sms.",
                          style: TextStyle(fontSize: 16),
                        )

                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Password()), // Navigate to Create Account
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      backgroundColor: Color(0xFFF8B3BB),  // White button
                 // Pink border
                    ),
                    child: Text(
                      "Continue",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
    ))
    );


  }
  }
class Password extends StatelessWidget {
  const Password({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white, // Set background color
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center items
              children: [
                Image.asset("images/logo.png", width: 150.0), // Logo
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text("Confirmation de votre compte",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      )

                  ),
                ),
                SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text("Nous avons vous envoye un code de confirmation.",
                        style: TextStyle(fontSize: 16),
                      )

                  )),
                  SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text("Code de Confirmation",
                          style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                        )

                    ),
                ),  SizedBox(height: 5),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Introduir le code",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PasswordRest()), // Navigate to Create Account
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    backgroundColor: Color(0xFFF8B3BB),  // White button
                   // Pink border
                  ),
                  child: Text(
                    "Continue",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                ],
            ))
    ); ;

  }
}class PasswordRest extends StatelessWidget {
  const PasswordRest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white, // Set background color
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center items
              children: [
                Image.asset("images/logo.png", width: 150.0), // Logo
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text("Reintialiser le mot de passe",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      )

                  ),
                ),
                SizedBox(height: 5),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text("Nouveau mot de passe",
                          style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                        )

                    )),
             SizedBox(height: 5),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Enterez votre nouveau mot de passe",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text("Confirmer le mot de pass",
                        style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                      )

                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Confirmez votre nouveau mot de passe",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Home(tabName: '',)), // Navigate to Create Account
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    backgroundColor: Color(0xFFF8B3BB), // White button
                   // Pink border
                  ),
                  child: Text(
                    "Continue",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ))
    ); ;
  }
}


