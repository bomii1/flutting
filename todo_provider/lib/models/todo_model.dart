import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = const Uuid(); // 유니크한 아이디 


// 새로운 투두를 만드는 경우 -> 기존 아이디 사용
// 기존 투두를 edit 하는 경우 -> 새로운 유니크 아이디 할당
class Todo extends Equatable {
  final String id;
  final String desc;
  final bool completed;
  Todo({
    String? id,
    required this.desc,
    this.completed = false,
  }) : id = id ?? uuid.v4(); 
  // ?? -> null 병합 연산자
  // id 가 null 이 아니면 id 왼쪽 값 반환, null 이면 오른쪽 값 반환

  @override
  List<Object> get props => [id, desc, completed];

  @override
  bool get stringify => true; // true -> 객체를 비교할 때 toString 메서드를 사용하여 문자열로 변환 후 비교
}

enum Filter {
  all,
  active,
  completed,
}
