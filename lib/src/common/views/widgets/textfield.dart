import 'package:flutter/material.dart';

Widget buildTextField(
  BuildContext context, {
  required TextEditingController controller,
  required String label,
  required String hint,
  bool readOnly = false,
  bool allowClearButton = false,
  VoidCallback? onTap,
}) {
  final colorScheme = Theme.of(context).colorScheme;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: Theme.of(context).textTheme.labelMedium),
      const SizedBox(height: 6),
      TextField(
        controller: controller,
        readOnly: readOnly,

        onTap: onTap,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: hint,
          suffixIcon: allowClearButton
              ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    controller.clear();
                  },
                )
              : null,
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorScheme.primary),
          ),
        ),
      ),
    ],
  );
}
