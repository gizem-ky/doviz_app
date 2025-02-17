import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'current_exchange_rate.dart';
import 'exchange_rate_chart.dart';
import 'converter_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade900, Colors.blue.shade500],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Döviz Takip Uygulaması",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              _buildMenuButton(
                context,
                title: "Güncel Kur",
                icon: FontAwesomeIcons.chartBar,
                page: const CurrentExchangeRatePage(),
              ),
              _buildMenuButton(
                context,
                title: "Son 30 Gün Grafiği",
                icon: FontAwesomeIcons.chartLine,
                page: const ChartScreen(),
              ),
              _buildMenuButton(
                context,
                title: "Birim Değiştirme",
                // ignore: deprecated_member_use
                icon: FontAwesomeIcons.exchangeAlt,
                page: const ConverterPage(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, {required String title, required IconData icon, required Widget page}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        },
        icon: Icon(icon, size: 28, color: Colors.white),
        label: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 60),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.blueAccent,
          elevation: 5,
        ),
      ),
    );
  }
}
