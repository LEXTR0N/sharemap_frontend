import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/capital_city/capital_city_bloc.dart';
import '../bloc/capital_city/capital_city_event.dart';
import '../bloc/capital_city/capital_city_state.dart';
import '../services/capital_city_service.dart';

class ListsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CapitalCityBloc(CapitalCityService())..add(FetchCapitalCities()),
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
  bool _hasMore = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && _hasMore && !_isLoading) {
      setState(() {
        _isLoading = true;
      });
      context.read<CapitalCityBloc>().add(FetchCapitalCities());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Capital Cities', style: TextStyle(fontSize: 16)),
                SizedBox(height: 20),
                BlocBuilder<CapitalCityBloc, CapitalCityState>(
                  builder: (context, state) {
                    if (state is CapitalCityLoading && !_isLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is CapitalCityLoaded) {
                      _isLoading = false;
                      final capitals = state.capitals;

                      return ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        itemCount: capitals.length + 1,
                        itemBuilder: (context, index) {
                          if (index >= capitals.length) {
                            return _hasMore ? Center(child: CircularProgressIndicator()) : SizedBox.shrink();
                          }

                          final capital = capitals[index];
                          return ListTile(
                            title: Text(capital.capital),
                            subtitle: Text(capital.country),
                          );
                        },
                      );
                    } else if (state is CapitalCityError) {
                      return Center(child: Text(state.message));
                    }

                    return Center(child: Text('No capitals found.'));
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
