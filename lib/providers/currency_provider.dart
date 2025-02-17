// ignore: depend_on_referenced_packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/currency.dart';
import '../services/currency_service.dart';

// currencyProvider: döviz kuru verisini sağlayacak FutureProvider
final currencyProvider = FutureProvider<Map<String, Currency>>((ref) async {
  final currencyService = CurrencyService();
  final data = await currencyService.getCurrencyData();
  return data;
});

// exchangeRatesProvider: döviz kuru verisini sağlayacak FutureProvider
final exchangeRatesProvider = FutureProvider<Map<String, double>>((ref) async {
  final currencyService = CurrencyService();
  final data = await currencyService.getCurrencyData();

  // döviz verilerini double türüne dönüştürme
  Map<String, double> exchangeRates = {};
  data.forEach((key, currency) {
    exchangeRates[key] = currency.rate;
  });

  return exchangeRates;
});
