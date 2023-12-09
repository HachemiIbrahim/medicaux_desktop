import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _username = "";
  var _password = "";
  final _formKey = GlobalKey<FormState>();

  void _submit() {
    final _isValid = _formKey.currentState!.validate();

    if (_isValid) {
      _formKey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withAlpha(40)
                  ],
                ),
              ),
              child: Row(
                children: [
                  Column(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        margin: const EdgeInsets.only(top: 50),
                        child: Image.asset('assets/images/logo.png'),
                      ),
                      const SizedBox(height: 150),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Container(
                              width: 250,
                              margin: const EdgeInsets.only(left: 100),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    label: Text("Username"),
                                    labelStyle: TextStyle(color: Colors.white)),
                                autocorrect: false,
                                keyboardType: TextInputType.name,
                                textCapitalization: TextCapitalization.none,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "enter a valide username";
                                  }
                                  return null;
                                },
                                onSaved: (newValue) => _username = newValue!,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: 250,
                              margin: const EdgeInsets.only(left: 100),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  label: Text("Password"),
                                  labelStyle: TextStyle(color: Colors.white),
                                ),
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "enter a valide password";
                                  }
                                  return null;
                                },
                                onSaved: (newValue) => _password = newValue!,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10, left: 280),
                        child: ElevatedButton(
                          onPressed: () {
                            _submit();
                          },
                          child: const Text("Login"),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(width: 80),
                  Container(
                    alignment: Alignment.centerRight,
                    height: constraints.maxHeight * 0.7,
                    width: constraints.maxWidth * 0.6,
                    padding: const EdgeInsets.all(20),
                    child: Image.asset("assets/images/login_picture.png"),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
