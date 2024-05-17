import 'package:equatable/equatable.dart';
import 'package:state_notifier/state_notifier.dart';

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

class FilteredTodos extends StateNotifier<FilteredTodosState> with LocatorMixin {
  FilteredTodos() : super(FilteredTodosState.initial());

  // FilteredTodosState get state {
  //   // ignore: no_leading_underscores_for_local_identifiers
  //   List<Todo> _filteredTodos;

  //   switch (todoFilter.state.filter) {
  //     case Filter.active:
  //       _filteredTodos = todoList.state.todos.where((Todo todo) => !todo.completed).toList();
  //       break;
  //     case Filter.completed:
  //       _filteredTodos = todoList.state.todos.where((Todo todo) => todo.completed).toList();
  //       break;
  //     case Filter.all:
  //     default:
  //       _filteredTodos = todoList.state.todos;
  //       break;
  //   }

  //   if (todoSearch.state.searchTerm.isNotEmpty) {
  //     _filteredTodos = _filteredTodos
  //         .where((Todo todo) =>
  //             todo.desc.toLowerCase().contains(todoSearch.state.searchTerm.toLowerCase()))
  //         .toList();
  //   }

  //   return FilteredTodosState(filterdTodos: _filteredTodos);
  // }

  @override
  void update(Locator watch) {
    final Filter filter = watch<TodoFilterState>().filter;
    final String searchTerm = watch<TodoSearchState>().searchTerm;
    final List<Todo> todos = watch<TodoListState>().todos;

    // ignore: no_leading_underscores_for_local_identifiers
    List<Todo> _filteredTodos;

    switch (filter) {
      case Filter.active:
        _filteredTodos = todos.where((Todo todo) => !todo.completed).toList();
        break;
      case Filter.completed:
        _filteredTodos = todos.where((Todo todo) => todo.completed).toList();
        break;
      case Filter.all:
      default:
        _filteredTodos = todos;
        break;
    }

    if (searchTerm.isNotEmpty) {
      _filteredTodos = _filteredTodos
          .where((Todo todo) => todo.desc.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    }

    state = state.copyWith(filterdTodos: _filteredTodos);

    super.update(watch);
  }
}
