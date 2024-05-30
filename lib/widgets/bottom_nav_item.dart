import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isSelected;

  const BottomNavItem({
    super.key,
    required this.icon,
    required this.text,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final backgroundColor =
        themeProvider.isDarkMode ? const Color(0xFF212121) : Colors.white;

    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.withOpacity(0.7) : backgroundColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon),
          Text(text, style: const TextStyle(fontSize: 12.0)),
        ],
      ),
    );
  }
}
