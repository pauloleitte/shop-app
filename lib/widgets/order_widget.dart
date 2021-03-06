import 'package:flutter/material.dart';
import 'package:shop_app/models/orders.dart';
import 'package:intl/intl.dart';

class OrderWidget extends StatefulWidget {
  final Order order;

  OrderWidget(this.order);

  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('R\$ ${widget.order.total.toStringAsFixed(2)}'),
              subtitle: Text(
                  DateFormat('dd/MM/yyyy HH:MM').format(widget.order.date)),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            if (_expanded)
              Container(
                height: (widget.order.products.length * 25.0) + 10,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                child: ListView(
                  children: widget.order.products.map((product) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          product.title,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${product.quantity}x R\$ ${product.price.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        )
                      ],
                    );
                  }).toList(),
                ),
              )
          ],
        ));
  }
}
