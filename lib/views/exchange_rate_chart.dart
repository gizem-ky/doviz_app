import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:fl_chart/fl_chart.dart';
import 'home_page.dart';

import '../core/network/api_service.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  String baseCurrency = "USD";
  String targetCurrency = "TRY";
  Map<String, double> historicalData = {};
  bool isLoading = false;
  String errorMessage = "";

  final List<String> currencies = ["TRY", "USD", "EUR", "GBP", "CHF", "JPY", "SAR", "AED", "RUB", "CNY"];

  @override
  void initState() {
    super.initState();
    fetchChartData();
  }

  Future<void> fetchChartData() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    try {
      Map<String, double> data = await ApiService.fetchHistoricalRates(baseCurrency, targetCurrency);
      setState(() {
        historicalData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Veri alınamadı: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Son 30 Gün Grafiği", style: TextStyle(color: Colors.white, fontSize: 24),),
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
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: baseCurrency,
                              decoration: const InputDecoration(
                                labelText: "Baz Para Birimi",
                                labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              items: currencies.map((String currency) {
                                return DropdownMenuItem<String>(
                                  value: currency,
                                  child: Text(currency, style: const TextStyle(fontSize: 16)),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    baseCurrency = value;
                                  });
                                  fetchChartData();
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: targetCurrency,
                              decoration: const InputDecoration(
                                labelText: "Hedef Para Birimi",
                                labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              items: currencies.map((String currency) {
                                return DropdownMenuItem<String>(
                                  value: currency,
                                  child: Text(currency, style: const TextStyle(fontSize: 16)),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    targetCurrency = value;
                                  });
                                  fetchChartData();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 450,
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : errorMessage.isNotEmpty
                                ? Center(child: Text(errorMessage, style: const TextStyle(fontSize: 18, color: Colors.red)))
                                : LineChart(
                                    LineChartData(
                                      gridData: const FlGridData(show: false),
                                      titlesData: FlTitlesData(
                                        leftTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 50,
                                            getTitlesWidget: (value, meta) {
                                              return Text(
                                                value.toStringAsFixed(2),
                                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                              );
                                            },
                                          ),
                                        ),
                                        rightTitles: const AxisTitles(
                                          sideTitles: SideTitles(showTitles: false),
                                        ),
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 40,
                                            interval: 1,
                                            getTitlesWidget: (value, meta) {
                                              int index = value.toInt();
                                              List<String> dates = historicalData.keys.toList();

                                              if (index == 0 || index == dates.length - 1 || index % (dates.length ~/ 3) == 0) {
                                                return Padding(
                                                  padding: const EdgeInsets.only(top: 10),
                                                  child: Text(
                                                    dates[index].substring(5),
                                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                                  ),
                                                );
                                              }
                                              return const Text('');
                                            },
                                          ),
                                        ),
                                      ),
                                      borderData: FlBorderData(show: true),
                                      lineBarsData: [
                                        LineChartBarData(
                                          spots: historicalData.entries.map((entry) {
                                            int index = historicalData.keys.toList().indexOf(entry.key);
                                            return FlSpot(index.toDouble(), entry.value);
                                          }).toList(),
                                          isCurved: true,
                                          color: Colors.blue,
                                          barWidth: 4,
                                          belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
                                        ),
                                      ],
                                    ),
                                  ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        "Son Güncelleme: ${historicalData.isNotEmpty ? historicalData.keys.last : "-"}",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
                      ),
                    ],
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
