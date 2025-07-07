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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F0F23),
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header Section
              _buildHeader(context),
              
              // Navigation Items
              Expanded(
                child: _buildNavigationItems(context),
              ),
              
              // Footer Section
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Logo and App Name
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColor.royalBlue.withOpacity(0.3),
                      AppColor.royalBlue.withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColor.royalBlue.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.movie,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TedFlix',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Your Entertainment Hub',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          
          // User Profile Section
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColor.royalBlue.withOpacity(0.3),
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Back!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Discover amazing content',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationItems(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 16),
      children: [
        // Main Navigation Items
        _buildNavigationItem(
          context,
          icon: Icons.favorite,
          title: 'Favorite Movies',
          subtitle: 'Your saved movies',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => FavoriteScreen(),
              ),
            );
          },
        ),
        
        SizedBox(height: 8),
        
        _buildNavigationItem(
          context,
          icon: Icons.trending_up,
          title: 'Trending Now',
          subtitle: 'What\'s popular',
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        
        SizedBox(height: 8),
        
        _buildNavigationItem(
          context,
          icon: Icons.new_releases,
          title: 'New Releases',
          subtitle: 'Latest movies & shows',
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        
        SizedBox(height: 8),
        
        _buildNavigationItem(
          context,
          icon: Icons.tv,
          title: 'TV Shows',
          subtitle: 'Binge-worthy series',
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        
        SizedBox(height: 16),
        
        // Divider
        Container(
          margin: EdgeInsets.symmetric(horizontal: 24),
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.white.withOpacity(0.2),
                Colors.transparent,
              ],
            ),
          ),
        ),
        
        SizedBox(height: 16),
        
        // Settings Section
        _buildNavigationItem(
          context,
          icon: Icons.settings,
          title: 'Settings',
          subtitle: 'App preferences',
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        
        SizedBox(height: 8),
        
        _buildNavigationItem(
          context,
          icon: Icons.info_outline,
          title: 'About',
          subtitle: 'App information',
          onTap: () {
            Navigator.of(context).pop();
            _showDialog(context);
          },
        ),
      ],
    );
  }

  Widget _buildNavigationItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.05),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColor.royalBlue.withOpacity(0.3),
                        AppColor.royalBlue.withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColor.royalBlue.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withOpacity(0.4),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.3),
          ],
        ),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // App Version
          Text(
            'TedFlix v1.2.0',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 8),
          
          // TMDB Attribution
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Powered by ',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'TMDb',
                  style: TextStyle(
                    color: AppColor.royalBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
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
          titleStyle: TextStyle(color: Colors.white),
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
