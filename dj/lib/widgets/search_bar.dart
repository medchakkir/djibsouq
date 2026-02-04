import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSearchPressed;

  const SearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.onSearchPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: "Search",
          border: InputBorder.none,
          icon: const Icon(Icons.search),
          suffixIcon: GestureDetector(
            onTap: onSearchPressed,
            child: const Icon(Icons.mic),
          ),
        ),
      ),
    );
  }
}
