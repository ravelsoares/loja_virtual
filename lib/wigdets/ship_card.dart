import 'package:flutter/material.dart';

class ShipCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        "Calcular frete",
        textAlign: TextAlign.start,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.grey[700],
        ),
      ),
      leading: const Icon(Icons.location_on),
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Digite seu CEP',
            ),
            initialValue: '',
            onFieldSubmitted: (text) {},
          ),
        ),
      ],
    );
  }
}
