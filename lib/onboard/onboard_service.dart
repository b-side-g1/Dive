import 'package:flutter/material.dart';

class Counter with ChangeNotifier {
  int _counter;

  Counter(this._counter);

  getCounter() => _counter;

  setCounter(int counter) => _counter = counter;

  void increment() {
    _counter++;
    notifyListeners(); // 값이 변할 때마다 플러터 프레임워크에 알려줍니다.
  }

  void decrement() {
    _counter--;
    notifyListeners(); // 값이 변할 때마다 플러터 프레임워크에 알려줍니다.
  }
}
