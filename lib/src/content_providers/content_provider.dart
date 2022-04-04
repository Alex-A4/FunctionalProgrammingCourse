import 'package:connectivity/connectivity.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:zoo_mobile/src/models/manual/animals.dart';
import 'package:zoo_mobile/src/models/manual/animals_category_data.dart';
import 'package:zoo_mobile/src/models/manual/manual_item.dart';
import 'package:zoo_mobile/src/models/news/full_news.dart';
import 'package:zoo_mobile/src/models/news/news.dart';

/// Провайдер для загрузки контента
abstract class ContentProvider<T> {
  static ContentProvider getInstance<T>() {
    if (T == AnimalCategory) return AnimalCategoryProvider();
    if (T == News) return NewsProvider();
    if (T == Animal) return AnimalProvider();
    if (T == FullNews) return FullNewsProvider();
    if (T == ManualItem) return ManualItemProvider();

    throw UnsupportedError(
        "The class $T is not supported by ContentProvider$getInstance");
  }

  /// Проверяет, имеется ли подключение к интернету.
  /// Если нет, то будет выброшено исключение
  Future<void> hasConnectivity() async {
    //Checking internet connection
    var connectivityResult = await (new Connectivity().checkConnectivity());

    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi)
      throw Exception('Отсутствует интернет соединение');
  }

  Future<List<T>> fetchList(String url);

  Future<T> fetchObject(String url);
}

class ManualItemProvider extends ContentProvider<ManualItem> {
  @override
  Future<List<ManualItem>> fetchList(String url) async {
    await hasConnectivity();

    //Getting data
    final response = await http.get(url);

    List<ManualItem> items = [];

    //Parsing data from page
    var elements =
        parse(response.body).getElementsByClassName('subcategory-image');

    for (int i = 0; i < elements.length; i++) {
      var body = elements[i].getElementsByTagName('a');

      String imageUrl =
          elements[i].getElementsByTagName('img')[0].attributes['src'];
      String description =
          body[0].attributes['title'].replaceFirst('<br/>', '\n');
      String pageUrl = 'http://yar-zoo.ru${body[0].attributes['href']}';

      items.add(new ManualItem(imageUrl, description, pageUrl));
    }

    return items;
  }

  @override
  Future<ManualItem> fetchObject(String url) {
    throw UnsupportedError(
        "$fetchObject(url) is not suppurted by $ManualItemProvider()");
  }
}

class AnimalCategoryProvider extends ContentProvider<AnimalCategory> {
  @override
  Future<List<AnimalCategory>> fetchList(String url) async {
    await hasConnectivity();

    final response = await http.get(url);

    List<AnimalCategory> animals = [];

    //Parsing data from page
    var body = parse(response.body).getElementsByClassName('item-image');

    for (int i = 0; i < body.length; i++) {
      String title = body[i].getElementsByTagName('a')[0].attributes['title'];
      String pageUrl = body[i].getElementsByTagName('a')[0].attributes['href'];
      String imageUrl =
          body[i].getElementsByTagName('img')[0].attributes['src'];

      animals.add(new AnimalCategory(pageUrl, imageUrl, title));
    }

    return animals;
  }

  @override
  Future<AnimalCategory> fetchObject(String url) async {
    throw UnsupportedError(
        "$fetchObject(url) is not suppurted by $AnimalCategoryProvider()");
  }
}

class NewsProvider extends ContentProvider<News> {
  /// Fetching news from web-site
  @override
  Future<List<News>> fetchList(String url) async {
    //Checking internet connection
    await hasConnectivity();

    final response = await http.get(url);

    List<News> news = [];

    //Parsing data from page
    var dateParse =
        parse(response.body).getElementsByClassName('element-itempublish_up');
    var descr = parse(response.body).getElementsByClassName('element-textarea');
    var docs = parse(response.body).getElementsByClassName('item-image');

    for (int i = 0; i < docs.length; i++) {
      var pageHref = docs[i].getElementsByTagName('a')[0].attributes['href'];
      var title = docs[i].getElementsByTagName('a')[0].attributes['title'];
      var image = docs[i].getElementsByTagName('img')[0].attributes['src'];
      var description = descr[i].getElementsByTagName('p')[0].text;
      var date = dateParse[i].text.trim();
      news.add(new News(title, description, image, date, pageHref));
    }

    return news;
  }

