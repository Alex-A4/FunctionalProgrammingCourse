/// Класс описывает структуру новости с полным контентом
class FullNews {
  final String headerImageUrl;
  final String title;
  final String text;
  final List<String> imageUrls;

  FullNews(this.headerImageUrl, this.title, this.text, this.imageUrls);
}
