import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io'; // Import the dart:io library
import '../bloc/home_screen/home_bloc.dart';
import '../models/location_model.dart';
import '../services/database_repository.dart';

class LocationInputWidget extends StatefulWidget {
  @override
  _LocationInputWidgetState createState() => _LocationInputWidgetState();
}

class _LocationInputWidgetState extends State<LocationInputWidget> {
  final _formKey = GlobalKey<FormState>();
  List<String> dropdownItems = [];
  String? selectedList;
  List<XFile> selectedPhotos = [];

  final _nameController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchLists();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  void _fetchLists() async {
    context.read<HomeBloc>().add(FetchLists());
  }

  Future<void> _saveLocation() async {
    if (_formKey.currentState!.validate() && selectedList != null) {
      final location = LocationModel(
        name: _nameController.text,
        photos: selectedPhotos.map((photo) => photo.path).toList(),
        latitude: double.parse(_latitudeController.text),
        longitude: double.parse(_longitudeController.text),
        listId: await _getListIdByName(selectedList!),
      );
      await DatabaseRepository().insertLocation(location);

      _nameController.clear();
      _latitudeController.clear();
      _longitudeController.clear();
      selectedPhotos.clear();
      setState(() {
        selectedList = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location saved successfully!')));
    }
  }

  Future<int> _getListIdByName(String listName) async {
    final lists = await DatabaseRepository().getLists();
    return lists.firstWhere((list) => list.name == listName).id!;
  }

  Future<void> _addPhotos() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        selectedPhotos.addAll(pickedFiles);
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // Handle the case where the user denies or restricts permission.
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _latitudeController.text = position.latitude.toString();
        _longitudeController.text = position.longitude.toString();
      });
    } catch (e) {
      // Handle errors, e.g., if location services are not enabled.
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is ListsLoaded) {
          dropdownItems = state.lists.map((list) => list.name).toList();
        }

        return _buildLocationInput(context, dropdownItems);
      },
    );
  }

  Widget _buildLocationInput(BuildContext context, List<String> dropdownItems) {
    return Form(
      // Wrap the input fields with a Form
      key: _formKey, // Assign the form key
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height / 2,
              ),
              child: IntrinsicHeight(
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
                      // Name input
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),

                      // List dropdown
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 60,
                              child: DropdownButtonFormField<String>(
                                value: selectedList,
                                decoration: InputDecoration(
                                  labelText: 'List',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[300],
                                ),
                                items: dropdownItems.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedList = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select a list';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: _showAddItemDialog,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      // Add Photos button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          padding: EdgeInsets.symmetric(vertical: 15),
                          textStyle: TextStyle(fontSize: 16),
                        ),
                        onPressed: _addPhotos,
                        child: Text('Add Photos'),
                      ),
                      SizedBox(height: 10),
                      if (selectedPhotos
                          .isNotEmpty) // Show selected photos if any
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: selectedPhotos
                              .map((photo) => Image.file(
                                    File(photo.path),
                                    height: 100,
                                    width: 100,
                                  ))
                              .toList(),
                        ),

                      SizedBox(height: 20),

                      // Current Location button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          padding: EdgeInsets.symmetric(vertical: 15),
                          textStyle: TextStyle(fontSize: 16),
                        ),
                        onPressed: _getCurrentLocation,
                        child: Text('Current Location'),
                      ),
                      SizedBox(height: 20),

                      // Latitude and Longitude input
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _latitudeController,
                              decoration: InputDecoration(
                                labelText: 'Latitude',
                                filled: true,
                                fillColor: Colors.grey[200],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter latitude';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Invalid latitude';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: _longitudeController,
                              decoration: InputDecoration(
                                labelText: 'Longitude',
                                filled: true,
                                fillColor: Colors.grey[200],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              // <-- Correctly align here
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter longitude';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Invalid longitude';
                                }
                                return null;
                              },
                            ),
                          ),
                        ], // <-- Moved this bracket up to close the Row widget
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: Colors.blue.withOpacity(0.6),
                          textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        onPressed: _saveLocation,
                        // Functionality for "Save" button
                        child: Text('Save'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAddItemDialog() {
    String newItem = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Item'),
          content: TextField(
            onChanged: (value) {
              newItem = value;
            },
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                if (newItem.isNotEmpty) {
                  setState(() {
                    dropdownItems.add(newItem);
                    selectedList = newItem;
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
