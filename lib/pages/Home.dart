import 'package:flutter/material.dart';
import 'package:gestion_indumentaria/widgets/DrawerMenuLateral.dart';
import 'package:gestion_indumentaria/widgets/MenuLateral.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MenuLateral(),
      drawer: DrawerMenuLateral(),
    );
  }
}