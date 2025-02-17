import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://api.frankfurter.app';

  // güncel döviz kurlarını al
  static Future<Map<String, double>> fetchExchangeRates(String baseCurrency) async {
    final url = Uri.parse('$baseUrl/latest?from=$baseCurrency');
    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);

      if (data.containsKey('rates')) {
        Map<String, double> rates = Map<String, double>.from(data['rates']);
        return rates;
      } else {
        throw Exception("Döviz kurları alınamadı.");
      }
    } catch (e) {
      throw Exception("Bağlantı hatası: $e");
    }
  }

  // grafik için 30 günlük döviz verilerini al
  static Future<Map<String, double>> fetchHistoricalRates(String baseCurrency, String targetCurrency) async {
    DateTime today = DateTime.now();
    DateTime pastDate = today.subtract(const Duration(days: 30));
    
    String startDate = "${pastDate.year}-${pastDate.month.toString().padLeft(2, '0')}-${pastDate.day.toString().padLeft(2, '0')}";
    String endDate = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    final url = Uri.parse('$baseUrl/$startDate..$endDate?from=$baseCurrency&to=$targetCurrency');
    
    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);

      if (data.containsKey('rates')) {
        Map<String, double> historicalData = {};
        data['rates'].forEach((date, rate) {
          historicalData[date] = (rate[targetCurrency] as num).toDouble();
        });
        return historicalData;
      } else {
        throw Exception("Tarihsel veriler alınamadı.");
      }
    } catch (e) {
      throw Exception("Bağlantı hatası: $e");
    }
  }
}
