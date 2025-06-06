import 'package:flutter/material.dart';
import 'package:pokemon/features/home/controllers/home_controller.dart';
import 'package:pokemon/features/home/controllers/home_page_repository.dart';

class CustomRefresh extends StatelessWidget {
  const CustomRefresh({
    super.key,
    required this.homePageController,
    required this.repository,
  });

  final HomePageController homePageController;
  final HomePageRepository repository;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Center(
        child: ValueListenableBuilder(
          valueListenable: homePageController.isRefreshing,
          builder: (context, value, child) {
            return homePageController.isRefreshing.value
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.greenAccent,
                    ),
                    strokeWidth: 2,
                  )
                : const SizedBox();
          },
        ),
      ),
    );
  }
}
