import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'screens/home_screen.dart';
import 'screens/add_service_screen.dart';
import 'screens/search_screen.dart';
import 'models/service_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const OmanServiceApp());
}

class OmanServiceApp extends StatefulWidget {
  const OmanServiceApp({super.key});

  @override
  State<OmanServiceApp> createState() => _OmanServiceAppState();
}

class _OmanServiceAppState extends State<OmanServiceApp> {
  List<ServiceProvider> services = [];

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    final prefs = await SharedPreferences.getInstance();
    final servicesJson = prefs.getStringList('services') ?? [];
    setState(() {
      services = servicesJson.map((json) => ServiceProvider.fromJson(jsonDecode(json))).toList();
    });
  }

  Future<void> _saveServices() async {
    final prefs = await SharedPreferences.getInstance();
    final servicesJson = services.map((service) => jsonEncode(service.toJson())).toList();
    await prefs.setStringList('services', servicesJson);
  }

  void addService(ServiceProvider service) {
    setState(() {
      services.add(service);
    });
    _saveServices();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Oman Service',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(services: services),
        '/add-service': (context) => AddServiceScreen(onAddService: addService),
        '/search': (context) => SearchScreen(services: services),
      },
    );
  }
}