import'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shop_sphere/Account_screen/account_screen.dart';
import 'package:shop_sphere/Account_screen/order_screen.dart';
import 'package:shop_sphere/cart_screen/cart_screen.dart';
import 'package:shop_sphere/home/home.dart';

class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({final Key? key})
      : super(key: key);
  

  @override
  _CustomBottomBarState createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
   PersistentTabController _controller= PersistentTabController();
   bool _hideNavBar = false;



  List<Widget> _buildScreens() => [
     
    HomePage(),
    CartScreen(),
    OrderScreen(),
    AccountScreen()  
       
      ];

  List<PersistentBottomNavBarItem> _navBarsItems() => [
        PersistentBottomNavBarItem(
            icon: const Icon(Icons.home),
            inactiveIcon: const Icon(Icons.home_outlined),
            title: "Home",
            activeColorPrimary: Colors.white,
            inactiveColorPrimary: Colors.grey,
            ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.shopping_bag),
          inactiveIcon: const Icon(Icons.shopping_bag_outlined),
          title: "Cart",
          activeColorPrimary: Colors.white,
          inactiveColorPrimary: Colors.grey,
          
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.assignment),
          inactiveIcon: const Icon(Icons.assessment_outlined),
          title: "orders",
          activeColorPrimary: Colors.white,
          inactiveColorPrimary: Colors.grey,
         
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.person),
          inactiveIcon: const Icon(Icons.person_2_outlined),
          title: "Profile",
          activeColorPrimary: Colors.white,
          inactiveColorPrimary: Colors.grey,
         
        ),
       
      ];

  @override
  Widget build(final BuildContext context) => Scaffold(

      
       
        body: Stack(children: [

          

          Positioned.fill(
            child: PersistentTabView(
            context,
            controller: _controller,
            screens: _buildScreens(),
            items: _navBarsItems(),
            resizeToAvoidBottomInset: true,
            navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
                ? 0.0
                : kBottomNavigationBarHeight,
            bottomScreenMargin: 0,
            
                     
            backgroundColor: Color.fromARGB(255, 176, 5, 202),
            
            hideNavigationBar: _hideNavBar,
            decoration: const NavBarDecoration(colorBehindNavBar: Colors.indigo),
            itemAnimationProperties: const ItemAnimationProperties(
              duration: Duration(milliseconds: 400),
              curve: Curves.ease,
            ),
            screenTransitionAnimation: const ScreenTransitionAnimation(
              animateTabTransition: true,
            ),
            navBarStyle: NavBarStyle
                .style1, // Choose the nav bar style with this property
                    ),
          ),
        
       
        ],)
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('_hideNavBar', _hideNavBar));
  }
}