class Review {
  final String senderName;
  final String description;
  final String raterId;
  final double rating;
  final String raterImage;
  final DateTime reviewDate;

  Review(
      {
       required this.reviewDate, 
        required this.raterId,
      required this.senderName,
      required this.description,
      required this.rating,
      required this.raterImage,
      });
  factory Review.fromJson({required Map<String, dynamic> json}) {
    return Review(
        senderName: json['senderName'],
        description: json['description'],
        rating:json['rating'] ,
        raterId: json['raterId'], raterImage: json['raterImage'], reviewDate: json['reviewDate'].toDate(),
        
        );
  }
  Map<String, dynamic> getJson() => {
    'reviewDate':reviewDate,
        'raterImage':raterImage,
        'senderName': senderName,
        'description': description,
        'rating': rating,
        'raterId': raterId,
      };
}
