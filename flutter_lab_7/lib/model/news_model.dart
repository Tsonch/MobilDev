
class News {
  final String title;
  final String description;
  final String img;
  final List category;
  final DateTime date;

  News({
    required this.title,
    required this.description,
    required this.img,
    required this.category,
    required this.date
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json['title'], 
      description: json['description'], 
      img: json['image'], 
      category: (json['category']).map((category) => category.toString()).toList(), 
      date: DateTime.parse(json['published'])
    );
  }
}