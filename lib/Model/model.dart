class ProductModel {
  String? title;
  String? image;
  String? description;
  String? taxNo;
  String? price;
  String? discountPercentage;
  String? rating;
  String? stock;
  String? brand;
  String? category;
  List? imagesList;
  bool isSelected = false;

  ProductModel(
      {required this.title,
      required this.image,
      required this.description,
      required this.isSelected,
      required this.price,
      required this.category,
      required this.brand,
      required this.imagesList,
      required this.discountPercentage,
      required this.rating,
      required this.stock,
      required this.taxNo});

  factory ProductModel.fromJson(Map<String, dynamic> json) {

    return ProductModel(
      title: json['title'].toString(),
      image: json['thumbnail'].toString(),
      description: json['description'].toString(),
      taxNo: json['price'].toString(),
      isSelected: false,
      price: json['price'].toString(),
      category: json['category'].toString(),
      brand: json['brand'].toString(),
      imagesList: [],
      discountPercentage: json['discountPercentage'].toString(),
      rating: json['rating'].toString(),
      stock: json['stock'].toString(),
    );
  }
}
