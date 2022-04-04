import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

/// Абстрактный класс, представляющий собой базовую единицу архитектуры BLOC,
/// основанной на реактивном подходе.
/// Для большей информации смотри [https://felangel.github.io/bloc/]
abstract class Bloc<Event, State> {
  /// Rx объект, хранящий состояния нашего блока
  /// [BehaviorSubject] был выбран с той целью, чтобы была возможность всегда
  /// получить последнее состояние.
  BehaviorSubject<State> _stateSubject;

  State get _currentState => _stateSubject.value;

  /// Rx объект, предоставляющий доступ к событиям, которые были отправлены
  /// в блок
  PublishSubject<Event> _eventSubject = PublishSubject();

  /// Поток состояний, на который смогу подписываться виджеты
  Stream<State> get state => _stateSubject.stream;

  /// Абстрактное начальное состояние для блока, которое отправляется слушателям
  /// до первых событий.
  /// Должно быть инициализировано наследником
  State get initialState;

  Bloc() {
    _stateSubject = BehaviorSubject.seeded(initialState);
    _bindStateSubject();
  }

  /// Закрытие всех потоков
  @mustCallSuper
  void dispose() {
    _stateSubject.close();
    _eventSubject.close();
  }

  /// Метод для передачи нового события в блок.
  /// События приходят только через этот метод.
  void dispatch(Event event) {
    _eventSubject.sink.add(event);
  }

  /// Абстрактный метод, который позволяет обрабатывать входящие события,
  /// возвращая соотвествующее для них состояние.
  /// Может быть асинхронным.
  Stream<State> mapEventToState(Event event);

  /// Функция для асинхронного расширения потока событий в поток состояний
  Stream<State> transform(
      Stream<Event> events,
      Stream<State> next(Event event),
      ) {
    return events.asyncExpand(next);
  }

  /// Метод для связывания потока событий и потока состояний.
  /// Каждое новое состояние отправляется в поток только в том случае, если
  /// оно не равно текущему.
  void _bindStateSubject() {
    transform(_eventSubject, (event) {
      return mapEventToState(event).handleError(_onError);
    }).forEach((state) {
      if (_currentState == state || _stateSubject.isClosed) return;

      _stateSubject.add(state);
    });
  }

  /// Метод для обработки ошибок, которые получаются на при работе метода [mapEventToState]
  void _onError(Object error, [StackTrace trace]) {}
}
