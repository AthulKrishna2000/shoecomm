import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoecomm/controllers/size_controller.dart';

class Sizechart extends StatefulWidget {
  const Sizechart({super.key});

  @override
  State<Sizechart> createState() => _SizechartState();
}

class _SizechartState extends State<Sizechart> {
  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Consumer<SizeController>(builder: (context, sizeController, child) {
      return Row(
        children: [
          const SizedBox(
            width: 10.0,
          ),
          GestureDetector(
            onTap: () {
              sizeController.selectedSize = "5";
            },
            child: CircleAvatar(
                radius: 20,
                child: sizeController.size == "5"
                    ? const Text("5", style: TextStyle(color: Colors.black))
                    : const Text("5", style: TextStyle(color: Colors.white))),
          ),
          const SizedBox(
            width: 10.0,
          ),
          GestureDetector(
            onTap: () {
              sizeController.selectedSize = "6";
            },
            child: CircleAvatar(
                radius: 20,
                child: sizeController.size == "6"
                    ? const Text("6", style: TextStyle(color: Colors.black))
                    : const Text("6", style: TextStyle(color: Colors.white))),
          ),

          const SizedBox(
            width: 10.0,
          ),
          GestureDetector(
            onTap: () {
              sizeController.selectedSize = "7";
            },
            child: CircleAvatar(
                radius: 20,
                child: sizeController.size == "7"
                    ? const Text("7", style: TextStyle(color: Colors.black))
                    : const Text("7", style: TextStyle(color: Colors.white))),
          ),
          const SizedBox(
            width: 10.0,
          ),
          GestureDetector(
            onTap: () {
              sizeController.selectedSize = "8";
            },
            child: CircleAvatar(
                radius: 20,
                child: sizeController.size == "8"
                    ? const Text("8", style: TextStyle(color: Colors.black))
                    : const Text("8", style: TextStyle(color: Colors.white))),
          ),
          const SizedBox(
            width: 10.0,
          ),
          GestureDetector(
            onTap: () {
              sizeController.selectedSize = "9";
            },
            child: CircleAvatar(
                radius: 20,
                child: sizeController.size == "9"
                    ? const Text("9", style: TextStyle(color: Colors.black))
                    : const Text("9", style: TextStyle(color: Colors.white))),
          ),
          const SizedBox(
            width: 10.0,
          ),
          GestureDetector(
            onTap: () {
              sizeController.selectedSize = "10";
            },
            child: CircleAvatar(
                radius: 20,
                child: sizeController.size == "10"
                    ? const Text("10", style: TextStyle(color: Colors.black))
                    : const Text("10", style: TextStyle(color: Colors.white))),
          ),
          const SizedBox(
            width: 10.0,
          ),
          GestureDetector(
            onTap: () {
              sizeController.selectedSize = "11";
            },
            child: CircleAvatar(
                radius: 20,
                child: sizeController.size == "11"
                    ? const Text("11", style: TextStyle(color: Colors.black))
                    : const Text("11", style: TextStyle(color: Colors.white))),
          ),
         
        ],
      );
    });
  }
}
