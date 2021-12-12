import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/models/note_model.dart';
import 'package:todo_app/modules/home_page/cubit/cubit.dart';
import 'package:todo_app/modules/home_page/cubit/states.dart';
import 'package:todo_app/modules/home_page/home_page.dart';
import 'package:todo_app/shared/component.dart';
import 'package:flutter/services.dart';

class UpdateNoteScreen extends StatelessWidget {
  final NoteModel _noteModel;
  const UpdateNoteScreen(this._noteModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController noteController = TextEditingController();
    TextEditingController titleNoteController = TextEditingController();
    String color = _noteModel.color;

    return BlocConsumer<TodoAppCubit, TodoAppStates>(
      listener: (context, state) {
        if (state is AppUpdateDatabaseState) {
          //  TodoAppCubit.get(context).getDataFromDatabase(TodoAppCubit.get(context).database);
          navigateAndFinish(context, HomePage());
        }
      },
      builder: (context, state) {
        noteController.text = _noteModel.text;
        titleNoteController.text = '${_noteModel.title}';
        return Scaffold(
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: HexColor(color),
              statusBarIconBrightness: Brightness.light,
            ),
            title: Text(getTranslated(context, 'UpdateNote_appBar_title')),
            backgroundColor: HexColor(color),
            actions: [
              IconButton(
                  onPressed: () {
                    TodoAppCubit.get(context).updateData(
                      id: _noteModel.uId,
                      text: noteController.text,
                      title: titleNoteController.text,
                      dateTime: DateFormat.yMMMd().format(DateTime.now()),
                      color: color,
                    );
                  },
                  icon: const Icon(Icons.check))
            ],
          ),
          body: Container(
            color: HexColor(color),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: titleNoteController,
                    decoration: InputDecoration(
                      hintText:
                          getTranslated(context, 'AddNote_titleFormFiled_hint'),
                      border: InputBorder.none,
                      hintStyle: const TextStyle(fontSize: 17),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: noteController,
                      decoration: InputDecoration(
                        hintText: getTranslated(
                            context, 'AddNote_textFormFiled_hint'),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          color = '#2ab7ca';
                          TodoAppCubit.get(context).emit(ChangeColorState());
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          color: HexColor('#2ab7ca'),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      InkWell(
                        onTap: () {
                          color = '#851e3e';
                          TodoAppCubit.get(context).emit(ChangeColorState());
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          color: HexColor('#851e3e'),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      InkWell(
                        onTap: () {
                          color = '#fed766';
                          TodoAppCubit.get(context).emit(ChangeColorState());
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          color: HexColor('#fed766'),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      InkWell(
                        onTap: () {
                          color = '#fe8a71';
                          TodoAppCubit.get(context).emit(ChangeColorState());
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          color: HexColor('#fe8a71'),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      InkWell(
                        onTap: () {
                          color = '#e7d3d3';
                          TodoAppCubit.get(context).emit(ChangeColorState());
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          color: HexColor('#e7d3d3'),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
