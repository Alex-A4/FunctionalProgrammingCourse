/// Класс описывает стуктуру новости с короткой информацией
class News {
  final String title;
  final String description;
  final String imageUrl;
  final String pageUrl;
  final String postDate;

  News(
    this.title,
    this.description,
    this.imageUrl,
    this.postDate,
    this.pageUrl,
  );
}