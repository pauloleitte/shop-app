import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Badge extends StatelessWidget {
  final Widget child;
  final String value;
  final Color color;

  Badge({
    @required this.child,
    @required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        child,
        Positioned(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: 16,
              minWidth: 16,
            ),
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: color != null ? color : Theme.of(context).accentColor),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10),
            ),
          ),
          right: 8,
          top: 8,
        )
      ],
    );
  }
}
