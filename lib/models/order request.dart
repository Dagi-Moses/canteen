class OrderRequestModel {
  final String menuTitle;
  final String buyersAddress;
  final String status;
  final String menuID;
  final String userId;
  final String username;

  final int menuPrice;
  final DateTime orderDate;
  bool? delivered = false;
  int? itemCount = 1;
  String? thumbnailUrl;

  OrderRequestModel({
    required this.userId,
    required this.username,
    required this.status,
    required this.menuTitle,
    required this.buyersAddress,
    required this.menuID,
    required this.menuPrice,
    required this.orderDate,
    this.thumbnailUrl,
    this.delivered,
    this.itemCount,
  });

  Map<String, dynamic> getJson() => {
        'status': status,
        "userId": userId,
        'username': username,
        'menuTitle': menuTitle,
        'itemCount': itemCount,
        'buyersAddress': buyersAddress,
        'menuID': menuID,
        'menuPrice': menuPrice,
        'orderDate': orderDate,
        'thumbnailUrl': thumbnailUrl,
        'delivered': delivered,
      };

  factory OrderRequestModel.getModelFromJson(
      {required Map<String, dynamic> json}) {
    return OrderRequestModel(
        status: json['status'],
        itemCount: json['itemCount'],
        menuTitle: json["orderName"],
        buyersAddress: json["buyersAddress"],
        menuID: json['menuID'],
        menuPrice: json['menuPrice'],
        orderDate: json['orderDate'],
        thumbnailUrl: json['thumbnailUrl'],
        delivered: json['delivered'],
        userId: json['userId'],
        username: json['username']);
  }
}
