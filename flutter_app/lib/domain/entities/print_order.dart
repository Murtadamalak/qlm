import 'package:equatable/equatable.dart';
import 'order_status.dart';

class PrintOrder extends Equatable {
  final String id;
  final String customerId;
  final String fileName;
  final String fileUrl;
  final String paperSize;
  final bool isColor;
  final int copies;
  final String binding;
  final double price;
  final OrderStatus status;
  final DateTime createdAt;

  const PrintOrder({
    required this.id,
    required this.customerId,
    required this.fileName,
    required this.fileUrl,
    required this.paperSize,
    required this.isColor,
    required this.copies,
    required this.binding,
    required this.price,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        customerId,
        fileName,
        fileUrl,
        paperSize,
        isColor,
        copies,
        binding,
        price,
        status,
        createdAt,
      ];
}
