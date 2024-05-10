import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../models/todo_model.dart';


// enum 형태로 만들 수도 있지만 가급적으로 class 형태로 만들어서 관리
// type collision 을 피할 수 있음 + equatable 을 subclassing 할 경우 class 에 string representation 을 시켜야 하는 장점
class TodoFilterState extends Equatable {
  final Filter filter;
  const TodoFilterState({
    required this.filter,
  });


  factory TodoFilterState.initial() {
    return const TodoFilterState(filter: Filter.all); // Filter.all -> 처음에 필터 안함
  }

  @override
  List<Object> get props => [filter];

  @override
  bool get stringify => true;

  TodoFilterState copyWith({
    Filter? filter,
  }) {
    return TodoFilterState(
      filter: filter ?? this.filter,
    );
  }
}

// State 가 바뀔 때마다 리슨하는 위젯에게 값이 변경되었다는 것을 알려줄 것임
class TodoFilter with ChangeNotifier {
  TodoFilterState _state = TodoFilterState.initial(); 
  TodoFilterState get state => _state; // State 에 대해서 외부에 접근할 수 있도록 + 일종의 세이프가드

  // State 를 변경하는 함수
  // copyWith 를 이용해서 필터의 값이 newFilter 라는 새로운 필터를 만들고 
  // notifyListener 를 이용해 리스너들에게 알려주는 역할 
  // all, active, complete 를 누를때마다 트리거 됨

  void changeFilter(Filter newFilter) { 
    _state = _state.copyWith(filter: newFilter);
    notifyListeners();
  }
}

/*
주목해야할 점은 새로운 state 를 만들 때 copyWith 를 사용함 
- copyWith 는 기존 값을 mutation 하지 않고 새로운 값을 만듦

*/
