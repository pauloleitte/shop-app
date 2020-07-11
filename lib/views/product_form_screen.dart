import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/providers/product_provider.dart';

class ProductFormScreen extends StatefulWidget {
  ProductFormScreen({Key key}) : super(key: key);

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _priceFocusNode = FocusNode();
  final _decriptionFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  @override
  void initState() {
    super.initState();
    _imageFocusNode.addListener(_changeImage);
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _decriptionFocusNode.dispose();
    _imageFocusNode.removeListener(_changeImage);
    _imageFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_formData.isEmpty) {
      final product = ModalRoute.of(context).settings.arguments as Product;
      if (product != null) {
        _formData['id'] = product.id;
        _formData['title'] = product.title;
        _formData['description'] = product.description;
        _formData['price'] = product.price;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = _formData['imageUrl'];
      } else {
        _formData['price'] = '';
      }
    }
  }

  void _changeImage() {
    if (isValidImageUrl(_imageUrlController.text)) {
      setState(() {});
    }
  }

  bool isValidImageUrl(String url) {
    bool isValidProtocol = url.toLowerCase().startsWith('http://') ||
        url.toLowerCase().startsWith('https://');

    bool isValidImage = url.toLowerCase().endsWith(".png") ||
        url.toLowerCase().endsWith(".jpge") ||
        url.toLowerCase().endsWith(".jpg");

    return isValidProtocol && isValidImage;
  }

  void _saveForm() {
    bool isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    final product = Product(
        id: _formData['id'],
        title: _formData['title'],
        price: _formData['price'],
        description: _formData['description'],
        imageUrl: _formData['imageUrl']);

    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    if (_formData['id'] == null) {
      productProvider.addProduct(product);
    } else {
      productProvider.updateProduct(product);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _formData['title'] != null
            ? Text('${_formData['title']}')
            : Text('Novo Produto'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _formData['title'],
                decoration: InputDecoration(labelText: 'Título'),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return "Título não pode ser vazio";
                  }
                  if (value.trim().length < 3) {
                    return "Informe um título maior que 3 letras";
                  }
                  return null;
                },
                onSaved: (value) {
                  _formData['title'] = value;
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
              ),
              TextFormField(
                initialValue: _formData['price'].toString(),
                decoration: InputDecoration(labelText: 'Preço'),
                textInputAction: TextInputAction.next,
                focusNode: _priceFocusNode,
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return "Preço não pode ser vazio";
                  }
                  var newPrice = double.tryParse(value);

                  if (newPrice == null || newPrice <= 0) {
                    return "Informe um preço válido";
                  }
                  return null;
                },
                onSaved: (value) {
                  _formData['price'] = double.parse(value);
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_decriptionFocusNode);
                },
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              TextFormField(
                initialValue: _formData['description'],
                decoration: InputDecoration(labelText: 'Descrição'),
                maxLines: 3,
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return "Descrição não pode ser vazia";
                  }
                  if (value.trim().length < 10) {
                    return "Informe uma descrição maior que 10 letras";
                  }

                  return null;
                },
                onSaved: (value) {
                  _formData['description'] = value;
                },
                focusNode: _decriptionFocusNode,
                keyboardType: TextInputType.multiline,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: _imageUrlController,
                      decoration: InputDecoration(labelText: 'URL da Imagem'),
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return "Url da Imagem não pode ser vazia";
                        }
                        if (!isValidImageUrl(value)) {
                          return 'Informe uma URL válida';
                        }

                        return null;
                      },
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      focusNode: _imageFocusNode,
                      onSaved: (value) {
                        _formData['imageUrl'] = value;
                      },
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.only(
                      top: 8,
                      left: 10,
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    )),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Informe a Url')
                        : FittedBox(
                            child: Image.network(_imageUrlController.text),
                            fit: BoxFit.cover,
                          ),
                    alignment: Alignment.center,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
