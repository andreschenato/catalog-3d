import 'package:brasil_fields/brasil_fields.dart';
import 'package:catalog_3d/core/widgets/double_input.dart';
import 'package:catalog_3d/core/widgets/input.dart';
import 'package:catalog_3d/core/widgets/generic_button.dart';
import 'package:catalog_3d/core/widgets/titles.dart';
import 'package:catalog_3d/features/item/data/model/item.dart';
import 'package:catalog_3d/features/item/data/source/firebase_item_source.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateItem extends StatefulWidget {
  const CreateItem({super.key});

  @override
  State<CreateItem> createState() => _CreateItemState();
}

class _CreateItemState extends State<CreateItem> {
  final _formKey = GlobalKey<FormState>();

  final name = TextEditingController();
  final printingTime = TextEditingController();
  final weight = TextEditingController();
  final kgCost = TextEditingController();
  final markup = TextEditingController();
  final finalPrice = TextEditingController();
  final itemCost = TextEditingController(text: 0.obterReal());
  final totalCost = TextEditingController(text: 0.obterReal());
  final printerPower = TextEditingController();
  final kwhCost = TextEditingController();
  final energyCost = TextEditingController(text: 0.obterReal());
  final printerPrice = TextEditingController();
  final lifeTime = TextEditingController();
  final profit = TextEditingController(text: 0.obterReal());
  final failPercentage = TextEditingController();
  final arrangement = TextEditingController(text: 0.obterReal());

  final FirebaseItemSource _source = FirebaseItemSource();
  bool _isUpdating = false;

  late final List<TextEditingController> _costControllers;

  @override
  void initState() {
    super.initState();
    _costControllers = [
      printingTime,
      weight,
      kgCost,
      markup,
      printerPower,
      kwhCost,
      printerPrice,
      lifeTime,
      failPercentage,
    ];

    for (var controller in _costControllers) {
      controller.addListener(_onCostInputChange);
    }

    finalPrice.addListener(_onFinalPriceChange);
  }

