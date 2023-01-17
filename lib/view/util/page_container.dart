import 'package:flutter/material.dart';

import '../../model/page.dart';
import 'app_bar_content.dart';



class PageContainer extends StatefulWidget {

  List<PageModel> pages = <PageModel>[];
  var screens = [];

  PageContainer({
    Key? key,
    required this.pages,
    required this.screens,
  }) : super(key: key);

  @override
  PageContainerState createState() => PageContainerState(pages, screens);
}

class PageContainerState extends State<PageContainer> {
  List<PageModel> pages = <PageModel>[];
  var screens = [];

  static int currentIndex = 0;
  static void selectPage(BuildContext context,int index) {
    PageContainerState? stateObject = context.findAncestorStateOfType<PageContainerState>();
    stateObject?.setState((){
      currentIndex = index;
    });
  }

  PageContainerState(this.pages, this.screens);

  String getCurrentPageName() {
    return pages[currentIndex].getPageName.toString();
  }

  List<BottomNavigationBarItem> getListOfNavigationBarItems() {
    List<BottomNavigationBarItem> items = [];
    for (int i = 0; i < pages.length; i++) {
      items.add(BottomNavigationBarItem(
          icon: pages[i].getPageIcon, label: pages[i].getPageName));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(45.0),
        child: AppBarContent(),
      ),
      /*
        //https://api.flutter.dev/flutter/widgets/PreferredSize-class.html#:~:text=A%20widget%20with%20a%20preferred,their%20children%20implement%20that%20interface.
      )*/
      body: SingleChildScrollView(
        child: Column(
          children: [
            screens[currentIndex],
            const SizedBox(height: 90,),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 40,
        type: BottomNavigationBarType.fixed,
        items: getListOfNavigationBarItems().toList(),
        selectedItemColor: const Color(0xffDFDDDD),
        unselectedItemColor: const Color(0xffDFDDDD),
        showSelectedLabels: true,
        showUnselectedLabels: false,
        backgroundColor: const Color(0x5cd26666),
        currentIndex: currentIndex,
        elevation: 1.0,
        onTap: (index) {
          setState(() => currentIndex = index);
        },
      ),
    );
  }
}
