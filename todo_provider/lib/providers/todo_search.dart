import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class TodoSearchState extends Equatable {
  final String searchTerm;
  const TodoSearchState({
    required this.searchTerm,
  });

  // 모든 state 를 다루는 데에 일관성을 지키는 것
  // type 의 충돌을 피할 수 있음
  factory TodoSearchState.initial() {
    return const TodoSearchState(searchTerm: '');
  }

  @override
  List<Object> get props => [searchTerm];

  @override
  bool get stringify => true;

  TodoSearchState copyWith({
    String? searchTerm,
  }) {
    return TodoSearchState(
      searchTerm: searchTerm ?? this.searchTerm,
    );
  }
}

// state 가 바뀔 때마다 리슨하는 위젯에게 값이 변경됐다는 것을 알려줄 클래스
class TodoSearch with ChangeNotifier {
  TodoSearchState _state = TodoSearchState.initial();
  TodoSearchState get state => _state;

  // state 를 변경하는 함수
  void setSearchTerm(String newSearchTerm) {
    _state = _state.copyWith(searchTerm: newSearchTerm); // 새로운 state 를 만듦
    notifyListeners();
  }
}

/*
검색량 줄이기
현재는 매 글자가 변할 때 마다 검색을 함 -> 이렇게 하면 너무 많은 데이터가 왔다갔다함
사용자가 일정 기간 글자를 더 누르지 않을 때 검색하도록
*/
