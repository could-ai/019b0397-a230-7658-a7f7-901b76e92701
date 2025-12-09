import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/service_provider.dart';

class SearchScreen extends StatefulWidget {
  final List<ServiceProvider> services;

  const SearchScreen({super.key, required this.services});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _selectedCategory = 'All';
  String _selectedCity = 'All';
  final TextEditingController _searchController = TextEditingController();

  final List<String> categories = ['All', 'Plumber', 'Electrician', 'AC Technician', 'Cleaning Services'];
  final List<String> omanCities = [
    'All', 'Muscat', 'Salalah', 'Sohar', 'Nizwa', 'Sur', 'Al Buraimi', 'Ibri',
    'Saham', 'Barka', 'Rustaq', 'Al Hamra', 'Bahla', 'Adam', 'Duqm',
    'Haima', 'Khasab', 'Dibba Al-Baya', 'Lima', 'Quriyat', 'Shinas',
    'Liwa', 'Al-Mazyunah', 'Mirbat', 'Rakhyut', 'Sadah', 'Salalah',
    'Shalim', 'Taqah', 'Thumrait'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args.containsKey('category')) {
        setState(() {
          _selectedCategory = args['category'];
        });
      }
    });
  }

  List<ServiceProvider> get _filteredServices {
    return widget.services.where((service) {
      final matchesCategory = _selectedCategory == 'All' || service.serviceType == _selectedCategory;
      final matchesCity = _selectedCity == 'All' || service.city == _selectedCity;
      final matchesSearch = _searchController.text.isEmpty ||
          service.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          service.description.toLowerCase().contains(_searchController.text.toLowerCase());
      return matchesCategory && matchesCity && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Services'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search by name or description',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) => setState(() {}),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: const InputDecoration(labelText: 'Category'),
                        items: categories.map((category) {
                          return DropdownMenuItem(value: category, child: Text(category));
                        }).toList(),
                        onChanged: (value) => setState(() => _selectedCategory = value!),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedCity,
                        decoration: const InputDecoration(labelText: 'City'),
                        items: omanCities.map((city) {
                          return DropdownMenuItem(value: city, child: Text(city));
                        }).toList(),
                        onChanged: (value) => setState(() => _selectedCity = value!),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _filteredServices.isEmpty
                ? const Center(child: Text('No services found'))
                : ListView.builder(
                    itemCount: _filteredServices.length,
                    itemBuilder: (context, index) {
                      final service = _filteredServices[index];
                      return ServiceCard(service: service);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class ServiceCard extends StatelessWidget {
  final ServiceProvider service;

  const ServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              service.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(service.serviceType, style: const TextStyle(color: Colors.blue)),
            Text('${service.city}', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Text(service.description),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _makeCall(service.phone),
                    icon: const Icon(Icons.call),
                    label: const Text('Call'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _openWhatsApp(service.phone),
                    icon: const Icon(Icons.message),
                    label: const Text('WhatsApp'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _makeCall(String phone) async {
    final Uri url = Uri.parse('tel:$phone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  void _openWhatsApp(String phone) async {
    final Uri url = Uri.parse('https://wa.me/$phone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}