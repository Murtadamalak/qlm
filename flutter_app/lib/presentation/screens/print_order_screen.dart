import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/datasources/storage_remote_data_source.dart';
import '../../domain/entities/order_status.dart';
import '../../domain/entities/print_order.dart';
import '../providers/auth_controller.dart';
import '../providers/orders_controller.dart';
import '../providers/pricing_controller.dart';

class PrintOrderScreen extends StatefulWidget {
  static const routeName = '/print-order';

  const PrintOrderScreen({super.key});

  @override
  State<PrintOrderScreen> createState() => _PrintOrderScreenState();
}

class _PrintOrderScreenState extends State<PrintOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pagesController = TextEditingController(text: '1');
  final _copiesController = TextEditingController(text: '1');
  String _paperSize = 'A4';
  bool _isColor = true;
  String _binding = 'None';
  File? _selectedFile;
  String? _fileName;
  bool _isUploading = false;

  @override
  void dispose() {
    _pagesController.dispose();
    _copiesController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx', 'jpg', 'png'],
    );
    if (result == null || result.files.isEmpty) return;
    setState(() {
      _selectedFile = File(result.files.single.path!);
      _fileName = result.files.single.name;
    });
  }

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate() || _selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields.')),
      );
      return;
    }
    final auth = context.read<AuthController>();
    final pricing = context.read<PricingController>();
    final orders = context.read<OrdersController>();
    final pages = int.tryParse(_pagesController.text.trim()) ?? 1;
    final copies = int.tryParse(_copiesController.text.trim()) ?? 1;
    final price = pricing.calculatePrice(
      paperSize: _paperSize,
      isColor: _isColor,
      copies: copies,
      binding: _binding,
      pages: pages,
    );

    setState(() => _isUploading = true);
    try {
      final userId = auth.currentUser?.id ?? '';
      final uploader = StorageRemoteDataSource();
      final fileUrl = await uploader.uploadPrintFile(
        file: _selectedFile!,
        userId: userId,
        fileName: _fileName ?? 'document',
      );
      final order = PrintOrder(
        id: '',
        customerId: userId,
        fileName: _fileName ?? '',
        fileUrl: fileUrl,
        paperSize: _paperSize,
        isColor: _isColor,
        copies: copies,
        binding: _binding,
        price: price,
        status: OrderStatus.pending,
        createdAt: DateTime.now(),
      );
      await orders.submitOrder(order);
      if (mounted) {
        Navigator.pop(context);
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pricing = context.watch<PricingController>();
    final pages = int.tryParse(_pagesController.text.trim()) ?? 1;
    final copies = int.tryParse(_copiesController.text.trim()) ?? 1;
    final price = pricing.calculatePrice(
      paperSize: _paperSize,
      isColor: _isColor,
      copies: copies,
      binding: _binding,
      pages: pages,
    );

    return StreamBuilder(
      stream: pricing.watchPricingRule(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        pricing.setRule(snapshot.data);
        return Scaffold(
          appBar: AppBar(title: const Text('Print Order')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Upload your document', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _pickFile,
                        icon: const Icon(Icons.upload_file),
                        label: const Text('Choose File'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(_fileName ?? 'No file selected'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  DropdownButtonFormField<String>(
                    value: _paperSize,
                    items: const [
                      DropdownMenuItem(value: 'A4', child: Text('A4')),
                      DropdownMenuItem(value: 'A3', child: Text('A3')),
                      DropdownMenuItem(value: 'Letter', child: Text('Letter')),
                    ],
                    onChanged: (value) => setState(() => _paperSize = value ?? 'A4'),
                    decoration: const InputDecoration(labelText: 'Paper Size'),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text('Color Printing'),
                    value: _isColor,
                    onChanged: (value) => setState(() => _isColor = value),
                  ),
                  TextFormField(
                    controller: _pagesController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Number of pages'),
                    validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _copiesController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Copies'),
                    validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _binding,
                    items: const [
                      DropdownMenuItem(value: 'None', child: Text('None')),
                      DropdownMenuItem(value: 'Spiral', child: Text('Spiral')),
                      DropdownMenuItem(value: 'Hardcover', child: Text('Hardcover')),
                    ],
                    onChanged: (value) => setState(() => _binding = value ?? 'None'),
                    decoration: const InputDecoration(labelText: 'Binding'),
                  ),
                  const SizedBox(height: 20),
                  Text('Estimated Price: ${price.toStringAsFixed(2)}'),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isUploading ? null : _submitOrder,
                      child: Text(_isUploading ? 'Submitting...' : 'Submit Order'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
