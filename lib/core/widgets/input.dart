import 'package:brasil_fields/brasil_fields.dart';
import 'package:catalog_3d/core/widgets/form_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Input extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool readOnly;
  final bool isCurrency;

  const Input({
    super.key,
    required this.controller,
    required this.label,
    this.readOnly = false,
    this.isCurrency = false,
  });

  @override
  Widget build(BuildContext context) {
    TextInputType keyboardType = TextInputType.number;
    List<TextInputFormatter> formatters = [];
    InputDecoration decoration = formDecoration(label);

    if (isCurrency) {
      formatters.add(FilteringTextInputFormatter.digitsOnly);
      formatters.add(RealInputFormatter(moeda: true));

      if (readOnly && controller.text.isEmpty) {
          decoration = decoration.copyWith(prefixText: 'R\$ ');
      }

    } else if (label != "Name" && !readOnly) {
      formatters.add(FilteringTextInputFormatter.allow(RegExp(r'[\d.]')));
      keyboardType = const TextInputType.numberWithOptions(decimal: true);
    } else {
      keyboardType = TextInputType.text;
    }

    return TextFormField(
      controller: controller,
      decoration: decoration, 
      readOnly: readOnly,
      keyboardType: keyboardType,
      inputFormatters: formatters.isNotEmpty ? formatters : null,
    );
  }
}