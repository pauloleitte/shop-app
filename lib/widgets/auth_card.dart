import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/exceptions/auth_exception.dart';
import 'package:shop_app/providers/auth_provider.dart';

enum AuthMode { Signup, Login }

class AuthCard extends StatefulWidget {
  AuthCard({Key key}) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  GlobalKey<FormState> _form = GlobalKey();
  bool _isLoading = false;
  AuthMode _authMode = AuthMode.Login;
  final _passwordController = TextEditingController();

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  Widget _buildEmail() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'E-mail',
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (!isEmail(value)) {
          return 'Informe um e-mail válido';
        }
        return null;
      },
      onSaved: (value) => _authData['email'] = value,
    );
  }

  Widget _buildPassword() {
    return TextFormField(
      maxLength: 6,
      controller: _passwordController,
      decoration: InputDecoration(labelText: 'Senha', counterText: ''),
      obscureText: true,
      validator: (value) {
        if (value.isEmpty || value.length > 6) {
          return 'Informe uma senha válida';
        }
        return null;
      },
      onSaved: (value) => _authData['password'] = value,
    );
  }

  Widget _buildConfirmPassword() {
    return TextFormField(
      maxLength: 6,
      decoration:
          InputDecoration(labelText: 'Confirmar Senha', counterText: ''),
      obscureText: true,
      validator: _authMode == AuthMode.Signup
          ? (value) {
              if (value != _passwordController.text) {
                return 'As senhas não correspondem.';
              }
              return null;
            }
          : null,
    );
  }

  Widget _buildSignUpButton() {
    return RaisedButton(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
      color: Theme.of(context).primaryColor,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onPressed: _submit,
      child: Text(_authMode == AuthMode.Login ? 'Login' : 'Registrar'),
    );
  }

  bool isEmail(String value) {
    String regex =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(regex);

    return value.isNotEmpty && regExp.hasMatch(value);
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Ocorreu um erro!'),
        content: Text(msg),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Fechar'),
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_form.currentState.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _form.currentState.save();

    AuthProvider auth = Provider.of(context, listen: false);

    try {
      if (_authMode == AuthMode.Login) {
        await auth.sign(
          _authData["email"],
          _authData["password"],
        );
      } else {
        await auth.signup(
          _authData["email"],
          _authData["password"],
        );
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog("Ocorreu um erro inesperado!");
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Container(
          padding: EdgeInsets.all(16.0),
          height: _authMode == AuthMode.Login ? 270 : 400,
          width: deviceSize.width * 0.75,
          child: Form(
            key: _form,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _buildEmail(),
                  _buildPassword(),
                  if (_authMode == AuthMode.Signup) _buildConfirmPassword(),
                  SizedBox(
                    height: 10,
                  ),
                  if (_isLoading)
                    CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ),
                  if (!_isLoading) _buildSignUpButton(),
                  FlatButton(
                    child: Text(_authMode == AuthMode.Login
                        ? 'Criar uma conta'
                        : 'Voltar'),
                    onPressed: _switchAuthMode,
                    textColor: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
          ),
        ),
        elevation: 8.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );
  }
}
