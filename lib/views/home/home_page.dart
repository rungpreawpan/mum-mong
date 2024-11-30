import 'package:flutter/material.dart';
import 'package:seeable/constant/value_constant.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.separated(
        itemCount: 3,
        itemBuilder: (context, index) {
          return SizedBox();
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: marginX2);
        },
      ),
    );
  }
}
