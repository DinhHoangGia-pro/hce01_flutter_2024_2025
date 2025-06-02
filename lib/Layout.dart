import 'package:flutter/material.dart';

import 'ListProducts_Admin.dart';
import 'chat_screen.dart';
import 'ListSanpham.dart';
import 'CartScreen.dart';
import 'TestHashing.dart';
import 'ListProductsFirebase.dart';
import 'ListProducts_AdminFB.dart';
//import "ListProducts_AdminFB2.dart";

class Layout extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Trangthai_Layout();
  }
}

class Trangthai_Layout extends State<Layout> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    ListSanpham(),
    ListProducts_Admin(),
    CartScreen(),
    ChatScreen(),
    TestHashing(),
    ListProductsFirebase(),
    ListProducts_AdminFB()
  ];

  void ChonTrang(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Image.network(
              "https://www.kthcm.edu.vn/wp-content/uploads/2023/10/Ten-truong-do-1000x159.png"),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Products',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
          ],
          currentIndex: (_selectedIndex > 2) ? 0 : _selectedIndex,
          selectedItemColor: Color(0xffed10a2),
          onTap: ChonTrang,
        ),

        /*Menu start*/
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child:

                      // Text(
                      //   'Menu Start',
                      //   style: TextStyle(
                      //     color: Colors.white,
                      //     fontSize: 24,
                      //   ),
                      // ),
                      Image.network(
                          "https://media.istockphoto.com/id/1157149805/vi/vec-to/ng%C6%B0%E1%BB%9Di-vi%E1%BB%87t-nam-trong-trang-ph%E1%BB%A5c-d%C3%A2n-t%E1%BB%99c-v%E1%BB%9Bi-m%E1%BB%99t-l%C3%A1-c%E1%BB%9D.jpg?s=2048x2048&w=is&k=20&c=bVbvQ3Im3-Nb-E2G58eNmnBg9j04O3Xb9IcZ2aLJEv0=")),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () => ChonTrang(0),
              ),
              ListTile(
                  leading: Icon(Icons.list),
                  title: Text('Quản trị sản phẩm Firebase'),
                  onTap: () {
                    ChonTrang(6);
                  }),
              ListTile(
                  leading: Icon(Icons.list),
                  title: Text('Quản trị sản phẩm'),
                  onTap: () {
                    ChonTrang(1);
                  }

                  //ChonTrang(1),
                  ),
              ListTile(
                leading: Icon(Icons.chat),
                title: Text('Chat'),
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (_) => ChatScreen(),
                  //     ));
                  //
                  ChonTrang(3);
                },
              ),
              ListTile(
                leading: Icon(Icons.chat),
                title: Text('Test hàm băm'),
                onTap: () {
                  ChonTrang(4);
                },
              ),
              ListTile(
                leading: Icon(Icons.chat),
                title: Text('Ds sản phẩm từ Fibase'),
                onTap: () {
                  ChonTrang(5);
                },
              ),
            ],
          ),
        ),
        body: _pages[_selectedIndex]);
  }
}
