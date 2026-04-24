import 'package:flutter/material.dart';

class CategoryItem extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const CategoryItem({super.key, required this.title, required this.icon, required this.onTap});

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: _isPressed ? Colors.grey[200] : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: _isPressed 
                ? [] 
                : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))],
              border: Border.all(
                color: _isPressed ? const Color(0xFFFF8C00) : Colors.transparent,
                width: 2,
              ),
            ),
            child: Icon(
              widget.icon,
              size: 30,
              color: const Color(0xFFFF8C00),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 12, 
              fontWeight: _isPressed ? FontWeight.bold : FontWeight.w500,
              color: _isPressed ? const Color(0xFFFF8C00) : Colors.black87
            ),
          ),
        ],
      ),
    );
  }
}
