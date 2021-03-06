import 'package:flutter/material.dart';
import 'package:nubank_clone/pages/home/widget/bottom_menu.dart';
import 'package:nubank_clone/pages/home/widget/item_menu_bottom.dart';
import 'package:nubank_clone/pages/home/widget/menu_app.dart';
import 'package:nubank_clone/pages/home/widget/my_app_bar.dart';
import 'package:nubank_clone/pages/home/widget/my_dots_app.dart';
import 'package:nubank_clone/pages/home/widget/page_view_app.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool _showMenu;
  late int _currentIndex;
  late double _yPosition;

  @override
  void initState() {
    super.initState();
    _showMenu = false;
    _currentIndex = 0;
    _yPosition = 0;
  }

  @override
  Widget build(BuildContext context) {
    double _screenHeigth = MediaQuery.of(context).size.height;
    if (_yPosition == 0) {
      _yPosition = MediaQuery.of(context).size.height * .24;
    }
    return Scaffold(
      backgroundColor: Colors.purple[800],
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          MyAppBar(
            showMenu: _showMenu,
            onTap: () {
              setState(() {
                _showMenu = !_showMenu;
                _yPosition =
                    _showMenu ? _screenHeigth * .85 : _screenHeigth * .24;
              });
            },
          ),
          MenuApp(
            top: _screenHeigth * 0.22,
            showMenu: _showMenu,
          ),
          BottomMenu(showMenu: _showMenu),
          PageViewApp(
            showMenu: _showMenu,
            top: _yPosition,
            onPanUpdate: (details) {
              double positionBottomLimit = _screenHeigth * .85;
              double positionTopLimit = _screenHeigth * .24;
              double midlePosition = positionBottomLimit - positionTopLimit;
              midlePosition = midlePosition / 2;
              setState(() {
                _yPosition += details.delta.dy;

                _yPosition = _yPosition < positionTopLimit
                    ? positionTopLimit
                    : _yPosition;

                _yPosition = _yPosition > positionBottomLimit
                    ? positionBottomLimit
                    : _yPosition;

                if (_yPosition != positionBottomLimit &&
                    details.delta.dy > 0 &&
                    _yPosition > positionTopLimit + midlePosition - 50) {
                  _yPosition = positionBottomLimit;
                }

                if (_yPosition != positionTopLimit &&
                    details.delta.dy < 0 &&
                    _yPosition < positionBottomLimit - midlePosition) {
                  _yPosition = positionTopLimit;
                  // ? positionTopLimit
                  // : _yPosition;
                }

                if (_yPosition == positionBottomLimit) {
                  _showMenu = true;
                } else if (_yPosition == positionTopLimit) {
                  _showMenu = false;
                }
              });
            },
            onChange: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          MyDotApp(
            showMenu: _showMenu,
            currentIndex: _currentIndex,
            top: _screenHeigth * 0.70,
          ),
        ],
      ),
    );
  }
}
