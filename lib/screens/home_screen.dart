import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharemap_frontend/screens/settings_screen.dart';
import '../bloc/home_screen/home_bloc.dart';
import '../services/database_repository.dart';
import '../widgets/lists_widget.dart';
import '../widgets/map_view.dart';
import '../widgets/bottom_nav_item.dart';
import '../widgets/floating_action_button.dart';
import '../widgets/location_input_widget.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(DatabaseRepository()),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Scaffold(
            appBar: null,
            body: Stack(
              children: [
                MapView(),
                Positioned(
                  top: 40.0,
                  right: 16.0,
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsScreen()),
                    ),
                    child: FloatingActionButtonWidget(icon: Icons.account_circle),
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
                            ? HomeInitialEvent()  // Updated event name
                            : LocationSelected()),  // Updated event name
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
                            ? HomeInitialEvent()   // Updated event name
                            : ListSelected()),  // Updated event name
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
        color: Colors.black.withOpacity(0.5), // Semi-transparent gray background
        padding: EdgeInsets.all(20),
        child: Center( // Center the content horizontally
          child: state is LocationSelectedState
              ? LocationInputWidget()
              : ListsWidget(), // Use ListsWidget for the list state
        ),
      ),
    );
  }
}
