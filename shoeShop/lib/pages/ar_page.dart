import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import '../models/schoen.dart';
import '../apis/schoen_api.dart';
import '../pages/details.dart';

class ArPage extends StatefulWidget {
  const ArPage({Key? key}) : super(key: key);

  @override
  State<ArPage> createState() => _ArPageState();
}

class _ArPageState extends State<ArPage> {
  UnityWidgetController? _unityWidgetController;

  @override
  void initState() {
    super.initState();
  }

  void _onUnityMessage(dynamic message) {
    try {
      Map<String, dynamic> decodedMessage = json.decode(message);
      String shoeID = decodedMessage['shoeID'];
      _fetchShoeDetails(shoeID);
    } catch (e) {
      print('Error processing Unity message: $e');
    }
  }

  Future<void> _fetchShoeDetails(String shoeID) async {
    try {
      final schoen = await SchoenApi.fetchSchoenByID(shoeID);

      if (mounted && schoen != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsPage(
              schoen: schoen,
              winkelwagen: [],
            ),
          ),
        );
      }
    } catch (e) {
      print('Error fetching shoe details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Schoenen AR Viewer")),
      body: UnityWidget(
        onUnityCreated: (controller) => _unityWidgetController = controller,
        onUnityMessage: _onUnityMessage,
        useAndroidViewSurface: true,
      ),
    );
  }
}
