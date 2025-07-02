// import 'package:flutter/material.dart';
// import 'package:vms/widgets/bottom_nav_bar/presentation/widgets/nav_bar_icon_button.dart';

// class CustomNavBar extends StatelessWidget {
//   const CustomNavBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16, right: 16, left: 16),
//       padding: const EdgeInsets.all(5),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(40),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: const Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           NavBarButton(icon: Icons.home_filled, index: 0, label: "Home"),
//           NavBarButton(icon: Icons.dashboard, index: 1, label: "Dashboard"),
//           NavBarButton(icon: Icons.manage_accounts, index: 2, label: "Manage"),
//           NavBarButton(icon: Icons.person, index: 3, label: "Profile"),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:vms/widgets/bottom_nav_bar/presentation/widgets/nav_bar_icon_button.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16, right: 16, left: 16),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          NavBarButton(icon: Icons.home_filled, index: 0, label: "Home"),
          NavBarButton(icon: Icons.dashboard, index: 1, label: "Dashboard"),
          NavBarButton(icon: Icons.manage_accounts, index: 2, label: "Manage"),
          NavBarButton(icon: Icons.person, index: 3, label: "Profile"),
        ],
      ),
    );
  }
}
