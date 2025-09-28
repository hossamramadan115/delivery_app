class OrderModel {
  final String id;
  final String? orderNumber;
  final String pickUpAddress;
  final String pickUpUserName;
  final String pickUpPhone;
  final String dropOffAddress;
  final String dropOffUserName;
  final String dropOffPhone;
  final double price;
  final DateTime createdAt;
  final String status;
  final int? currentStep;

  OrderModel({
    required this.id,
    this.orderNumber,
    required this.pickUpAddress,
    required this.pickUpUserName,
    required this.pickUpPhone,
    required this.dropOffAddress,
    required this.dropOffUserName,
    required this.dropOffPhone,
    required this.price,
    this.currentStep = 0,
    DateTime? createdAt,
    this.status = 'pending',
  }) : createdAt = createdAt ?? DateTime.now();

  OrderModel copyWith({
    String? orderNumber,
    String? status,
    int? currentStep,
  }) {
    return OrderModel(
      id: id,
      orderNumber: orderNumber ?? this.orderNumber,
      pickUpAddress: pickUpAddress,
      pickUpUserName: pickUpUserName,
      pickUpPhone: pickUpPhone,
      dropOffAddress: dropOffAddress,
      dropOffUserName: dropOffUserName,
      dropOffPhone: dropOffPhone,
      price: price,
      createdAt: createdAt,
      status: status ?? this.status,
      currentStep: currentStep ?? this.currentStep,
    );
  }
}
