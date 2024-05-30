import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sharemap_frontend/screens/settings_screen.dart';
import 'package:latlong2/latlong.dart';
import '../bloc/home_screen/home_bloc.dart';
import '../providers/theme_provider.dart';
import '../widgets/lists_widget.dart';
import '../widgets/map_view.dart';
import '../widgets/bottom_nav_item.dart';
import '../widgets/location_input_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LatLng? _selectedLocation;

  void _showSelectedLocation(LatLng location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final backgroundColor = themeProvider.isDarkMode ? const Color(0xFF212121) : Colors.white;

    return BlocProvider(
      create: (context) => HomeBloc(),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Scaffold(
            appBar: null,
            body: Stack(
              children: [
                MapView(selectedLocation: _selectedLocation),
                Positioned(
                  top: 40.0,
                  right: 16.0,
                  child: SizedBox(
                    height: 65.0,
                    width: 65.0,
                    child: FloatingActionButton(
                      heroTag: 'settingsFAB',
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsScreen()),
                      ),
                      backgroundColor: backgroundColor,
                      child: const Icon(Icons.settings),
                    ),
                  ),
                ),
                if (state is LocationSelectedState || state is ListSelectedState)
                  _buildOverlayContent(context, state),
              ],
            ),
            bottomNavigationBar: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () => context.read<HomeBloc>().add(
                      state is LocationSelectedState
                          ? HomeInitialEvent()
                          : LocationSelected(),
                    ),
                    child: BottomNavItem(
                      icon: Icons.location_on,
                      text: 'Location',
                      isSelected: state is LocationSelectedState,
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => context.read<HomeBloc>().add(
                      state is ListSelectedState
                          ? HomeInitialEvent()
                          : ListSelected(),
                    ),
                    child: BottomNavItem(
                      icon: Icons.menu,
                      text: 'Lists',
                      isSelected: state is ListSelectedState,
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          );
        },
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context, HomeState state) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.5),
        padding: const EdgeInsets.all(20),
        child: Center(
          child: state is LocationSelectedState
              ? LocationInputWidget()
              : ListsWidget(onShowLocation: _showSelectedLocation),
        ),
      ),
    );
  }
}
