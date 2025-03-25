import 'package:flutter/material.dart';
import 'package:tedflix_app/presentation/journeys/drawer/navigation_list_item.dart';

class NavigationExpandedListItem extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final List<String> children;

  const NavigationExpandedListItem({
    required Key key,
    required this.title,
    required this.onPressed,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.7),
              blurRadius: 2,
            ),
          ],
        ),
        child: ExpansionTile(
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          children: [
            for (int i = 0; i < children.length; i++)
              NavigationSubListItem(
                key: Key('sublist'),
                title: children[i],
                onPressed: () {},
              ),
          ],
        ),
      ),
    );
  }
}
