import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../models/todo_model.dart';
import 'providers.dart';

class ActiveTodoCountState extends Equatable {
  final int activeTodoCount;
  const ActiveTodoCountState({
    required this.activeTodoCount,
  });

  factory ActiveTodoCountState.initial() {
    return const ActiveTodoCountState(activeTodoCount: 0);
  }

  @override
  List<Object> get props => [activeTodoCount];

  @override
  bool get stringify => true;

  ActiveTodoCountState copyWith({
    int? activeTodoCount,
  }) {
    return ActiveTodoCountState(
      activeTodoCount: activeTodoCount ?? this.activeTodoCount,
    );
  }
}

// state 가 바뀔 때마다 리슨하는 위젯에게 값이 변경됐다는 것을 알려줄 클래스
class ActiveTodoCount with ChangeNotifier {
  // ActiveTodoCountState _state = ActiveTodoCountState.initial();
  // ActiveTodoCountState 를 계산하려면 투두리스트 자체를 inspect 해야 함
  // 즉 투두 아이템 항목들의 completed 가 true 인지 false 인지 알아야 함 -> 투두리스트 state 값이 필요함
  late ActiveTodoCountState _state; 
  final int initialActiveTodoCount;
  ActiveTodoCount({
    required this.initialActiveTodoCount,
  }) {
    print('initialActiveTodoCount: $initialActiveTodoCount');
    _state = ActiveTodoCountState(activeTodoCount: initialActiveTodoCount);
  }
  ActiveTodoCountState get state => _state;

  // proxyProvider 를 통해서 
  // 여러 번 호출됨 -> 의존하는 값을 처음 얻을 때 + 의존하는 값이 변할 때마다
  // 초기값 0 은 바로 업데이트
  // 업데이트 함수는 호출될 때마다 completed 가 false 인 아이템들의 숫자를 계산
  void update(TodoList todoList) {
    print(todoList.state);
    final int newActiveTodoCount =
        todoList.state.todos.where((Todo todo) => !todo.completed).toList().length; // 엑티브한 것들의 길이를 구해서 

    _state = _state.copyWith(activeTodoCount: newActiveTodoCount); // 새로운 state 만듦
    print(state);
    notifyListeners();
  }
}
