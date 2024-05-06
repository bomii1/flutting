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

  void update(
    TodoFilter todoFilter,
    TodoSearch todoSearch,
    TodoList todoList,
  ) {
    // ignore: no_leading_underscores_for_local_identifiers
    List<Todo> _filteredTodos;

    switch (todoFilter.state.filter) {
      case Filter.active:
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

    if (todoSearch.state.searchTerm.isNotEmpty) {
      _filteredTodos = _filteredTodos
          .where((Todo todo) =>
              todo.desc.toLowerCase().contains(todoSearch.state.searchTerm.toLowerCase()))
          .toList();
    }

    _state = _state.copyWith(filterdTodos: _filteredTodos);
    notifyListeners();
  }
}
