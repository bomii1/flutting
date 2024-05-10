import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../models/todo_model.dart';
import 'providers.dart';

class FilteredTodosState extends Equatable {
  final List<Todo> filterdTodos;
  const FilteredTodosState({
    required this.filterdTodos,
  });

  factory FilteredTodosState.initial() {
    return const FilteredTodosState(filterdTodos: []);
  }

  @override
  List<Object> get props => [filterdTodos];

  @override
  bool get stringify => true;

  FilteredTodosState copyWith({
    List<Todo>? filterdTodos,
  }) {
    return FilteredTodosState(
      filterdTodos: filterdTodos ?? this.filterdTodos,
    );
  }
}

// state 가 변경될 때마다 리슨하는 위젯에게 값이 변경됐음을 알려줌
class FilteredTodos with ChangeNotifier {
  // FilteredTodosState _state = FilteredTodosState.initial();
  late FilteredTodosState _state;
  final List<Todo> initialFilteredTodos;
  FilteredTodos({
    required this.initialFilteredTodos,
  }) {
    print('initialFilteredTodos: $initialFilteredTodos');
    _state = FilteredTodosState(filterdTodos: initialFilteredTodos);
  }
  FilteredTodosState get state => _state;

  // proxyProvider 를 통해 value 를 받을 수 있음
  // 업데이트 함수 여러 번 호출됨 -> 의존하는 값을 처음 얻을 때 + 의존하는 값이 변할 때마다
  // 따라서 초기값 empty list 는 바로 업데이트 됨
  void update(
    TodoFilter todoFilter,
    TodoSearch todoSearch,
    TodoList todoList,
  ) {
    // ignore: no_leading_underscores_for_local_identifiers
    List<Todo> _filteredTodos; // 중간 계산 값을 저장할 변수

    switch (todoFilter.state.filter) {
      case Filter.active: // 
        _filteredTodos = todoList.state.todos.where((Todo todo) => !todo.completed).toList();
        break;
      case Filter.completed:
        _filteredTodos = todoList.state.todos.where((Todo todo) => todo.completed).toList();
        break;
      case Filter.all:
      default:
        _filteredTodos = todoList.state.todos;
        break;
    }

    // empty 가 아니면 사용자가 검색어를 입력한 것
    if (todoSearch.state.searchTerm.isNotEmpty) {
      _filteredTodos = _filteredTodos
          .where((Todo todo) =>
              todo.desc.toLowerCase().contains(todoSearch.state.searchTerm.toLowerCase()))
          .toList(); // 필터링해서 새로운 리스트 저장 
    }

    _state = _state.copyWith(filterdTodos: _filteredTodos); // 새로운 state 만듦
    notifyListeners();
  }
}
