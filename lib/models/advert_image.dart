class AdvertImageField {
  static final String createdAt = 'lastMessageTime';
}

class AdvertImage {
  final String? imageId;
  final String? advertId;
  final String? imageUrl;

  AdvertImage({
    this.imageId,
    this.advertId,
    this.imageUrl,
  });

  AdvertImage copyWith({
    String? imageId,
    String? advertId,
    String? imageUrl,
  }) =>
      AdvertImage(
        imageId: imageId ?? this.imageId,
        advertId: advertId ?? this.advertId,
        imageUrl: imageUrl ?? this.imageUrl,
      );

  static AdvertImage fromJson(Map<String, dynamic> json) => AdvertImage(
        imageId: json['imageId'],
        advertId: json['advertId'],
        imageUrl: json['imageUrl'],
      );

  Map<String, dynamic> toJson() => {
        'imageId': imageId,
        'advertId': advertId,
        'imageUrl': imageUrl,
      };
}
