// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:vms/widgets/bottom_nav_bar/controller/nav_bar_controller.dart';
// import 'package:vms/widgets/bottom_nav_bar/presentation/widgets/nav_bar.dart';

// class VmsBottamNavBar extends StatelessWidget {
//   const VmsBottamNavBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final NavController navBarController = Get.put(NavController());
//     return Scaffold(
//       extendBody: true,
//       floatingActionButton: const CustomNavBar(),
//       floatingActionButtonLocation:
//           FloatingActionButtonLocation.miniCenterDocked,
//       floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,

//       body: Obx(
//         () => navBarController.pages[navBarController.selectedIndex.value],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vms/providers/nav_provider.dart';
import 'package:vms/widgets/bottom_nav_bar/presentation/widgets/nav_bar.dart';

class VmsBottomNavBar extends StatelessWidget {
  const VmsBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavProvider>(context);

    return Scaffold(
      extendBody: true,
      floatingActionButton: const CustomNavBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      body: navProvider.pages[navProvider.selectedIndex],
    );
  }
}
