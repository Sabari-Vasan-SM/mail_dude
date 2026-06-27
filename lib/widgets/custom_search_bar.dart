import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const CustomSearchBar({
    Key? key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SearchBar(
        controller: controller,
        padding: const MaterialStatePropertyAll<EdgeInsets>(
          EdgeInsets.symmetric(horizontal: 16.0),
        ),
        onChanged: onChanged,
        leading: const Icon(Icons.search),
        trailing: <Widget>[
          if (controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                controller.clear();
                onClear();
              },
            ),
        ],
        hintText: 'Search emails...',
        elevation: const MaterialStatePropertyAll<double>(0.0),
        backgroundColor: MaterialStatePropertyAll<Color>(
          Theme.of(context).brightness == Brightness.dark 
              ? Colors.grey.shade900 
              : Colors.white,
        ),
        shape: MaterialStatePropertyAll<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: BorderSide(
              color: Theme.of(context).brightness == Brightness.dark 
                  ? Colors.grey.shade800 
                  : Colors.grey.shade300,
            ),
          ),
        ),
      ),
    );
  }
}
