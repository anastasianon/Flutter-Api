import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/url.dart';
import '../models/finans.dart';
import '../cubit/finans_cubit.dart';
import '../interceptors/custom_interceptor.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerText = TextEditingController();
  TextEditingController controllerCategory = TextEditingController();
  TextEditingController controllerAmount = TextEditingController();
  GlobalKey<FormState> key = GlobalKey();
  SharedPreferences? sharedPreferences;
  Dio DIO = Dio();
  List<Note> notes = [];
  String filter = '';

  Future<void> initSharedPreferences() async =>
      sharedPreferences = await SharedPreferences.getInstance();

  void clearSharedPreferences() async => await sharedPreferences!.clear();

  String getTokenSharedPreferences() {
    return sharedPreferences!.getString('token')!;
  }

  Future<void> getNotes(String filter, String search) async {
    try {
      Response response = await DIO.get(URL.note.value,
          queryParameters: {'filter': filter, 'search': search});
      if (response.data['message'] == 'Финансовые отчеты не найдены') {
        context.read<NotesCubit>().clearNotes();
        return;
      }

      notes =
          (response.data['data'] as List).map((x) => Note.fromJson(x)).toList();

      context.read<NotesCubit>().setNotes(notes);
    } on DioError {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ошибка', textAlign: TextAlign.center)));
    }
  }

  Future<void> createNote() async {
    try {
      String name = controllerName.text;
      String text = controllerText.text;
      String category = controllerCategory.text;
      String amount = controllerAmount.text;

      await DIO.post(URL.note.value,
          data:
              Note(name: name, text: text, category: category, amount: amount));
    } on DioError {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ошибка', textAlign: TextAlign.center)));
    }
  }

  Future<void> updateNote(int number) async {
    try {
      String name = controllerName.text;
      String text = controllerText.text;
      String category = controllerCategory.text;
      String amount = controllerAmount.text;

      await DIO.put('${URL.note.value}/$number',
          data:
              Note(name: name, text: text, category: category, amount: amount));
    } on DioError {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ошибка', textAlign: TextAlign.center)));
    }
  }

  Future<void> deleteNote(int number) async {
    try {
      await DIO.delete('${URL.note.value}/$number');
    } on DioError {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ошибка', textAlign: TextAlign.center)));
    }
  }

  @override
  void initState() {
    super.initState();
    initSharedPreferences().then((value) async {
      String token = getTokenSharedPreferences();
      DIO.options.headers['Authorization'] = "Bearer $token";
      DIO.interceptors.add(CustomInterceptor());
      getNotes(filter, '');
    });
  }

  void showNoteDialog(Note? note) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Color.fromARGB(160, 200, 300, 400),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: SizedBox(
            width: 500,
            height: 600,
            child: Column(
              children: [
                Center(
                  child: Form(
                    key: key,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: controllerName,
                          validator: ((value) {
                            if (value == null || value.isEmpty) {
                              return "Наименование не должно быть пустым";
                            }
                            return null;
                          }),
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            labelStyle: TextStyle(color: Colors.black),
                            labelText: "Наименование",
                          ),
                        ),
                        const Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 5)),
                        TextFormField(
                          controller: controllerText,
                          validator: ((value) {
                            if (value == null || value.isEmpty) {
                              return "Текст не должен быть пустым";
                            }
                            return null;
                          }),
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            labelStyle: TextStyle(color: Colors.black),
                            labelText: "Текст",
                          ),
                        ),
                        const Padding(
                            padding: EdgeInsets.fromLTRB(25, 5, 25, 5)),
                        TextFormField(
                          controller: controllerCategory,
                          validator: ((value) {
                            if (value == null || value.isEmpty) {
                              return "Категория не должна быть пустой";
                            }
                            return null;
                          }),
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            labelStyle: TextStyle(color: Colors.black),
                            labelText: "Категория",
                          ),
                        ),
                        TextFormField(
                          controller: controllerAmount,
                          validator: ((value) {
                            if (value == null || value.isEmpty) {
                              return "Стоимость не должна быть пустой";
                            }
                            return null;
                          }),
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            labelStyle: TextStyle(color: Colors.black),
                            labelText: "Стоимость",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Center(
                    child: Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Color.fromARGB(160, 200, 300, 400),
                          ),
                          onPressed: () async {
                            if (!key.currentState!.validate()) return;
                            if (note == null) {
                              await createNote();
                            } else {
                              await updateNote(note.number!);
                            }
                            getNotes(filter, '');
                            controllerName.text = '';
                            controllerText.text = '';
                            controllerCategory.text = '';
                            Navigator.of(context).pop();
                          },
                          child: const Text("Сохранить"),
                        ),
                        const Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Color.fromARGB(160, 200, 300, 400),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Отмена"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(160, 200, 300, 400),
        foregroundColor: Colors.black,
        title: SizedBox(
          width: double.infinity,
          height: 40,
          child: Center(
            child: TextField(
              onSubmitted: (value) => getNotes(filter, value),
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.black),
                suffixIcon: PopupMenuButton(
                  tooltip: "Сортировка",
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Text("По удаленным"),
                      onTap: () {
                        filter = 'deleted';
                        getNotes(filter, '');
                      },
                    ),
                    PopupMenuItem(
                      child: const Text("По умолчанию"),
                      onTap: () {
                        filter = '';
                        getNotes(filter, '');
                      },
                    ),
                  ],
                  icon: const Icon(Icons.filter_alt, color: Colors.black),
                ),
                hintText: 'Поиск',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Color.fromARGB(160, 200, 300, 400),
      body: Center(
        child: BlocBuilder<NotesCubit, NotesState>(
          builder: (context, state) {
            if (state is UpdateNotes) {
              return ListView.builder(
                itemCount: state.notes.length,
                itemBuilder: (context, index) => Card(
                  color: Color.fromARGB(160, 200, 300, 400),
                  child: ListTile(
                    textColor: Colors.black,
                    leading: CircleAvatar(
                      backgroundColor: Color.fromARGB(160, 200, 300, 400),
                      child: Text(
                          (state.notes.elementAt(index).number).toString()),
                    ),
                    title: Text(state.notes.elementAt(index).text),
                    subtitle: Text(state.notes.elementAt(index).name),
                    trailing: PopupMenuButton(
                      tooltip: "Действия",
                      itemBuilder: (context) => [
                        if (state.notes.elementAt(index).status! != "true")
                          PopupMenuItem(
                            child: const Text("Изменить"),
                            onTap: () {
                              Note note = state.notes.elementAt(index);
                              controllerName.text = note.name;
                              controllerText.text = note.text;
                              controllerCategory.text = note.category;
                              controllerAmount.text = note.amount;
                              Future.delayed(const Duration(seconds: 0),
                                  () => showNoteDialog(note));
                            },
                          ),
                        PopupMenuItem(
                          child: const Text("Удалить"),
                          onTap: () async {
                            deleteNote(state.notes.elementAt(index).number!);
                            context.read<NotesCubit>().deleteNote(index);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const CircularProgressIndicator(
                color: Color.fromARGB(160, 200, 300, 400));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showNoteDialog(null),
        child: const Icon(Icons.add),
        focusColor: Colors.red,
        hoverColor: Colors.redAccent,
        backgroundColor: Color.fromARGB(255, 95, 12, 12),
      ),
    );
  }
}
