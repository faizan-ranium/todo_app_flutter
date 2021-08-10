part of 'todos_cubit.dart';

@immutable
abstract class TodosState {}

class TodosInitial extends TodosState {}

class TodosLoaded extends TodosState {
  final List<Todo> todos;

  TodosLoaded({this.todos});

  Map<String, dynamic> toMap() {
    return {
      'todos': todos?.map((x) => x.toMap())?.toList(),
    };
  }

  factory TodosLoaded.fromMap(Map<String, dynamic> map) {
    return TodosLoaded(
      todos: List<Todo>.from(map['todos']?.map((x) => Todo.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory TodosLoaded.fromJson(String source) =>
      TodosLoaded.fromMap(json.decode(source));
}
