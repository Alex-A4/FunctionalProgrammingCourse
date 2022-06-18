import 'package:rxdart/rxdart.dart';

import 'content_provider.dart';

/// Базовый класс хранилища данных единичного объекта
class StoreSingle<T> {
  final String basicUrl;

  BehaviorSubject<T> _subject;

  Stream<T> get stream => _subject.stream;

  T _data;

  StoreSingle({this.basicUrl}) {
    _subject = BehaviorSubject();
  }

  void updateData(T data) {
    _data = data;
    _subject.sink.add(_data);
  }

  void tryToLoad() {
    if (_data == null)
      ContentProvider.getInstance<T>()
          .fetchObject(basicUrl)
          .then((list) => this.updateData(list))
          .catchError((e, trace) {
        _subject.addError(e);
      });
  }

  void forceLoad() {
    ContentProvider.getInstance<T>()
        .fetchObject(basicUrl)
        .then((list) => this.updateData(list))
        .catchError((e, trace) {
      _subject.addError(e);
    });
  }

  void dispose() {
    _data = null;
    _subject.close();
  }
}
