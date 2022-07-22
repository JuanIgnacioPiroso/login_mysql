import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {

  final Widget child;

  final double paddingHorizontal;
  final double paddingContainer;


  const CardContainer({Key? key, required this.child, required this.paddingHorizontal, required this.paddingContainer}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: paddingHorizontal),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(paddingContainer),
        decoration: _createCardShape(),
        child: child,
      ),
    );
  }

  BoxDecoration _createCardShape() => BoxDecoration(

    color: Colors.grey.shade300.withOpacity(0.9),
    borderRadius: BorderRadius.circular(25),
    boxShadow: const [

      BoxShadow(

        color: Colors.black12,
        blurRadius: 15,
        offset: Offset(0,5)

      )

    ]
    
  );
}