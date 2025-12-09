import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../models/service_provider.dart';

class AddServiceScreen extends StatefulWidget {
  final Function(ServiceProvider) onAddService;

  const AddServiceScreen({super.key, required this.onAddService});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedServiceType;
  String? _selectedCity;

  final List<String> serviceTypes = ['Plumber', 'Electrician', 'AC Technician', 'Cleaning Services'];
  final List<String> omanCities = [
    'Muscat', 'Salalah', 'Sohar', 'Nizwa', 'Sur', 'Al Buraimi', 'Ibri',
    'Saham', 'Barka', 'Rustaq', 'Al Hamra', 'Bahla', 'Adam', 'Duqm',
    'Haima', 'Khasab', 'Dibba Al-Baya', 'Lima', 'Quriyat', 'Shinas',
    'Liwa', 'Al-Mazyunah', 'Mirbat', 'Rakhyut', 'Sadah', 'Salalah',
    'Shalim', 'Taqah', 'Thumrait'
  ];

  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712', // Test ad unit ID
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial ad failed to load: $error');
        },
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _descriptionController.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final service = ServiceProvider(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        phone: _phoneController.text,
        serviceType: _selectedServiceType!,
        city: _selectedCity!,
        description: _descriptionController.text,
      );
      widget.onAddService(service);
      _showInterstitialAd();
      Navigator.pop(context);
    }
  }

  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
      _interstitialAd = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Service'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'Please enter your phone number' : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedServiceType,
                decoration: const InputDecoration(labelText: 'Service Type'),
                items: serviceTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) => setState(() => _selectedServiceType = value),
                validator: (value) => value == null ? 'Please select a service type' : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedCity,
                decoration: const InputDecoration(labelText: 'City'),
                items: omanCities.map((city) {
                  return DropdownMenuItem(value: city, child: Text(city));
                }).toList(),
                onChanged: (value) => setState(() => _selectedCity = value),
                validator: (value) => value == null ? 'Please select a city' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Short Description'),
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Add Service'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}