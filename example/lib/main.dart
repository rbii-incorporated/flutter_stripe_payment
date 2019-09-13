import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stripe_payment/stripe_payment.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  initState() {
    super.initState();
    StripeSource.setPublishableKey("pk_test");
    StripeSource.setMerchantIdentifier("merchant.rbii.stripe-example");
  }

  Widget get _sourceAddButton {

    return Padding(padding: EdgeInsets.all(10), child: RaisedButton(
        padding: EdgeInsets.all(10),
        child: Text("Add Card"),
        onPressed: () {
          print("Source Add Ready: ${StripeSource.ready}");
          StripeSource.addSource().then((String token) {
            _printToken(token);
          });
        }
    ));
  }

  Widget get _nativePayButton {
    return Padding(padding: EdgeInsets.all(10), child: RaisedButton(
        child: Text("Pay w/ Native"),
        onPressed: () {
          print("Native Pay Ready: ${StripeSource.nativePayReady}");
          StripeSource.useNativePay().then((token) => _printToken(token));
        }
    ));
  }

  Widget get _buttonColumn => Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[_sourceAddButton, _nativePayButton]);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: new Text('Stripe Plugin Example'),
          ),
          body: _buttonColumn
      ),
    );
  }

  void _printToken(String token) {
    print("Token => $token");
  }
}