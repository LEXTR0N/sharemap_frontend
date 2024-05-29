import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart'; // Importieren des latlong2-Pakets
import '../models/location_model.dart';
import '../providers/theme_provider.dart';
import '../services/save_location_service.dart';

class ListsWidget extends StatefulWidget {
  final Function(LatLng) onShowLocation;

  const ListsWidget({Key? key, required this.onShowLocation}) : super(key: key);

  @override
  _ListsWidgetState createState() => _ListsWidgetState();
}

class _ListsWidgetState extends State<ListsWidget> {
  final SaveLocationService locationService = SaveLocationService();
  Owner owner = Owner(lists: []);
  bool showLocations = false;
  ListModel? selectedList;
  Location? selectedLocation;

  @override
  void initState() {
    super.initState();
    _loadOwner();
  }

  Future<void> _loadOwner() async {
    final loadedOwner = await locationService.loadOwner();
    if (loadedOwner != null) {
      setState(() {
        owner = loadedOwner;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final backgroundColor = themeProvider.isDarkMode ? Color(0xFF212121) : Colors.white;
    final inputFieldColor = themeProvider.isDarkMode ? Color(0xFF3D3D3D) : Colors.grey[200] ?? Colors.grey;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
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
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
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
      itemCount: lists.length,
      itemBuilder: (context, index) {
        final list = lists[index];
        return ListTile(
          title: Text(list.name),
          onTap: () {
            setState(() {
              showLocations = true;
              selectedList = list;
              selectedLocation = null; // Clear selected location
            });
          },
        );
      },
    );
  }

  Widget _buildLocationList(List<Location> locations, Color inputFieldColor) {
    return Column(
      children: [
        ListView.builder(
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
        if (selectedLocation != null) _buildLocationDetail(selectedLocation!, inputFieldColor),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              showLocations = false;
              selectedList = null;
              selectedLocation = null;
            });
          },
          child: Text('Back to Lists'),
        ),
      ],
    );
  }

  Widget _buildLocationDetail(Location location, Color inputFieldColor) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: inputFieldColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Name: ${location.name}', style: TextStyle(fontSize: 16)),
          Text('Latitude: ${location.latitude}', style: TextStyle(fontSize: 16)),
          Text('Longitude: ${location.longitude}', style: TextStyle(fontSize: 16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () => _deleteLocation(location),
                child: Text('Delete'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
              ElevatedButton(
                onPressed: () => widget.onShowLocation(LatLng(location.latitude, location.longitude)),
                child: Icon(Icons.location_on),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
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
          showLocations = false;
          selectedList = null;
        }
        selectedLocation = null;
      });
      await locationService.saveOwner(owner);
    }
  }
}
