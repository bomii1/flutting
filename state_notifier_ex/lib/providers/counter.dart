import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:state_notifier/state_notifier.dart';

import 'bg_color.dart';

class CounterState extends Equatable {
  final int counter;
  const CounterState({
    required this.counter,
  });

  @override
  List<Object> get props => [counter];

  @override
  bool get stringify => true;

  CounterState copyWith({
    int? counter,
  }) {
    return CounterState(
      counter: counter ?? this.counter,
    );
  }
}


// bgColor 의 state 에 따라 증가시키는 값이 달라짐
// CounterStateNotifier 는 bgColorStateNotifier 의 state 값을 읽을 수 있어야 함
// locator mixing
// 서비스 로케이터 -> 타입을 지정해서 특정 프로바이더를 찾을 수 있게 해줌
// 
class Counter extends StateNotifier<CounterState> with LocatorMixin {
  Counter() : super(const CounterState(counter: 0)); // 초기화

  void increment() { // 탭할 때마다 카운터를 증가시킬 
    print(read<BgColor>().state);

    Color currentColor = read<BgColor>().state.color; // 현재 컬러값 읽어옴
    // watch 는 쓸 수 없음 -> 이벤트 핸들러 내에서 state 를 계속 watch 해줄 필요 없음

    if (currentColor == Colors.black) {
      state = state.copyWith(counter: state.counter + 10);
    } else if (currentColor == Colors.red) {
      state = state.copyWith(counter: state.counter - 10);
    } else {
      state = state.copyWith(counter: state.counter + 1);
    }
  }

  @override
  void update(Locator watch) {
    print('in Counter StateNotifier: ${watch<BgColorState>().color}');
    print('in Counter StateNotifier: ${watch<BgColor>().state.color}');
    super.update(watch);
  }
}
 /*
 다른 오브젝트의 업데이트를 리스닝할 수 있게 해줌
 프록시프로바이더가 프로바이더에 대해서 하는 것과 동일하다
 근데 플러터에 대한 dependency 가 없다 => 플러터 외부에서도 쓸 수 있다, 위젯트리 밖에서도 쓸 수 있다
 업데이트 함수 내에서는 read 를 쓸 수 없다 => 업데이트 함수의 argument 를 이용해라
 
 */