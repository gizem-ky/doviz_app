import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/currency_provider.dart';
import 'home_page.dart';

class CurrentExchangeRatePage extends ConsumerWidget {
  const CurrentExchangeRatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyData = ref.watch(currencyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Döviz Kurları", style: TextStyle(color: Colors.white, fontSize: 24),),
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
                    child: currencyData.when(
                      data: (currencies) {
                        return ListView.builder(
                          padding: const EdgeInsets.only(top: 8.0),
                          itemCount: currencies.length,
                          itemBuilder: (context, index) {
                            final entry = currencies.entries.elementAt(index);
                            final currency = entry.value;

                            return Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16.0),
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blue.shade700,
                                  child: Text(
                                    currency.name[0],
                                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ),
                                title: Text(
                                  currency.name,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  '1 TRY = ${currency.rate.toStringAsFixed(4)} ${entry.key}',
                                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (error, stack) => Center(
                        child: Text(
                          'Veri alınamadı: $error',
                          style: const TextStyle(fontSize: 16, color: Colors.red),
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
