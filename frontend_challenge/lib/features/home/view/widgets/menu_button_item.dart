import 'package:flutter/material.dart';
import 'package:frontend_challenge/core/extensions/context.dart';
import 'package:frontend_challenge/core/extensions/string.dart';
import 'package:frontend_challenge/core/theme/app_pallete.dart';
import 'package:frontend_challenge/features/home/models/customer_model.dart';
import 'package:frontend_challenge/features/home/view/widgets/customer_entrance_modal.dart';

enum MenuItem {
  edit;

  IconData get icon => switch (this) { edit => Icons.edit };
}

class MenuButtonItem extends StatefulWidget {
  final CustomerModel customer;
  const MenuButtonItem(this.customer, {super.key});

  @override
  State<MenuButtonItem> createState() => _MenuButtonItemState();
}

class _MenuButtonItemState extends State<MenuButtonItem> {
  MenuItem? selectedMenu;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      style: MenuStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          backgroundColor: WidgetStateProperty.all(Pallete.blackColor)),
      builder:
          (BuildContext context, MenuController controller, Widget? child) =>
              IconButton(
        onPressed: () {
          if (controller.isOpen) {
            controller.close();
          } else {
            controller.open();
          }
        },
        icon: const Icon(Icons.more_vert),
        tooltip: 'Show menu',
      ),
      menuChildren: List<MenuItemButton>.from(
        MenuItem.values.map((item) => MenuItemButton(
              key: ValueKey(item),
              onPressed: () {
                setState(() => selectedMenu = item);
                _onMenuItemSelected(item);
              },
              leadingIcon: Icon(
                item.icon,
                color: Pallete.whiteColor,
              ),
              child: Text(
                item.name.capitalize(),
                style: context.textTheme.bodyLarge?.copyWith(
                  color: Pallete.whiteColor,
                ),
              ),
            )),
      ),
    );
  }

  void _onMenuItemSelected(MenuItem item) {
    switch (item) {
      case MenuItem.edit:
        CustomerEntranceModal(widget.customer).show(context);
        break;
    }
  }
}
