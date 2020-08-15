import 'package:flutter/material.dart';
import 'package:shop_app/widgets/auth_card.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color.fromRGBO(0, 255, 255, 0.5),
                Color.fromRGBO(215, 255, 255, 0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),
          ),
          Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 70),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 8,
                        color: Colors.black26,
                        offset: Offset(0, 2),
                      )
                    ],
                    color: Colors.cyan.shade500,
                  ),
                  child: Text(
                    'Shop App',
                    style: TextStyle(
                      color: Theme.of(context).accentTextTheme.headline6.color,
                      fontSize: 45,
                      fontFamily: 'Anton',
                    ),
                  ),
                ),
                AuthCard(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
