import 'package:state_notifier/state_notifier.dart';

import 'counter.dart';

enum Level {
  bronze,
  silver,
  gold,
}

// 현재 카운터 값에 따라 레벨이 정해짐 -> 일종의 computed state
class CustomerLevel extends StateNotifier<Level> with LocatorMixin {
  CustomerLevel() : super(Level.bronze);


  // 의존하는 다른 state 가 변경될 때마다 호출됨
  // 업데이트 함수 내에서 watch 를 통해 state 에 접근할 수 있음
  @override
  void update(Locator watch) {
    final currentCounter = watch<CounterState>().counter; // 카운터 state 값 읽어옴

    if (currentCounter >= 100) {
      state = Level.gold;
    } else if (currentCounter > 50 && currentCounter < 100) {
      state = Level.silver;
    } else {
      state = Level.bronze;
    }

    super.update(watch);
  }
}
