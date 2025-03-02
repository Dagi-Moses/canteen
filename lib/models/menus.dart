

class Menus {
  final String menuID;
  final String menuTitle;

  final String menuInfo;
  final int menuPrice;
  final DateTime publishDate;
  final String thumbnailUrl;
  final String status;
  final double rating;
  final List likes;

  final List raters;
  final String category;
  int quantity;
  int? availableQuantity;

  Menus({
    
    required this.menuID,
    required this.menuInfo,
    required this.menuTitle,
    required this.menuPrice,
    required this.category,
    required this.publishDate,
    required this.status,
    required this.rating,
    required this.raters,
    required this.likes,
    required this.thumbnailUrl,
     this.quantity = 1, 
     this.availableQuantity
  });

  factory Menus.fromJson({required Map<String, dynamic> json}) {
    return Menus(
      menuID: json["menuID"],
      menuPrice: json["menuPrice"],
      menuInfo: json["menuInfo"],
      menuTitle: json["menuTitle"],
      publishDate: json['publishDate'].toDate(),
      status: json["status"],
      rating: json['rating'],
      raters: json['raters'],
      likes: json['likes'],
      thumbnailUrl: json["thumbnailUrl"],
      category: json['category'],
  
      quantity: json['quantity'] ?? 1,
      availableQuantity: json['availableQuantity'] ?? 50,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['title'] = menuTitle.toLowerCase();

    data["menuID"] = menuID;
    data["menuPrice"] = menuPrice;
    data["menuInfo"] = menuInfo;
    data["menuTitle"] = menuTitle;
    data["publishDate"] = publishDate;
    data["status"] = status;
    data['rating'] = rating;
    data['raters'] = raters;
    data['likes'] = likes;
    data['category'] = category;
    data["thumbnailUrl"] = thumbnailUrl;
    data["quantity"] = quantity;
    data["availableQquantity"] = availableQuantity;
    
    return data;
  }

   Menus copyWith({
    String? menuID,
    String? menuTitle,
    String? menuInfo,
    int? menuPrice,
    DateTime? publishDate,
    String? thumbnailUrl,
    String? status,
    double? rating,
    List? likes,
    List? raters,
    String? category,
    int? quantity,
    int? availableQuantity,
  }) {
    return Menus(
      menuID: menuID ?? this.menuID,
      menuInfo: menuInfo ?? this.menuInfo,
      menuTitle: menuTitle ?? this.menuTitle,
      menuPrice: menuPrice ?? this.menuPrice,
      publishDate: publishDate ?? this.publishDate,
      status: status ?? this.status,
      rating: rating ?? this.rating,
      raters: raters ?? List.from(this.raters), // Copy list to prevent mutations
      likes: likes ?? List.from(this.likes),   // Copy list to prevent mutations
      category: category ?? this.category,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      quantity: quantity ?? this.quantity,
      availableQuantity: availableQuantity ?? this.availableQuantity,
    );
  }

}
