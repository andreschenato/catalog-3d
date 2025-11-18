import 'package:flutter/material.dart';

InputDecoration formDecoration(String text) {
  return InputDecoration(
    labelText: text,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
  );
}
