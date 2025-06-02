import 'package:flutter/material.dart';
import 'ListSanpham.dart';
import 'chat_screen.dart';
import 'CartScreen.dart';
import 'Trangchu.dart';

class Layout_moi extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Trangthai_layout_moi();
  }
}

class Trangthai_layout_moi extends State<Layout_moi> {
  final List<Widget> _pages = [Trangchu(), ListSanpham(), CartScreen()];

  int _trangduocchon = 0;
  void ChonTrang(int index) {
    setState(() {
      _trangduocchon = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Logo truong')),

      /*Menu phia duoi*/
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
        currentIndex: _trangduocchon,
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
                title: Text('Products'),
                onTap: () {
                  setState(() {
                    _trangduocchon = 0;
                  });
                }

                //ChonTrang(1),
                ),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text('Chat'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(),
                    ));
              },
            ),
          ],
        ),
      ),
      body: _pages[_trangduocchon],
    );
  }
}
