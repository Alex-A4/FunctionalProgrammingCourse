import 'package:rxdart/rxdart.dart';

import 'content_provider.dart';

/// Базовый класс хранилища данных
class Store<T> {
  final String basicUrl;

  BehaviorSubject<List<T>> _subject;

  Stream<List<T>> get stream => _subject.stream;

  final List<T> _data = [];

  Store({this.basicUrl}) {
    _subject = BehaviorSubject.seeded(_data);
  }

  void updateData(List<T> list) {
    _data.clear();
    _data.addAll(list);
    _subject.sink.add(_data);
  }

  void tryToLoad(String url) {
    if (_data.length == 0)
      ContentProvider.getInstance<T>()
          .fetchList(url)
          .then((list) => this.updateData(list))
          .catchError((e, trace) {
        print(e);
        print(trace);
        _subject.addError(e);
      });
  }

  void forceLoad(String url) {
    ContentProvider.getInstance<T>()
        .fetchList(url)
        .then((list) => this.updateData(list))
        .catchError((e, trace) {
      print(e);
      print(trace);
      _subject.addError(e);
    });
  }

  void dispose() {
    _data.clear();
    _subject.close();
  }
}
