import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/currency_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'home_page.dart';

class ConverterPage extends ConsumerStatefulWidget {
  const ConverterPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ConverterPageState createState() => _ConverterPageState();
}

class _ConverterPageState extends ConsumerState<ConverterPage> {
  final TextEditingController _amountController = TextEditingController();
  String? _fromCurrency;
  String? _toCurrency;
  double? _convertedAmount;

  void _convertCurrency(Map<String, double> exchangeRates) {
    if (_fromCurrency != null && _toCurrency != null && _amountController.text.isNotEmpty) {
      final double amount = double.tryParse(_amountController.text) ?? 0.0;
      final double fromRate = exchangeRates[_fromCurrency] ?? 1.0;
      final double toRate = exchangeRates[_toCurrency] ?? 1.0;

      setState(() {
        _convertedAmount = (amount / fromRate) * toRate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final exchangeRates = ref.watch(exchangeRatesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Döviz Dönüştürme", style: TextStyle(color: Colors.white, fontSize: 24),),
        backgroundColor: Colors.blue.shade900,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade900, Colors.blue.shade500],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
                      ],
                    ),
                    child: exchangeRates.when(
                      data: (rates) {
                        if (_fromCurrency == null || !rates.containsKey(_fromCurrency)) {
                          _fromCurrency = rates.keys.first;
                        }
                        if (_toCurrency == null || !rates.containsKey(_toCurrency)) {
                          _toCurrency = rates.keys.last;
                        }

                        List<String> currencyList = rates.keys.toList();

                        return Column(
                          children: [
                            // tutar giriş alanı
                            Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: TextField(
                                  controller: _amountController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: "Tutarı Girin",
                                    prefixIcon: Icon(FontAwesomeIcons.moneyBillWave, color: Colors.blueAccent),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // döviz seçme alanları
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          isExpanded: true,
                                          value: _fromCurrency,
                                          onChanged: (value) => setState(() => _fromCurrency = value),
                                          items: currencyList.map((currency) {
                                            return DropdownMenuItem(
                                              value: currency,
                                              child: Text(currency, style: const TextStyle(fontSize: 16)),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // ignore: deprecated_member_use
                                const Icon(FontAwesomeIcons.exchangeAlt, size: 24, color: Colors.blueAccent),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          isExpanded: true,
                                          value: _toCurrency,
                                          onChanged: (value) => setState(() => _toCurrency = value),
                                          items: currencyList.map((currency) {
                                            return DropdownMenuItem(
                                              value: currency,
                                              child: Text(currency, style: const TextStyle(fontSize: 16)),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // dönüştürme butonu
                            ElevatedButton(
                              onPressed: () => _convertCurrency(rates),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                backgroundColor: Colors.blueAccent,
                              ),
                              child: const Text(
                                "Dönüştür",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // sonuç alanı
                            if (_convertedAmount != null)
                              Card(
                                elevation: 8,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                color: Colors.blueAccent,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      const Text(
                                        "Sonuç:",
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white70),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "${_convertedAmount?.toStringAsFixed(2)} $_toCurrency",
                                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (error, stackTrace) => const Center(
                        child: Text(
                          "Veri alınamadı!",
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
