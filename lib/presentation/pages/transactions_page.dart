import 'package:flutter/material.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Perform refresh logic here
              // You can use Navigator to navigate to another screen
              Navigator.pushNamed(context, '/home');
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 10, // Replace with actual number of transactions
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index) {
          final transaction = Transaction(
            amount: 100.0,
            date: DateTime.now(),
            status: 'success',
          );
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: transaction.status == 'success'
                    ? Colors.green
                    : Colors.orange,
                child: Icon(
                  transaction.status == 'success' ? Icons.check : Icons.pending,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              title: Text(
                '₱${transaction.amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    'Date: ${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    'Time: ${transaction.date.hour}:${transaction.date.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: transaction.status == 'success'
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  transaction.status.toUpperCase(),
                  style: TextStyle(
                    color: transaction.status == 'success'
                        ? Colors.green
                        : Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Transaction {
  final double amount;
  final DateTime date;
  final String status;

  Transaction({required this.amount, required this.date, required this.status});
}
