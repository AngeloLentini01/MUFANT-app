import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

//dichiarazione della PageViewModel
//pagina iniziale della schermata di introduzione
final PageViewModel firstPage = PageViewModel(
  title: "Welcome to Mufant", 
  body: "Stay connected to geek communities and events",
  image: Image.asset('assets/images/robot1',width: 100, height: 100),
  decoration: const PageDecoration(
    pageColor: Colors.deepPurple // Colore di sfondo della pagina
  ),
  footer: ElevatedButton(
    onPressed: () {
      //evento del button quando viene premuto
      //next page
    },
    child: Text("Next"),
  ), 
);

//seconda pagina della schermata di introduzione
final PageViewModel secondPage = PageViewModel(
  title: "Buy Your Ticket in a click", 
  body: "Fast, save, and fully digital",
  image: Image.asset('assets/images/robot2.png',width: 100, height: 100),
  decoration: const PageDecoration(
    pageColor: Colors.deepPurple // Colore di sfondo della pagina
  ),
  footer: ElevatedButton(
    onPressed: () {
      //evento del button quando viene premuto
      //next page
    },
    child: Text("Next"),
  ), 
);

//pagina finale della schermata di introduzione
final PageViewModel finalPage = PageViewModel(
title: "The Future is in your hands. Join us today", 
  body: "Embrance innovation and be part of the change",
  image: Image.asset('assets/images/robot3.png',width: 100, height: 100),
  decoration: const PageDecoration(
    pageColor: Colors.deepPurple // Colore di sfondo della pagina
  ),
  footer: ElevatedButton(
    onPressed: () {
      // evento del button quando viene premuto
      // Sign up
    },
    child: Text("Sign Up"),
  ), 
);