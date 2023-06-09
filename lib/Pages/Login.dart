// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kirinyaga_agribusiness/Components/Utils.dart';
import 'package:kirinyaga_agribusiness/Pages/FarmerHome.dart';
import 'package:kirinyaga_agribusiness/Pages/FarmerLogin.dart';
import 'package:kirinyaga_agribusiness/Pages/FieldOfficerHome.dart';
import 'package:kirinyaga_agribusiness/Pages/Home.dart';
import 'package:kirinyaga_agribusiness/Pages/StaffLogin.dart';
import 'package:kirinyaga_agribusiness/Pages/SupervisorHome.dart';
import 'package:kirinyaga_agribusiness/main.dart';
import '../Components/FODrawer.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int _selectedItem = 0;
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(child: FODrawer()),
      body: PageView(
        onPageChanged: (index) {
          _selectedItem = index;
        },
        controller: _pageController,
        children: const [FarmerLogin(), StaffLogin()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.login_rounded), label: 'Farmer Login'),
          BottomNavigationBarItem(
              icon: Icon(Icons.login), label: 'Admin Login'),
        ],
        currentIndex: _selectedItem,
        onTap: (index) {
          setState(() {
            _selectedItem = index;
            _pageController.animateToPage(_selectedItem,
                duration: const Duration(milliseconds: 200),
                curve: Curves.linear);
          });
        },
        fixedColor: Color.fromRGBO(0, 128, 0, 1),
      ),
    );
  }
}
