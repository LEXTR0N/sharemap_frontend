import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../bloc/capital_city/capital_city_bloc.dart';
import '../bloc/capital_city/capital_city_event.dart';
import '../bloc/capital_city/capital_city_state.dart';
import '../models/capital_city_model.dart';
import '../providers/theme_provider.dart';
import '../services/capital_city_service.dart';

class ListsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CapitalCityBloc>(
      create: (context) => CapitalCityBloc(CapitalCityService()),
      child: CapitalCityList(),
    );
  }
}

class CapitalCityList extends StatefulWidget {
  @override
  _CapitalCityListState createState() => _CapitalCityListState();
}

class _CapitalCityListState extends State<CapitalCityList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<CapitalCityBloc>().add(FetchCapitalCities()); // Fetch initially
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      context.read<CapitalCityBloc>().add(FetchCapitalCities());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CapitalCityBloc, CapitalCityState>(
      builder: (context, state) {
        if (state is CapitalCityLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is CapitalCityLoaded) {
          return _buildCapitalCityList(state.capitals); // Build the list
        } else if (state is CapitalCityError) {
          return Center(child: Text(state.message));
        }
        return Center(child: Text('No capitals found.'));
      },
    );
  }

  Widget _buildCapitalCityList(List<CapitalCity> capitals) {

    final themeProvider = Provider.of<ThemeProvider>(context);
    final backgroundColor = themeProvider.isDarkMode ? Color(0xFF212121) : Colors.white;

    return Center( // Added Center for better layout
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: SingleChildScrollView(
          child: Container( // Wrapping the list in a Container
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Capital Cities', style: TextStyle(fontSize: 16)),
                SizedBox(height: 20),
                ListView.builder( // Build the list
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: capitals.length,
                  itemBuilder: (context, index) {
                    final capital = capitals[index];
                    return ListTile(
                      title: Text(capital.capital),
                      subtitle: Text(capital.country),
                      trailing: IconButton(
                        icon: Icon(Icons.location_on),
                        onPressed: () {
                          BlocProvider.of<CapitalCityBloc>(context).add(SelectCity(capital));
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
