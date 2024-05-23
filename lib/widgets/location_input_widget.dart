import 'package:flutter/material.dart';

class LocationInputWidget extends StatefulWidget {
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  _LocationInputWidgetState createState() => _LocationInputWidgetState();
}

class _LocationInputWidgetState extends State<LocationInputWidget> {
  List<String> dropdownItems = ['Option 1', 'Option 2', 'Option 3'];
  String? selectedItem;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: SingleChildScrollView( // Wrap the content for scrolling
          child: ConstrainedBox( // Constrain the size of the widget
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height / 2,
            ),
            child: IntrinsicHeight( // Allow the widget to take up the full viewport height
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Important for scrolling
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Name:', style: TextStyle(fontSize: 16)),
                    SizedBox(
                      height: 60,
                      child: TextField(
                        controller: widget.nameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          hintText: 'Enter name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 60,
                            child: DropdownButtonFormField<String>(
                              value: selectedItem,
                              decoration: InputDecoration(
                                labelText: 'List',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true, // Fill the background
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
                                  selectedItem = newValue;
                                });
                                // Handle dropdown selection
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
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        padding: EdgeInsets.symmetric(vertical: 15),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                        // Functionality for "Add Photos" button
                      },
                      child: Text('Add Photos'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        padding: EdgeInsets.symmetric(vertical: 15),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                        // Functionality for "Current Location" button
                      },
                      child: Text('Current Location'),
                    ),
                    SizedBox(height: 20),
                    Text('Latitude:', style: TextStyle(fontSize: 16)),
                    SizedBox(
                      height: 60,
                      child: TextField(
                        controller: widget.latitudeController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          hintText: 'Enter latitude',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('Longitude:', style: TextStyle(fontSize: 16)),
                    SizedBox(
                      height: 60,
                      child: TextField(
                        controller: widget.longitudeController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          hintText: 'Enter longitude',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
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
                      onPressed: () {
                        // Functionality for "Save" button
                      },
                      child: Text('Save'),
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

