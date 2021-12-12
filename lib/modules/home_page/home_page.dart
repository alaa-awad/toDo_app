import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:todo_app/models/note_model.dart';
import 'package:todo_app/modules/add_note/add_note.dart';
import 'package:todo_app/modules/home_page/cubit/cubit.dart';
import 'package:todo_app/modules/home_page/cubit/states.dart';
import 'package:todo_app/modules/setting/setting.dart';
import 'package:todo_app/modules/update_note/update_note.dart';
import 'package:todo_app/shared/component.dart';
import 'package:todo_app/shared/constant.dart';
import 'package:todo_app/shared/icon_broken.dart';

bool canDelete = false;

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  bool isEmpty = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoAppCubit, TodoAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
            backgroundColor: theme == 'lightTheme'
                ? HexColor('#fed766')
                : HexColor('008080'),
            onPressed: () {
              navigateTo(context, AddNoteScreen());
            },
            child: const Icon(Icons.add),
          ),
          appBar: AppBar(
            title: Text(
              getTranslated(context, 'HomePage_appBar_tittle'),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  canDelete = !canDelete;
                  TodoAppCubit.get(context).emit(StateChangeCanDelete());
                },
                icon: Icon(
                  IconBroken.Delete,
                  color: canDelete
                      ? Colors.red
                      : theme == 'lightTheme'
                          ? Colors.black
                          : Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  navigateTo(context, SettingScreen());
                },
                icon: const Icon(IconBroken.Setting),
              ),
            ],
          ),
          body: TodoAppCubit.get(context).notes.isEmpty
              ? Center(
                  child: Text(
                  getTranslated(context, 'homePage_text_noItem'),
                  style: Theme.of(context).textTheme.bodyText1,
                ))
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return itemNote(
                        TodoAppCubit.get(context).notes[index], context);
                  },
                  padding: const EdgeInsets.all(8),
                  itemCount: TodoAppCubit.get(context).notes.length,
                ),
        );
      },
    );
  }
}

Widget itemNote(NoteModel model, BuildContext context) {
  return Padding(
    padding: const EdgeInsetsDirectional.only(top: 8.0),
    child: Stack(
      children: [
        InkWell(
          onTap: () {
            navigateTo(context, UpdateNoteScreen(model));
          },
          child: Card(
            color: HexColor(model.color),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (model.title != null || model.title != '')
                    Center(
                        child: Text(
                      '${model.title}',
                      style: const TextStyle(fontSize: 19),
                    )),
                  Expanded(
                      child: Text(
                    model.text,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  )),
                  Align(
                      alignment: Alignment.center,
                      child: Text(model.dateTime ?? '')),
                ],
              ),
            ),
          ),
        ),
        if (canDelete != false)
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Align(
              alignment: AlignmentDirectional.topEnd,
              child: CircleAvatar(
                backgroundColor: Colors.red,
                radius: 20,
                child: IconButton(
                    onPressed: () {
                      TodoAppCubit.get(context).deleteData(uId: model.uId);
                    },
                    icon: const Icon(
                      IconBroken.Delete,
                      color: Colors.white,
                    )),
              ),
            ),
          ),
      ],
    ),
  );
}
