import 'package:bitcoin_ticker/coin_data.dart';
import 'package:bitcoin_ticker/network.dart';

const apiKey = 'your-api-key-here';
const coinApiurl = 'https://rest.coinapi.io/v1/exchangerate';

class ExchangeRate {
  ExchangeRate();

  Future<dynamic> getExchangeData(String currency) async {
    List<dynamic> valueList = [];

    for (String cryptoType in cryptoList) {
      NetworkHelper networkHelper =
          NetworkHelper("$coinApiurl/$cryptoType/$currency?apikey=$apiKey");

      var exchangeData = await networkHelper.fetchData();
      valueList.add(exchangeData);
    }

    return valueList;
  }
}
