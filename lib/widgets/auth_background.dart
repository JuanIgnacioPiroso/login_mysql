import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {

  final Widget child;

  const AuthBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Container(

      // color: Colors.red,
      width: double.infinity,
      height: double.infinity,
      child: Stack(

        children: [

          const BackgroundImage(),

          // const _HeaderIcon(),

          child,



        ],
      ),


    );
  }
}

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background3.jpg'),
          fit: BoxFit.cover,
        ),
      ),

    );
  }
}

// ignore: unused_element
class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top:30),
        child: const Icon(Icons.person_pin, color: Colors.white, size: 100),
      ),
    );
  }
}
