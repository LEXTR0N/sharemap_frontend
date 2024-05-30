import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../models/location_model.dart';
import '../providers/theme_provider.dart';
import '../services/save_location_service.dart';
import '../bloc/home_screen/home_bloc.dart';

class LocationInputWidget extends StatefulWidget {
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  LocationInputWidget({super.key});

  @override
  _LocationInputWidgetState createState() => _LocationInputWidgetState();
}

class _LocationInputWidgetState extends State<LocationInputWidget> {
  List<String> dropdownItems = [];
  String? selectedItem;
  final SaveLocationService locationService = SaveLocationService();
  Owner owner = Owner(lists: []);

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
        dropdownItems = owner.lists.map((list) => list.name).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final backgroundColor = themeProvider.isDarkMode ? const Color(0xFF212121) : Colors.white;
    final inputFieldColor = themeProvider.isDarkMode ? const Color(0xFF3D3D3D) : Colors.grey[200];
    final buttonColor = themeProvider.isDarkMode ? const Color(0xFF3D3D3D) : Colors.grey[300];

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height / 2,
            ),
            child: IntrinsicHeight(
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
                    const Text('Name:', style: TextStyle(fontSize: 16)),
                    SizedBox(
                      height: 60,
                      child: TextField(
                        controller: widget.nameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: inputFieldColor,
                          hintText: 'Enter name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 60,
                            child: DropdownButtonFormField<String>(
                              value: selectedItem,
                              decoration: InputDecoration(
                                labelText: 'List',
                                filled: true,
                                fillColor: inputFieldColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              items: dropdownItems.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedItem = newValue;
                                });
                              },
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _showAddItemDialog,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      onPressed: _getCurrentLocation,
                      child: const Text('Current Location'),
                    ),
                    const SizedBox(height: 20),
                    const Text('Latitude:', style: TextStyle(fontSize: 16)),
                    SizedBox(
                      height: 60,
                      child: TextField(
                        controller: widget.latitudeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: inputFieldColor,
                          hintText: 'Enter latitude',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text('Longitude:', style: TextStyle(fontSize: 16)),
                    SizedBox(
                      height: 60,
                      child: TextField(
                        controller: widget.longitudeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: inputFieldColor,
                          hintText: 'Enter longitude',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Colors.blue.withOpacity(0.6),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      onPressed: _saveLocation,
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        widget.latitudeController.text = position.latitude.toString();
        widget.longitudeController.text = position.longitude.toString();
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error getting current location: $e");
      }
    }
  }

  void _saveLocation() {
    if (widget.nameController.text.isEmpty ||
        widget.latitudeController.text.isEmpty ||
        widget.longitudeController.text.isEmpty ||
        selectedItem == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (double.tryParse(widget.latitudeController.text) == null ||
        double.tryParse(widget.longitudeController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Latitude and Longitude must be valid numbers'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final location = Location(
      name: widget.nameController.text,
      latitude: double.parse(widget.latitudeController.text),
      longitude: double.parse(widget.longitudeController.text),
    );

    final listIndex = owner.lists.indexWhere((list) => list.name == selectedItem);
    if (listIndex >= 0) {
      owner.lists[listIndex].locations.add(location);
    } else {
      owner.lists.add(
        ListModel(
          name: selectedItem ?? 'Unnamed List',
          locations: [location],
        ),
      );
    }

    locationService.saveOwner(owner).then((_) {
      if (kDebugMode) {
        print('Location successfully saved!');
      }
      context.read<HomeBloc>().add(HomeInitialEvent()); // Close the widget
    });
  }

  void _showAddItemDialog() {
    String newItem = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Item'),
          content: TextField(
            onChanged: (value) {
              newItem = value;
            },
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (newItem.isNotEmpty) {
                  setState(() {
                    dropdownItems.add(newItem);
                    selectedItem = newItem;
                  });
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