  @override
  void dispose() {
    for (var controller in _costControllers) {
      controller.removeListener(_onCostInputChange);
    }
    finalPrice.removeListener(_onFinalPriceChange);

    for (var c in [
      name,
      printingTime,
      weight,
      kgCost,
      markup,
      finalPrice,
      itemCost,
      totalCost,
      printerPower,
      kwhCost,
      energyCost,
      printerPrice,
      lifeTime,
      profit,
      failPercentage,
      arrangement,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  double _parse(String text) {
    if (text.isEmpty) return 0.0;
    String clean = text.replaceAll(RegExp(r'[R$\s]'), '').replaceAll(',', '.');
    return double.tryParse(clean) ?? 0.0;
  }

  void _onCostInputChange() {
    setState(() {
      _calculateValues(updateFinalPrice: true);
    });
  }

  void _onFinalPriceChange() {
    if (_isUpdating) return;

    setState(() {
      _calculateMarkupFromFinalPrice(finalPrice.text);
    });
  }

  void _calculateValues({bool updateFinalPrice = true}) {
    if (_isUpdating) return;
    _isUpdating = true;

    double cost = 0;
    double energy = 0;
    double printerArrangement = 0;
    double total = 0;

    cost = (_parse(weight.text) / 1000) * _parse(kgCost.text);
    itemCost.text = cost.obterReal();
    total += cost;

    energy =
        (_parse(printerPower.text) / 1000) *
        _parse(printingTime.text) *
        _parse(kwhCost.text);
    energyCost.text = energy.obterReal();
    total += energy;

    if (_parse(lifeTime.text) > 0) {
      printerArrangement =
          (_parse(printerPrice.text) / _parse(lifeTime.text)) *
          _parse(printingTime.text);
      arrangement.text = printerArrangement.obterReal();
      total += printerArrangement;
    }

    total *= 1.0 + (_parse(failPercentage.text) / 100);
    totalCost.text = total.obterReal();

    if (updateFinalPrice) {
      double totalFinal = total * _parse(markup.text);
      finalPrice.text = totalFinal.obterReal();
    }

    profit.text = (_parse(finalPrice.text) - total).obterReal();

    _isUpdating = false;
  }

  void _calculateMarkupFromFinalPrice(String value) {
    if (_isUpdating) return;
    _isUpdating = true;

    double price = _parse(value);

    _calculateValues(updateFinalPrice: false);

    double cost = _parse(totalCost.text);

    if (cost > 0 && price > 0) {
      double newMarkup = price / cost;

      markup.text = newMarkup.toStringAsFixed(2);

      profit.text = (price - cost).obterReal();
    }

    _isUpdating = false;
  }

  String? _validateRequired(String? value) {
    if (value == null || value.isEmpty || _parse(value) == 0) {
      return 'This field is required!';
    }
    return null;
  }

  void _saveItem() {
    if (_formKey.currentState?.validate() ?? false) {
      _source
          .createItem(
            Item(
              name: name.text,
              printingTime: _parse(printingTime.text),
              weight: _parse(weight.text),
              kgCost: _parse(kgCost.text),
              markup: _parse(markup.text),
              finalPrice: _parse(finalPrice.text),
              totalCost: _parse(totalCost.text),
              printerPower: _parse(printerPower.text),
              kwhCost: _parse(kwhCost.text),
              printerPrice: _parse(printerPrice.text),
              lifeTime: _parse(lifeTime.text),
              failPercentage: _parse(failPercentage.text),
            ),
          )
          .then((_) {
            if (mounted) context.pop();
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Item')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SectionTitle("Model information"),
                Input(
                  controller: name,
                  label: "Name",
                  validator: (v) => v!.isEmpty ? 'Name is required' : null,
                ),
                DoubleInput(
                  Input(
                    controller: printingTime,
                    label: "Printing Time",
                    validator: _validateRequired,
                  ),
                  Input(
                    controller: weight,
                    label: "Item Weight",
                    validator: _validateRequired,
                  ),
                ),

                const SectionTitle("Costs"),
                const SubTitle("Raw Material"),
                DoubleInput(
                  Input(
                    isCurrency: false,
                    controller: kgCost,
                    label: "Cost/Kg",
                    validator: _validateRequired,
                  ),
                  Input(
                    controller: itemCost,
                    label: "Model Cost",
                    readOnly: true,
                    isCurrency: false,
                  ),
                ),
                const SubTitle("Printer"),
                DoubleInput(
                  Input(
                    controller: printerPower,
                    label: "Printer Power",
                  ),
                  Input(
                    controller: kwhCost,
                    label: "Kw/H Cost",
                  ),
                ),
                Input(
                  controller: energyCost,
                  label: "Energy Cost",
                  readOnly: true,
                  isCurrency: false,
                ),
                Input(
                  controller: failPercentage,
                  label: "Fail Percentage",
                ),
                const SubTitle("Printer Arrangement"),
                DoubleInput(
                  Input(
                    controller: printerPrice,
                    label: "Printer Price",
                  ),
                  Input(
                    controller: lifeTime,
                    label: "Printer Lifetime",
                  ),
                ),
                Input(
                  controller: arrangement,
                  label: "Arrangement",
                  readOnly: true,
                  isCurrency: false,
                ),

                const SectionTitle("Final Price"),
                DoubleInput(
                  Input(
                    controller: totalCost,
                    label: "Total Cost",
                    readOnly: true,
                    isCurrency: false,
                  ),
                  Input(
                    controller: markup,
                    label: "Markup",
                    validator: _validateRequired,
                  ),
                ),
                DoubleInput(
                  Input(
                    controller: finalPrice,
                    label: "Final Price",
                    isCurrency: false,
                    validator: _validateRequired,
                  ),
                  Input(
                    controller: profit,
                    label: "Profit",
                    readOnly: true,
                    isCurrency: false,
                  ),
                ),

                Row(
                  spacing: 20,
                  children: [
                    Expanded(
                      child: GenericButton(
                        backgroundColor: Colors.redAccent,
                        label: "Cancel",
                        onPressed: () => context.pop(),
                      ),
                    ),
                    Expanded(
                      child: GenericButton(
                        backgroundColor: Colors.lightBlue,
                        label: "Save",
                        onPressed: _saveItem,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
