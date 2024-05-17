import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';

class BgColorState extends Equatable {
  final Color color;

  const BgColorState({
    required this.color,
  });

  @override
  List<Object> get props => [color];

  @override
  bool get stringify => true;

  BgColorState copyWith({
    Color? color,
  }) {
    return BgColorState(
      color: color ?? this.color,
    );
  }
}


// ChangeNotifier 와 가장 큰 차이는 StateNotifier 가 핸들링할 state 의 타입을 표시한다는 점 -> <BGColorState>
class BgColor extends StateNotifier<BgColorState> {
  BgColor() : super(const BgColorState(color: Colors.blue)); // 초기화

  void changeColor() {
    if (state.color == Colors.blue) {
      state = state.copyWith(color: Colors.black);
    } else if (state.color == Colors.black) {
      state = state.copyWith(color: Colors.red);
    } else {
      state = state.copyWith(color: Colors.blue);
    }
  }
}

// 정의하지 않은 state 변수를 쓸 수 있음
// 이전에는 state 변수를 우리가 정의했지만, StateNotifier 내에서는 state 변수가 주어짐
// intialState 는 어떻게 정할 수 있나? 
// super 에 주는 값이 초기 state 값이다
// 초기 state 값을 외부에서 바꾸어줘야 한다면, BgColor 에 state 를 전달하고 그 값을 이용해 state 를 세팅한다
// state 를 변화시키고 나서 NotifierListeners 를 호출하지 않음
// 좋은 점: 다루는 state 의 값이 명확해짐, 초기 state 를 명확히 함, NotifierListeners 를 매번 호출해주지 않아도 됨
// 주목해야 할 점: state 변수에 StateNotifier 의 state 값이 저장된다는 것 
// -> state 변수를 통해 state 를 액세스하고 세팅할 수 있음

