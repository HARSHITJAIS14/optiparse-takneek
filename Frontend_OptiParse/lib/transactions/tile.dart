import 'package:flutter/material.dart';

class TransactionTile extends StatefulWidget {
  final String invoiceNumber;
  final String date;
  final String month;
  final String year;
  final String totalAmount;
  final Function onTap;

  TransactionTile({
    required this.invoiceNumber,
    required this.date,
    required this.month,
    required this.year,
    required this.totalAmount,
    required this.onTap,
  });

  @override
  _TransactionTileState createState() => _TransactionTileState();
}

class _TransactionTileState extends State<TransactionTile> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            isHovered = true;
          });
        },
        onExit: (_) {
          setState(() {
            isHovered = false;
          });
        },
        child: Card(
          margin: EdgeInsets.all(8.0),
          color: isHovered
              ? theme.colorScheme.secondary
              : theme.colorScheme.background,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Invoice: ${widget.invoiceNumber}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Date: ${widget.date}-${widget.month}-${widget.year}',
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  '\$${widget.totalAmount}',
                  style: TextStyle(color: theme.colorScheme.primary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
