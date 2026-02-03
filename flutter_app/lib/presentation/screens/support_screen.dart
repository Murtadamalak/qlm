import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/support_controller.dart';

class SupportScreen extends StatelessWidget {
  static const routeName = '/support';

  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<SupportController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Support')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Need help?', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            const Text('Chat with our support team on WhatsApp for quick assistance.'),
            const SizedBox(height: 20),
            StreamBuilder<String?>(
              stream: controller.watchSupportPhoneNumber(),
              builder: (context, snapshot) {
                final phoneNumber = snapshot.data;
                if (phoneNumber == null || phoneNumber.isEmpty) {
                  return const Text('Support contact is unavailable right now.');
                }
                return ElevatedButton.icon(
                  onPressed: () => controller.openWhatsApp(phoneNumber: phoneNumber),
                  icon: const Icon(Icons.chat),
                  label: const Text('Open WhatsApp'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
