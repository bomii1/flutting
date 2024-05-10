import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/todos_page.dart';
import 'providers/providers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TodoFilter>(
          create: (context) => TodoFilter(),
        ),
        ChangeNotifierProvider<TodoSearch>(
          create: (context) => TodoSearch(),
        ),
        ChangeNotifierProvider<TodoList>(
          create: (context) => TodoList(),
        ),
        ChangeNotifierProxyProvider<TodoList, ActiveTodoCount>(
          create: (context) => ActiveTodoCount(
            initialActiveTodoCount: context.read<TodoList>().state.todos.length,
          ),
          update: (
            BuildContext context,
            TodoList todoList,
            ActiveTodoCount? activeTodoCount,
          ) =>
              activeTodoCount!..update(todoList),
        ),
        ChangeNotifierProxyProvider3<TodoFilter, TodoSearch, TodoList, FilteredTodos>(
          create: (context) => FilteredTodos(
            initialFilteredTodos: context.read<TodoList>().state.todos,
          ),
          update: (
            BuildContext context,
            TodoFilter todoFilter,
            TodoSearch todoSearch,
            TodoList todoList,
            FilteredTodos? filteredTodos,
          ) =>
              filteredTodos!..update(todoFilter, todoSearch, todoList),
        ),
      ],
      child: MaterialApp(
        title: 'TODOS',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const TodosPage(),
      ),
    );
  }
}

/*
state 를 다룰 때 준수하면 좋음
- state 는 가급적 atomic 하게 만듦
논리적으로 분리할 수 있으면 별도의 state 로 만들어서 관리
- state 는 주로 class 형태로 관리
논리적으로 연관된 값들을 묶어서 관리
string, int 등 primitive type 변수도 class 화 해서 관리 -> type 충돌을 피할 수 있는 장점
- Immutable state 
copyWith 함수를 사용해 새로운 state 만듦
- Always extends Equatable class
Object instance 들의 equality check 을 쉽게 할 수 있음
stringify 등의 편의 함수 제공
*/