import 'package:flutter/material.dart';
import 'package:tedflix_app/common/constants/languages.dart';
import 'package:tedflix_app/common/constants/size_constants.dart';
import 'package:tedflix_app/common/constants/translation_constants.dart';
import 'package:tedflix_app/common/extensions/size_extensions.dart';
import 'package:tedflix_app/presentation/app_localizations.dart';
import 'package:tedflix_app/presentation/journeys/drawer/navigation_expanded_list_item.dart';
import 'package:tedflix_app/presentation/journeys/drawer/navigation_list_item.dart';
import 'package:tedflix_app/presentation/journeys/favorite/favorite_screen.dart';
import 'package:tedflix_app/presentation/themes/theme_color.dart';
import 'package:tedflix_app/presentation/widgets/app_dialog.dart';
import 'package:tedflix_app/presentation/widgets/logo.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color(0xFF13121b),// This sets the drawer background color
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: Sizes.dimen_8.h.toDouble(),
                  bottom: Sizes.dimen_18.h.toDouble(),
                  left: Sizes.dimen_8.w.toDouble(),
                  right: Sizes.dimen_8.w.toDouble(),
                ),
                child: Logo(
                  height: Sizes.dimen_20.h.toDouble(),
                ),
              ),
              NavigationListItem(
                key: Key('favourite'),
                title: 'Favorite Movies',
                color: Colors.white,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FavoriteScreen(),
                    ),
                  );
                },
              ),
              // NavigationListItem(
              //   key: Key('about'),
              //   title: 'About',
              //   color: Colors.white,
              // onPressed: () {
              //   Navigator.of(context).pop();
              //   _showDialog(context);
              // },
              // ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AppDialog(
          key: Key('about_dialog'),
          title: "About",
          titleStyle: TextStyle(color: Colors.white),  // Set title color to white
          description: "This product uses the TMDb API but is not endorsed or certified by TMDb.",
          buttonText: "Okay",
          image: Image.asset(
            'assets/pngs/tmdb_logo.png',
            height: Sizes.dimen_32.h.toDouble(),
          ),
        );
      },
    );
}


}
