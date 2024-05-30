import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';
import '../models/location_model.dart';
import '../providers/theme_provider.dart';
import '../services/capitals_service.dart';
import '../services/save_location_service.dart';

class ListsWidget extends StatefulWidget {
  final Function(LatLng) onShowLocation;

  const ListsWidget({super.key, required this.onShowLocation});

  @override
  _ListsWidgetState createState() => _ListsWidgetState();
}

class _ListsWidgetState extends State<ListsWidget> {
  final SaveLocationService locationService = SaveLocationService();
  final CapitalsService capitalsService = CapitalsService();
  Owner owner = Owner(lists: []);
  bool showLocations = false;
  ListModel? selectedList;
  Location? selectedLocation;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadOwner();
    await _loadCapitals();
  }

  Future<void> _loadOwner() async {
    final loadedOwner = await locationService.loadOwner();
    if (loadedOwner != null) {
      setState(() {
        owner = loadedOwner;
      });
    }
  }

  Future<void> _loadCapitals() async {
    try {
      List<Location> capitals = await capitalsService.fetchEuropeanCapitals();
      ListModel europeanCapitals = ListModel(name: 'European Capitals', locations: capitals);
      setState(() {
        owner.lists.add(europeanCapitals);
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final backgroundColor = themeProvider.isDarkMode ? const Color(0xFF212121) : Colors.white;
    final inputFieldColor = themeProvider.isDarkMode ? const Color(0xFF3D3D3D) : Colors.grey[200] ?? Colors.grey;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  showLocations && selectedList != null
                      ? 'Locations in ${selectedList!.name}'
                      : 'Lists',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                showLocations && selectedList != null
                    ? _buildLocationList(selectedList!.locations, inputFieldColor)
                    : _buildList(owner.lists, inputFieldColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildList(List<ListModel> lists, Color inputFieldColor) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: lists.length,
      itemBuilder: (context, index) {
        final list = lists[index];
        return ListTile(
          title: Text(list.name),
          onTap: () {
            setState(() {
              showLocations = true;
              selectedList = list;
              selectedLocation = null;
            });
          },
        );
      },
    );
  }

  Widget _buildLocationList(List<Location> locations, Color inputFieldColor) {
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: locations.length,
            itemBuilder: (context, index) {
              final location = locations[index];
              return ListTile(
                title: Text(location.name),
                subtitle: Text('Latitude: ${location.latitude}, Longitude: ${location.longitude}'),
                onTap: () {
                  setState(() {
                    selectedLocation = location;
                  });
                },
              );
            },
          ),
        ),
        if (selectedLocation != null) _buildLocationDetail(selectedLocation!, inputFieldColor),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              showLocations = false;
              selectedList = null;
              selectedLocation = null;
            });
          },
          child: const Text('Back to Lists'),
        ),
      ],
    );
  }

  Widget _buildLocationDetail(Location location, Color inputFieldColor) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: inputFieldColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Name: ${location.name}', style: const TextStyle(fontSize: 16)),
          Text('Latitude: ${location.latitude}', style: const TextStyle(fontSize: 16)),
          Text('Longitude: ${location.longitude}', style: const TextStyle(fontSize: 16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () => _deleteLocation(location),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Icon(Icons.delete),
              ),
              ElevatedButton(
                onPressed: () {
                  widget.onShowLocation(LatLng(location.latitude, location.longitude));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Icon(Icons.location_on),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _deleteLocation(Location location) async {
    if (selectedList != null) {
      setState(() {
        selectedList!.locations.remove(location);
        if (selectedList!.locations.isEmpty) {
          owner.lists.remove(selectedList);
        }
      });
      await locationService.saveOwner(owner);
      if (owner.lists.isEmpty) {
        Navigator.pop(context);
      }
    }
  }
}
