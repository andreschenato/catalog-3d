import 'package:brasil_fields/brasil_fields.dart';
import 'package:catalog_3d/core/widgets/double_input.dart';
import 'package:catalog_3d/core/widgets/input.dart';
import 'package:catalog_3d/core/widgets/generic_button.dart';
import 'package:catalog_3d/core/widgets/titles.dart';
import 'package:catalog_3d/features/item/data/model/item.dart';
import 'package:catalog_3d/features/item/data/source/firebase_item_source.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ViewItem extends StatelessWidget {
  final String itemId;

  ViewItem({super.key, required this.itemId});

  final FirebaseItemSource _source = FirebaseItemSource();

  String _formatCurrencyDisplay(num? value) {
    if (value == null) return 'R\$ 0,00';

    String formattedValue = value.toDouble().obterReal(2);

    return formattedValue;
  }

  String _formatNumDisplay(num? value) {
    if (value == null) return '0';
    return value.toStringAsFixed(2);
  }

  Map<String, String> _calculateDisplayValues(Item item) {
    final Map<String, String> values = {};

    final double weight = item.weight.toDouble();
    final double kgCost = item.kgCost.toDouble();
    final double printingTime = item.printingTime.toDouble();
    final double printerPower = item.printerPower.toDouble();
    final double kwhCost = item.kwhCost.toDouble();
    final double printerPrice = item.printerPrice?.toDouble() ?? 0.0;
    final double lifeTime =
        item.lifeTime?.toDouble() ?? 1.0; 
    final double failPercentage = item.failPercentage?.toDouble() ?? 0.0;
    final double finalPrice = item.finalPrice.toDouble();

    final double cost = (weight / 1000) * kgCost;
    values['itemCost'] = _formatCurrencyDisplay(cost);

    final double energy = (printerPower / 1000) * printingTime * kwhCost;
    values['energyCost'] = _formatCurrencyDisplay(energy);

    final double arrangementValue = (lifeTime > 0)
        ? (printerPrice / lifeTime) * printingTime
        : 0.0;
    values['arrangement'] = _formatCurrencyDisplay(arrangementValue);

    double total = cost + energy + arrangementValue;

    total *= 1.0 + (failPercentage / 100);
    values['totalCost'] = _formatCurrencyDisplay(total);

    final double profitValue = finalPrice - total;
    values['profit'] = _formatCurrencyDisplay(profitValue);

    return values;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('View Item')),
      body: FutureBuilder<Item?>(
        future: _source.getItem(itemId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text(
                'Error loading item: ${snapshot.error ?? "Item not found"}',
              ),
            );
          }

          final Item item = snapshot.data!;
          final calculatedValues = _calculateDisplayValues(item);

          final name = TextEditingController(text: item.name);
          final printingTime = TextEditingController(
            text: _formatNumDisplay(item.printingTime),
          );
          final weight = TextEditingController(
            text: _formatNumDisplay(item.weight),
          );
          final kgCost = TextEditingController(
            text: _formatCurrencyDisplay(item.kgCost),
          );
          final markup = TextEditingController(
            text: _formatNumDisplay(item.markup),
          );
          final finalPrice = TextEditingController(
            text: _formatCurrencyDisplay(item.finalPrice),
          );

          final itemCost = TextEditingController(
            text: calculatedValues['itemCost'],
          );
          final totalCost = TextEditingController(
            text: calculatedValues['totalCost'],
          );
          final energyCost = TextEditingController(
            text: calculatedValues['energyCost'],
          );
          final profit = TextEditingController(
            text: calculatedValues['profit'],
          );
          final arrangement = TextEditingController(
            text: calculatedValues['arrangement'],
          );

          final printerPower = TextEditingController(
            text: _formatNumDisplay(item.printerPower),
          );
          final kwhCost = TextEditingController(
            text: _formatCurrencyDisplay(item.kwhCost),
          );
          final printerPrice = TextEditingController(
            text: _formatCurrencyDisplay(item.printerPrice),
          );
          final lifeTime = TextEditingController(
            text: _formatNumDisplay(item.lifeTime),
          );
          final failPercentage = TextEditingController(
            text: _formatNumDisplay(item.failPercentage),
          );

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
            child: SingleChildScrollView(
              child: Form(
                child: Column(
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SectionTitle("Model information"),
                    Input(controller: name, label: "Name", readOnly: true),
                    DoubleInput(
                      Input(
                        controller: printingTime,
                        label: "Printing Time",
                        readOnly: true,
                      ),
                      Input(
                        controller: weight,
                        label: "Item Weight",
                        readOnly: true,
                      ),
                    ),

                    const SectionTitle("Costs"),
                    const SubTitle("Raw Material"),
                    DoubleInput(
                      Input(
                        controller: kgCost,
                        label: "Cost/Kg",
                        readOnly: true,
                      ),
                      Input(
                        controller: itemCost,
                        label: "Model Cost",
                        readOnly: true,
                        isCurrency: true,
                      ),
                    ),
                    const SubTitle("Printer"),
                    DoubleInput(
                      Input(
                        controller: printerPower,
                        label: "Printer Power",
                        readOnly: true,
                      ),
                      Input(
                        controller: kwhCost,
                        label: "Kw/H Cost",
                        readOnly: true,
                      ),
                    ),
                    Input(
                      controller: energyCost,
                      label: "Energy Cost",
                      readOnly: true,
                      isCurrency: true,
                    ),
                    Input(
                      controller: failPercentage,
                      label: "Fail Percentage",
                      readOnly: true,
                    ),
                    const SubTitle("Printer Arrangement"),
                    DoubleInput(
                      Input(
                        controller: printerPrice,
                        label: "Printer Price",
                        readOnly: true,
                      ),
                      Input(
                        controller: lifeTime,
                        label: "Printer Lifetime",
                        readOnly: true,
                      ),
                    ),
                    Input(
                      controller: arrangement,
                      label: "Arrangement",
                      readOnly: true,
                      isCurrency: true,
                    ),

                    const SectionTitle("Final Price"),
                    DoubleInput(
                      Input(
                        controller: totalCost,
                        label: "Total Cost",
                        readOnly: true,
                        isCurrency: true,
                      ),
                      Input(
                        controller: markup,
                        label: "Markup",
                        readOnly: true,
                      ),
                    ),
                    DoubleInput(
                      Input(
                        controller: finalPrice,
                        label: "Final Price",
                        readOnly: true,
                        isCurrency: true,
                      ),
                      Input(
                        controller: profit,
                        label: "Profit",
                        readOnly: true,
                        isCurrency: true,
                      ),
                    ),

                    Row(
                      spacing: 20,
                      children: [
                        Expanded(
                          child: GenericButton(
                            backgroundColor: Colors.redAccent,
                            label: "Back",
                            onPressed: () => context.pop(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
