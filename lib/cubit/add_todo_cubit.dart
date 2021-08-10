import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:meta/meta.dart';
import 'package:todo_app/cubit/todos_cubit.dart';
import 'package:todo_app/data/models/todo.dart';
import 'package:todo_app/data/repository.dart';

part 'add_todo_state.dart';

class AddTodoCubit extends Cubit<AddTodoState> {
  final Repository repository;
  final TodosCubit todosCubit;
  final _connectivity = Connectivity();

  AddTodoCubit({this.repository, this.todosCubit}) : super(AddTodoInitial());
  void addTodo(String message) async {
    final connectivityStatus = await _connectivity.checkConnectivity();

    if (message.isEmpty) {
      emit(AddTodoError(error: "todo message is empty"));
      return;
    }

    final todo = Todo(id: 0, todoMessage: message, isCompleted: false);

    emit(AddingTodo());
    Timer(Duration(seconds: 2), () {
      todosCubit.addTodo(todo);
      if (connectivityStatus != ConnectivityResult.none) {
        repository.addTodo(message).then((todo) {
          if (todo != null) {
            emit(TodoAdded());
          }
        });
      } else {
        emit(TodoAdded());
      }
    });
  }
}
