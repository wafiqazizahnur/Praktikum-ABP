import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'counter_provider.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ini adalah aplikasi Counter"),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Isi Counter: "),
            Consumer<CounterProvider>(
              builder: (context, counter, child) {
                return Text(
                  "${counter.counter}",
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'btn1',
            onPressed: () {
              Provider.of<CounterProvider>(context, listen: false).increment();
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'btn2',
            onPressed: () {
              Provider.of<CounterProvider>(context, listen: false).decrement();
            },
            child: const Icon(Icons.remove),
          )
        ],
      ),
    );
  }
}