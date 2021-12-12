import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/modules/home_page/cubit/cubit.dart';
import 'package:todo_app/modules/home_page/cubit/states.dart';
import 'package:todo_app/modules/home_page/home_page.dart';
import 'package:todo_app/shared/component.dart';
import 'package:flutter/services.dart';
import 'package:todo_app/shared/constant.dart';
import 'package:todo_app/shared/icon_broken.dart';

class AddNoteScreen extends StatelessWidget {
  AddNoteScreen({Key? key}) : super(key: key);

  String? color;
  List<String> colors = [
    theme == 'lightTheme' ? '#FFFFFF' : '#121212',
    '#2ab7ca',
    '#851e3e',
    '#fed766',
    '#fe8a71',
    '#e7d3d3'
  ];
  @override
  Widget build(BuildContext context) {
    TextEditingController noteController = TextEditingController();
    TextEditingController titleNoteController = TextEditingController();

    return BlocConsumer<TodoAppCubit, TodoAppStates>(
      listener: (context, state) {
        if (state is AppInsertDatabaseSuccessState) {
          navigateAndFinish(context, HomePage());
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(getTranslated(context, 'addNote_appBar_title')),
            backgroundColor: color != null
                ? HexColor(color!)
                : Theme.of(context).appBarTheme.backgroundColor,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: color != null
                  ? HexColor(color!)
                  : Theme.of(context)
                      .appBarTheme
                      .systemOverlayStyle
                      ?.statusBarColor,
            ),
            actions: [
              Builder(builder: (context) {
                return IconButton(
                    onPressed: () {
                      Scaffold.of(context)
                          .showBottomSheet<void>((BuildContext context) {
                        return Container(
                          height: 100,
                          decoration: const BoxDecoration(
                            border:
                                Border(top: BorderSide(color: Colors.black12)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 15),
                            child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        changeColor(context, colors[index]),
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const SizedBox(
                                          width: 15,
                                        ),
                                itemCount: colors.length),
                          ),
                        );
                      });
                    },
                    icon: const Icon(Icons.color_lens_outlined));
              }),
              IconButton(
                  onPressed: () {
                    /*   TodoAppCubit.get(context)
                        .addNote(text: noteController.text, color: color);*/
                    TodoAppCubit.get(context).insertToDatabase(
                      text: noteController.text,
                      title: titleNoteController.text,
                      color: color ?? '#FFFFFF',
                      dateTime: DateFormat.yMMMd().format(DateTime.now()),
                    );
                  },
                  icon: const Icon(Icons.check)),
              /*        IconButton(
                  onPressed: () {
                    TodoAppCubit.get(context).addNote(
                        text: noteController.text, color: color, uId: '$uId');
                  },
                  icon: const Icon(IconBroken.Edit)),*/
            ],
          ),
          body: Container(
            color: color != null
                ? HexColor(color!)
                : Theme.of(context).scaffoldBackgroundColor,
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
                      hintStyle:Theme.of(context).textTheme.subtitle1?.copyWith(fontSize: 17),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: noteController,
                      maxLines: 10,
                      decoration: InputDecoration(
                        hintStyle:Theme.of(context).textTheme.subtitle1 ,
                        hintText: getTranslated(
                            context, 'AddNote_textFormFiled_hint',),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget changeColor(BuildContext context, String itemColor) {
    // Color borderColor = Colors.black54;
    String borderColor = "4a443a";
    return InkWell(
      onTap: () {
        borderColor = "8addf5";
        color = itemColor;
        Navigator.pop(context);
        TodoAppCubit.get(context).emit(ChangeColorState());
      },
      child: Container(
        width: 50,
        decoration: BoxDecoration(
          border: Border.all(color: HexColor(borderColor), width: 1),
          color: HexColor(itemColor),
        ),
      ),
    );
  }
}
