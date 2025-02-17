import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import '../models/currency.dart';

class CurrencyService {
  Future<Map<String, Currency>> getCurrencyData() async {
    const String url = 'https://api.exchangerate-api.com/v4/latest/TRY';

    // birim filtreleme
    final List<String> selectedCurrencies = ['USD', 'EUR', 'GBP', 'CHF', 'JPY', 'SAR', 'AED', 'RUB', 'CNY', 'TRY'];

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final rates = data['rates'] as Map<String, dynamic>;

        Map<String, Currency> currencies = {};

        for (String currencyCode in selectedCurrencies) {
          if (rates.containsKey(currencyCode)) {
            currencies[currencyCode] = Currency.fromJson({'rate': rates[currencyCode]}, currencyCode);
          }
        }

        return currencies;
      } else {
        throw Exception('Veri alınamadı');
      }
    } catch (e) {
      throw Exception('Bir hata oluştu: $e');
    }
  }
}
