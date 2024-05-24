import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home_screen/home_bloc.dart';

class ListsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is ListsLoaded) {
          return ListView.builder(
            itemCount: state.lists.length,
            itemBuilder: (context, index) {
              final list = state.lists[index];
              return ListTile(
                title: Text(list.name),
                // Add onTap functionality to navigate to a details screen for the list
                onTap: () {
                  // TODO: Implement navigation to list details screen
                },
              );
            },
          );
        } else if (state is HomeError) {
          return Center(child: Text('Error: ${state.error}'));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
