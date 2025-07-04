//implementazione dei pacchetti necessari per la schermata di introduzione
import 'package:app/presentation/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
const Color deepPurple = Color(0xFF673AB7); // Colore viola scuro per lo sfondo della pagina
const Color purple = Color(0xFF9C27B0); // Colore viola per lo sfondo del pulsante
const Color white = Color(0xFFFFFFFF); // Colore bianco per il testo del pulsante

const kSpaceBeetwen = SizedBox(height: 24); // Spazio tra gli elementi della pagina

class IntroductionScreens extends StatelessWidget {
  const IntroductionScreens({super.key});

  @override
  Widget build(BuildContext context) {
    //dichiarazione delle PageViewModel
    final List<PageViewModel> pages = [
      //pagina iniziale della schermata di introduzione
      PageViewModel(
        title: "Welcome to Mufant",
        body: "Stay connected to geek communities and events",
        image: Image.asset('assets/images/robot1.png', width: 250, height: 250),
        decoration: const PageDecoration(
          pageColor: Colors.deepPurple // Colore di sfondo della pagina
        ),
      ),

      //seconda pagina della schermata di introduzione
      PageViewModel(
        title: "Buy Your Ticket in a click",
        body: "Fast, safe, and fully digital",
        image: Image.asset('assets/images/robot2.png', width: 250, height: 250),
        decoration: const PageDecoration(
          pageColor: Colors.deepPurple // Colore di sfondo della pagina
        ),
      ),

 //pagina finale della schermata di introduzione
      PageViewModel(
        title: "The Future is in your hands. Join us today", //titolo della terza pagina
        //uso di bodyWidget per aggiungere anche il link a "Sign In"
        bodyWidget: Column(
          children: [
            const Text(
              "Embrace innovation and be part of the change", //testo della terza pagina
              style: TextStyle(color: white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            kSpaceBeetwen, //spazio tra testo e bottone
            TextButton(
              onPressed: () {
                //navigazione alla pagina di login se l’utente ha già un account
                Navigator.of(context).push(
                  //TODO
                  MaterialPageRoute(builder: (_) => HomePage()), //naviga alla pagina di Sign In
                );
              },
              child: const Text(
                "Already have an account? Sign In", //testo del bottone per il login
                style: TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.underline, //sottolineatura del testo
                ),
              ),
            ),
          ],
        ),
        image: Image.asset('assets/images/robot3.png', width: 250, height: 250), //immagine della terza pagina
        decoration: const PageDecoration(
          pageColor: Colors.deepPurple // Colore di sfondo della pagina
        ),
      ),
    ];

    // Creazione della schermata di introduzione
    return IntroductionScreen(
      pages: pages, // Lista delle pagine da visualizzare
      next: const Text("Next"), // Testo del pulsante per la pagina successiva
      done: const Text("Sign up"), // Testo del pulsante per il sign up
      onDone: () {
        //evento: quando l’utente completa la schermata di introduzione
        //navigazione alla pagina di registrazione
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            //TODO
            builder: (_) => const HomePage()), //naviga alla pagina di Sign Up
        );
      },
      baseBtnStyle: TextButton.styleFrom(
        backgroundColor: Colors.purple, // Colore di sfondo del pulsante
        foregroundColor: Colors.white, // Colore del testo del pulsante
      ),
    );
  }
}

//possibilità che introduction_screens compaia solo una volta
//TODO