// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:vms/widgets/bottom_nav_bar/controller/nav_bar_controller.dart';

// class NavBarButton extends StatelessWidget {
//   final IconData icon;
//   final int index;
//   final String label;
//   const NavBarButton({
//     super.key,
//     required this.icon,
//     required this.index,
//     required this.label,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final NavController navController = Get.put(NavController());
//     const Color primaryGreen = Color(0xff33CC99);
//     return InkWell(
//       onTap: () {
//         navController.selectedIndex.value = index;
//       },
//       child: Obx(
//         () => AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           curve: Curves.easeInBack,
//           width: 78,
//           padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//           decoration: BoxDecoration(
//             color:
//                 navController.selectedIndex.value == index
//                     ? primaryGreen
//                     : Colors.transparent,
//             borderRadius: BorderRadius.circular(40),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(
//                 icon,
//                 color:
//                     navController.selectedIndex.value == index
//                         ? Colors.white
//                         : Colors.grey,
//               ),
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w500,
//                   color:
//                       navController.selectedIndex.value == index
//                           ? Colors.white
//                           : Colors.grey,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vms/providers/nav_provider.dart';

class NavBarButton extends StatelessWidget {
  final IconData icon;
  final int index;
  final String label;

  const NavBarButton({
    super.key,
    required this.icon,
    required this.index,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavProvider>(context);
    const Color primaryGreen = Color(0xff33CC99);
    final isSelected = navProvider.selectedIndex == index;

    return InkWell(
      onTap: () => navProvider.updateIndex(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInBack,
        width: 78,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        decoration: BoxDecoration(
          color: isSelected ? primaryGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.grey),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
