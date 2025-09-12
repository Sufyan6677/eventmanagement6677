import 'package:eventmanagement/widgets/textwidgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class LandingPage extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const LandingPage({super.key, required this.navigationShell});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final List<int> _tabHistory = [0]; // keep track of visited tabs

  void _changeTab(int index) {
    if (index != widget.navigationShell.currentIndex) {
      _tabHistory.add(index);
    }

    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
    setState(() {});
  }

  Future<bool> _onWillPop() async {
    if (_tabHistory.length > 1) {
      // remove current tab
      _tabHistory.removeLast();
      int previousIndex = _tabHistory.last;

      widget.navigationShell.goBranch(previousIndex);
      setState(() {});
      return false; // don’t exit app
    }
    return true; // exit app only if no history left
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: widget.navigationShell, // active branch content

        bottomNavigationBar: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: SalomonBottomBar(
            currentIndex: widget.navigationShell.currentIndex,
            onTap: _changeTab,
            items: [
              SalomonBottomBarItem(
                icon: const Icon(Icons.home),
                title: const GoogleText("Home"),
                unselectedColor: Colors.amber,
                selectedColor: Colors.amber,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.create),
                title: const GoogleText("Create Event"),
                unselectedColor: Colors.amber,
                selectedColor: Colors.amber,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.chat),
                title: const GoogleText("Messages"),
                unselectedColor: Colors.amber,
                selectedColor: Colors.amber,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.person),
                title: const GoogleText("Profile"),
                unselectedColor: Colors.amber,
                selectedColor: Colors.amber,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
