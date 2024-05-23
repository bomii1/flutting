import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
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
        // ChangeNotifier 와 다른 점은 타입을 2개 명시해야 한다는 것
        StateNotifierProvider<TodoFilter, TodoFilterState>(
          create: (context) => TodoFilter(),
        ),
        StateNotifierProvider<TodoSearch, TodoSearchState>(
          create: (context) => TodoSearch(),
        ),
        StateNotifierProvider<TodoList, TodoListState>(
          create: (context) => TodoList(),
        ),
        StateNotifierProvider<ActiveTodoCount, ActiveTodoCountState>(
          create: (context) => ActiveTodoCount(),
        ),
        StateNotifierProvider<FilteredTodos, FilteredTodosState>(
          create: (context) => FilteredTodos(),
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
현재의 투두앱은 데이터를 메모리에 저장하기 때문에 앱을 재실행하면 모든 데이터가 리셋됨
-> data persistence 기능이 필요함
1. local storage + sql database(sql)
-> 복잡한 설치 절차가 필요하지만 SQLFlite 를 사용하면 그런 절차가 필요없다
2. remote storage + Firebase(nosql)
3. 직접 서버와 데이터베이스를 구축하고 테스트 -> 개념테스트에 너무 해비함

async 오퍼레이션은 시간이 수반됨
In progress: CircularProgressIndicator
Error: Dialog

현재 투두앱은 모든 데이터를 한번에 읽어와서 구현함 -> 비현실적, 시간이 많이 걸림, 앱의 퍼포먼스 안 좋아짐
-> pagination
1. Traditional pagination -> 화면 하단에 페이지 번호를 표시하고 번호를 탭하면 해당 페이지로 이동
2. Infinite scrolling -> 사용자가 화면을 스크롤할 때 미리 정한 기준을 넘어가면 데이터를 불러오는 방식
어떤 방식을 사용할지는 데이터의 성격과 관련있음
인스타 같이 사용자가 최신 정보에 관심이 있는 경우 2 번이 적합
사용자가 특정 정보가 표시되는 페이지로 빠르게 이동하는 것을 선호하는 경우는 1 번이 적함
*/