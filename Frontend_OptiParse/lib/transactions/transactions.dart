import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:optiparse/auth/services/auth_service.dart';
import 'package:optiparse/main.dart';
import 'transactiondata.dart';

class TransactionsPage extends StatefulWidget {
  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  List<Transaction> transactions = [];
  List<Transaction> filteredTransactions = []; // To store filtered transactions
  bool isLoading = true;
  final AuthService _authService = AuthService();
  final _baseUrl = MyApp.baseUrl;
  String searchQuery = ''; // Search query string

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    try {
      final token = await _authService.getToken();
      final response = await http.post(
        Uri.parse('$_baseUrl/transaction_data'),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: '',
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        setState(() {
          transactions = responseData
              .map<Transaction>((data) => Transaction.fromJson(data))
              .toList();
          filteredTransactions =
              transactions; // Initially show all transactions
          isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch transactions')),
        );
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to filter the transactions based on search query
  void _filterTransactions(String query) {
    final filtered = transactions.where((transaction) {
      final lowerQuery = query.toLowerCase();
      return transaction.merchantName.toLowerCase().contains(lowerQuery) ||
          transaction.merchantId.toLowerCase().contains(lowerQuery) ||
          transaction.invoiceNumber.toLowerCase().contains(lowerQuery);
    }).toList();

    setState(() {
      filteredTransactions = filtered;
      searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions', style: TextStyle(color: theme.onPrimary)),
        backgroundColor: theme.primary,
      ),
      backgroundColor: theme.background,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(theme.primary),
              ),
            )
          : Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: _filterTransactions,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search by merchant, ID, or invoice...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: DataTable(
                        columnSpacing: 20.0,
                        columns: _buildColumns(theme),
                        rows: _buildRows(theme),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  // Function to build columns with styled headers for each field
  List<DataColumn> _buildColumns(ColorScheme theme) {
    return const [
      DataColumn(
          label: Text('Merchant Name',
              style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text('Merchant ID',
              style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(
          label:
              Text('Address', style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text('Phone Number',
              style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text('Fax', style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text('Invoice Number',
              style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text('GST Registration Number',
              style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text('GST %', style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text('Month', style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text('Year', style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text('Time', style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text('Financial Document Class',
              style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(
          label:
              Text('Item Type', style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text('Total Amount',
              style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text('Cashier Name',
              style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text('Customer Name',
              style: TextStyle(fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text('Number of Items',
              style: TextStyle(fontWeight: FontWeight.bold))),
    ];
  }

  // Function to build rows with filtered transaction data
  List<DataRow> _buildRows(ColorScheme theme) {
    return filteredTransactions.map((transaction) {
      return DataRow(cells: [
        DataCell(Text(transaction.merchantName)),
        DataCell(Text(transaction.merchantId)),
        DataCell(Text(transaction.address)),
        DataCell(Text(transaction.phoneNumber)),
        DataCell(Text(transaction.fax)),
        DataCell(Text(transaction.invoiceNumber)),
        DataCell(Text(transaction.gstRegistrationNumber)),
        DataCell(Text(transaction.gstPercentage.toString())),
        DataCell(Text(transaction.date)),
        DataCell(Text(transaction.month)),
        DataCell(Text(transaction.year.toString())),
        DataCell(Text(transaction.time)),
        DataCell(Text(transaction.financialDocumentClass)),
        DataCell(Text(transaction.itemType)),
        DataCell(Text(transaction.totalAmount.toString())),
        DataCell(Text(transaction.cashierName)),
        DataCell(Text(transaction.customerName)),
        DataCell(Text(transaction.numberOfItems.toString())),
      ]);
    }).toList();
  }
}
