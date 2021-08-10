import 'dart:async';

import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo_app/data/models/todo.dart';
import 'package:todo_app/data/repository.dart';

part 'todos_state.dart';

class TodosCubit extends Cubit<TodosState> with HydratedMixin {
  final Repository repository;
  final _connectivity = Connectivity();

  TodosCubit({this.repository}) : super(TodosInitial());

  void fetchTodos() async {
    final connectivityStatus = await _connectivity.checkConnectivity();
    print(connectivityStatus);
    Timer(Duration(seconds: 3), () {
      if (connectivityStatus != ConnectivityResult.none) {
        repository.fetchTodos().then((todos) {
          emit(TodosLoaded(todos: todos));
        });
      }
    });
  }

  void changeCompletion(Todo todo) {
    repository.changeCompletion(!todo.isCompleted, todo.id).then((isChanged) {
      if (isChanged) {
        todo.isCompleted = !todo.isCompleted;
        updateTodoList();
      }
    });
  }

  void updateTodoList() {
    final currentState = state;
    if (currentState is TodosLoaded)
      emit(TodosLoaded(todos: currentState.todos));
  }

  addTodo(Todo todo) {
    final currentState = state;
    if (currentState is TodosLoaded) {
      final todoList = currentState.todos;
      todoList.add(todo);
      emit(TodosLoaded(todos: todoList));
    }
  }

  void deleteTodo(Todo todo) {
    final currentState = state;
    if (currentState is TodosLoaded) {
      final todoList =
          currentState.todos.where((element) => element.id != todo.id).toList();
      emit(TodosLoaded(todos: todoList));
    }
  }

  @override
  TodosState fromJson(Map<String, dynamic> json) {
    return TodosLoaded.fromMap(json);
  }

  @override
  Map<String, dynamic> toJson(TodosState state) {
    if (state is TodosLoaded) {
      return state.toMap();
    }

    return null;
  }
}
