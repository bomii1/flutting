import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../models/todo_model.dart';

// 
class TodoListState extends Equatable {
  final List<Todo> todos;
  const TodoListState({
    required this.todos,
  });

  factory TodoListState.initial() {
    return TodoListState(todos: [
      Todo(id: '1', desc: 'Clean the room'),
      Todo(id: '2', desc: 'Wash the dish'),
      Todo(id: '3', desc: 'Do homework'),
    ]);
  }

  @override
  List<Object> get props => [todos];

  @override
  bool get stringify => true;

  TodoListState copyWith({
    List<Todo>? todos,
  }) {
    return TodoListState(
      todos: todos ?? this.todos,
    );
  }
}

// State 가 바뀔 때마다 리슨하는 위젯에게 값이 변경됐음을 알려줌
class TodoList with ChangeNotifier {
  TodoListState _state = TodoListState.initial();
  TodoListState get state => _state;

  // 기존의 투두에 새로운 투두를 add 하는 함수
  void addTodo(String todoDesc) {
    final newTodo = Todo(desc: todoDesc); // 새로운 투두 아이템 만들고 
    final newTodos = [..._state.todos, newTodo]; // 기존투두들 + 새로운투두 = 새로운 투두리스트를 만듦

    _state = _state.copyWith(todos: newTodos);
    print(_state);
    notifyListeners();
  }

  // 기존 투두 수정
  // 1. desc 를 변경 -> editTodo
  // 2. completed 의 상태 변경 -> toggleTodo
  void editTodo(String id, String todoDesc) { // edit 하고자하는 투두의 아이디와 새로운 디스크립션을 argument 로 받음
    final newTodos = _state.todos.map((Todo todo) { // 기존 투두를 스캔하면서 찾음
      if (todo.id == id) {
        return Todo(
          id: id,
          desc: todoDesc,
          completed: todo.completed,
        );
      }
      return todo; // 그렇지 않으면 기존 투두 리턴
    }).toList();

    _state = _state.copyWith(todos: newTodos); // 새로운 state 를 만듦
    notifyListeners();
  }

  void toggleTodo(String id) { // 토글하고자 하는 투두의 id 를 argument 로 받음
    final newTodos = _state.todos.map((Todo todo) { // 기존 투두 리스트 스캔하면서 찾음
      if (todo.id == id) {
        return Todo(
          id: id,
          desc: todo.desc,
          completed: !todo.completed, // 반대를 리턴
        );
      }
      return todo; // 그렇지 않은 경우 기존 투두 그대로 리턴
    }).toList();

    _state = _state.copyWith(todos: newTodos); // 새로운 state 만듦
    notifyListeners();
  }

  // 필요하지 않은 투두 삭제
  void removeTodo(Todo todo) { // 투두 자체를 argument 로 받음
    // where 함수로 기존 투두들을 스캔하면서 함수에 아규먼트로 넘어온 투두의 id 와 같지 않으면 리턴
    final newTodos = _state.todos.where((Todo t) => t.id != todo.id).toList();

    _state = _state.copyWith(todos: newTodos);
    notifyListeners();
  }
}
