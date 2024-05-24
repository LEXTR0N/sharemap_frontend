import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerWidget extends StatefulWidget {
  final Widget child;

  const PermissionHandlerWidget({Key? key, required this.child}) : super(key: key);

  @override
  _PermissionHandlerWidgetState createState() => _PermissionHandlerWidgetState();
}

class _PermissionHandlerWidgetState extends State<PermissionHandlerWidget> {
  @override
  void initState() {
    super.initState();
    requestLocationPermission();
  }

  Future<void> requestLocationPermission() async {
    final status = await Permission.location.request();
    print('Permission status: $status');
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
