import 'package:zoo_mobile/src/bloc/bloc.dart';
import 'package:zoo_mobile/src/content_providers/store.dart';
import 'package:zoo_mobile/src/models/manual/animals_category_data.dart';
import 'package:zoo_mobile/src/models/manual/manual_item.dart';
import 'package:zoo_mobile/src/models/news/news.dart';

import 'app.dart';

class AppBloc extends Bloc<AppBlocEvent, AppBlocState> {
  final newsStore = Store<News>(basicUrl: 'http://yar-zoo.ru/home/news.html');
  final categoryStore = Store<AnimalCategory>();
  final manualStore =
      Store<ManualItem>(basicUrl: 'http://yar-zoo.ru/animals.html');

  @override
  AppBlocState get initialState => NewsState();

  @override
  Stream<AppBlocState> mapEventToState(AppBlocEvent event) async* {
    if (event is InitAppEvent) {
      newsStore.forceLoad(newsStore.basicUrl);
      yield NewsState();
    }

    if (event is OpenAboutEvent) yield AboutState();

    if (event is OpenNewsEvent) {
      newsStore.tryToLoad(newsStore.basicUrl);
      yield NewsState();
    }

    if (event is OpenManualEvent) {
      manualStore.tryToLoad(manualStore.basicUrl);
      yield ManualState();
    }
  }

  @override
  void dispose() {
    newsStore.dispose();
    categoryStore.dispose();
    manualStore.dispose();
    super.dispose();
  }
}