  @override
  Future<News> fetchObject(String url) {
    throw UnsupportedError(
        "$fetchObject(url) is not suppurted by $NewsProvider()");
  }
}

class AnimalProvider extends ContentProvider<Animal> {
  @override
  Future<List<Animal>> fetchList(String url) {
    throw UnsupportedError(
        "$fetchList(url) is not suppurted by $AnimalProvider()");
  }

  @override
  Future<Animal> fetchObject(String url) async {
    await hasConnectivity();

    final response = await http.get(url);

    Map<String, String> tabItems = new Map();
    var textAreas =
        parse(response.body).getElementsByClassName('element-textarea');
    var itemRows = parse(response.body)
        .getElementsByClassName('item-tabs')[0]
        .getElementsByTagName('ul')[0]
        .getElementsByTagName('li');
    var zooPlacement =
        parse(response.body).getElementsByClassName('element-text');

    //Is there right tagging
    int isRight = 1;
    String description = '';
    description +=
        '${zooPlacement[0].text.trim().replaceAll('<\/?[\w]+>', '')}\n';

    if (textAreas.length == itemRows.length) isRight = 0;

    //If there is right tagging then build description by the textArea
    //else by the zooPlacement
    if (isRight == 1) {
      var descrP = textAreas[0].getElementsByTagName('p');

      //Building description
      //Replace all tags to empty string
      for (int i = 0; i < descrP.length; i++)
        description += '${descrP[i].text.replaceAll('<\/?[\w]+>', '')}\n';
    } else {
      for (int i = 1; i < zooPlacement.length; i++)
        description +=
            '${zooPlacement[i].text.trim().replaceAll('<\/?[\w]+>', '')}\n';
    }

    //Building items of tab
    for (int i = 0; i < itemRows.length; i++) {
      String tabName = itemRows[i].getElementsByTagName('a')[0].text.trim();
      String tabText =
          textAreas[i + isRight].getElementsByTagName('p')[0].text.trim();

      tabItems['$tabName'] = tabText;
    }

    return new Animal(description.trim(), tabItems);
  }
}

class FullNewsProvider extends ContentProvider<FullNews> {
  @override
  Future<List<FullNews>> fetchList(String url) {
    throw UnsupportedError(
        "$fetchList(url) is not suppurted by $FullNewsProvider()");
  }

  @override
  Future<FullNews> fetchObject(String url) async {
    await hasConnectivity();

    final response = await http.get(url);

    List<String> imagesUrl = [];
    //Parsing data from page
    var titleAndImage =
        parse(response.body).getElementsByClassName('jbimage-link');
    var descr = parse(response.body)
        .getElementsByClassName('element-textarea')[0]
        .getElementsByTagName('p');
    var gallery =
        parse(response.body).getElementsByClassName('element-jbgallery');

    //Parsing gallery of photos if it is exist in a news
    if (gallery.length > 0) {
      gallery = gallery[0].getElementsByTagName('a');
      //Adding images to list
      for (int i = 0; i < gallery.length; i++)
        imagesUrl.add(gallery[i].attributes['href']);
    }

    var title = '';
    var image = '';
    if (titleAndImage.length != 0) {
      title = titleAndImage[0].attributes['title'];
      image = titleAndImage[0].attributes['href'];
    }
    //Building description
    String description = '';
    for (int i = 0; i < descr.length; i++) {
      description += descr[i].text + '\n';
    }

    FullNews news = new FullNews(image, title, description, imagesUrl);
    return news;
  }
}
