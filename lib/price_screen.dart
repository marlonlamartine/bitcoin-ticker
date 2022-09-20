import 'package:bitcoin_ticker/coin_data.dart';
import 'package:bitcoin_ticker/cryptoCard.dart';
import 'package:bitcoin_ticker/exchange_rate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  ExchangeRate exchangeRate = ExchangeRate();

  String selectedCurrency = 'USD';
  List<double> values = [];
  bool isWaiting = false;

  void updateData() async {
    isWaiting = true;
    try {
      var data = await exchangeRate.getExchangeData(selectedCurrency);
      setState(() {
        for (int i = 0; i < 3; i++) {
          values.add(data[i]["rate"]);
        }
      });
      isWaiting = false;
    } catch (e) {
      print(e);
    }
  }

  DropdownButton androidDropDown() {
    List<DropdownMenuItem<String>> dropDownItems = [];

    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        value: currency,
        child: Text(currency),
      );

      dropDownItems.add(newItem);
    }

    return DropdownButton(
      value: selectedCurrency,
      items: dropDownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
          updateData();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Widget> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {},
      children: pickerItems,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CryptoCard(
            cryptoType: 'BTC',
            selectedCurrency: selectedCurrency,
            value: isWaiting ? 0 : values[0],
          ),
          CryptoCard(
            cryptoType: 'ETH',
            selectedCurrency: selectedCurrency,
            value: isWaiting ? 0 : values[1],
          ),
          CryptoCard(
            cryptoType: 'LTC',
            selectedCurrency: selectedCurrency,
            value: isWaiting ? 0 : values[2],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropDown(),
          ),
        ],
      ),
    );
  }
}
