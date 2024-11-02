import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quitsmoke/size_config.dart';
import 'package:quitsmoke/static/lang.dart';
import 'package:quitsmoke/comps/getlang.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JournalScreen extends StatefulWidget {
  JournalScreen({Key key}) : super(key: key);

  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  String lang;

  List<String> Journals=[];

  void initState() {
    loadJournals();
    super.initState();
    lang = getLang();
  }

  void loadJournals() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String _reasons = pref.getString("journal");
    if (!_reasons.startsWith("[")) {
      Journals = [_reasons];
      pref.setString("journal", jsonEncode(Journals));
    } else {
      Journals = List<String>.from(jsonDecode(_reasons).map((x) => x));
    }
    setState(() {});
  }

  void saveReasons() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("journal", jsonEncode(Journals));
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: new IconButton(
        icon: new Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Hero(
            tag: "wallet",
            child: Icon(
              Icons.bolt,
              color: Colors.white,
              size: getProportionateScreenWidth(26),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            "${langs[lang]["home"]["journal"]}",
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                color: Colors.white, fontSize: getProportionateScreenWidth(26)),
          )
        ],
      ),
    );
  }

  bool _sheetopen = false;
  final scaffoldState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    List<List<String>> dividedList = [];

    if (Journals.length > 5) {
      for (int i = 0; i < Journals.length; i += 5) {
        List<String> sublist = Journals.sublist(i, i + 5 < Journals.length ? i + 5 : Journals.length);
        dividedList.add(sublist);
      }
    } else {
      dividedList.add(Journals);
    }
    SizeConfig().init(context);
    return Scaffold(
      key: scaffoldState,
      appBar: buildAppBar(context),
      floatingActionButton: floatingButton(context),
      backgroundColor: Colors.deepPurple,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        width: double.infinity,
        height: SizeConfig.screenHeight,
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 3,
              child: Center(
                child: Text("${langs[lang]["journal"]["somegoodjournals"]}",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline4.copyWith(
                        color: Colors.white.withAlpha(200),
                        fontWeight: FontWeight.w300,
                        fontSize: getProportionateScreenWidth(36))),
              ),
            ),
            /*if (Journals != null)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: dividedList.map((e) {
                    int startingIndex = dividedList.indexOf(e) * 5;
                   return Column(
                      children: e.asMap().entries.map((entry) {
                        int currentIndex = startingIndex + entry.key;
                        print(currentIndex);
                       // return renderListElement(currentIndex, context, key: ValueKey<String>('journal_$currentIndex'));
                       // return Text("${Journals[currentIndex]} $currentIndex");
                         Expanded(child: renderListElement(currentIndex, context));
                      }).toList(),
                    );
                  }).toList(),
                ),
              ),*/

                /*Row(
                  children: dividedList.map((e) => Column(
                    children: e.map((ee) =>Text(((dividedList.indexOf(e)*4)+e.indexOf(ee)).toString(),style: TextStyle(fontSize: 45),)
                       //renderListElement((dividedList.indexOf(e)*5)+e.indexOf(ee), context)
                        ).toList(),
                  )).toList(),
                ),*/

            if (Journals != null)
              Expanded(
                child: ListView.separated(

                  padding: EdgeInsets.only(bottom: 100, top: 10),
                  itemBuilder: (BuildContext context, int index) {
                  //  return Text(index.toString());
                    return renderListElement(index, context);
                  },
                  itemCount: Journals.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                ),
              ),

          ],
        ),
      ),
    );
  }

  String newReason = "";
  FloatingActionButton floatingButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        if (!_sheetopen)
          scaffoldState.currentState.showBottomSheet((context) => Container(
                padding: EdgeInsets.all(15),
                color: Colors.white,
                height: getProportionateScreenHeight(250),
                width: double.infinity,
                child: Column(children: [
                  Text(
                    "${langs[lang]["journal"]["addnew"]}",
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .copyWith(fontSize: getProportionateScreenWidth(22)),
                  ),
                  Divider(),
                  TextField(
                    onChanged: (value) => newReason = value,
                    maxLines: 3,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "${langs[lang]["journal"]["journal"]}"),
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .copyWith(fontSize: getProportionateScreenWidth(22)),
                  ),
                  ElevatedButton(
                    style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 20),
                        padding: EdgeInsets.all(8)),
                    child: Text("${langs[lang]["wallet"]["add"]}"),
                    onPressed: () {
                      _sheetopen = false;
                      Journals.add(newReason);
                      newReason = "";
                      saveReasons();
                      setState(() {});
                      Navigator.pop(context);
                    },
                  )
                ]),
              ));
        else
          Navigator.pop(context);
        _sheetopen = !_sheetopen;
      },
      child: Icon(Icons.add, color: Colors.green),
    );
  }

  Widget renderListElement(int index, BuildContext context) {
    return Dismissible(
      key:Key(Journals[index]),
      onDismissed: (direction) {
        Journals.removeAt(index);
        saveReasons();
      },
      confirmDismiss: (DismissDirection direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("${langs[lang]["misc"]["confirm"]}"),
              content: Text("${langs[lang]["misc"]["areusuredelete"]}"),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(
                      "${langs[lang]["misc"]["delete"]}",
                      style: TextStyle(color: Colors.red),
                    )),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text("${langs[lang]["misc"]["cancel"]}"),
                ),
              ],
            );
          },
        );
      },
      background: Container(
        padding: EdgeInsets.all(getProportionateScreenWidth(20)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32), color: Colors.red),
        child: Center(
          child: Text(
            "${langs[lang]["misc"]["delete"]}",
            style: TextStyle(
                color: Colors.white, fontSize: getProportionateScreenWidth(22)),
          ),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(getProportionateScreenWidth(20)),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: 10,
                  color: Colors.deepPurple[600],
                  spreadRadius: 2,
                  offset: Offset(3, 2))
            ],
            borderRadius: BorderRadius.circular(32),
            color: Colors.deepPurple[400]),
        child: Row(
          children: [
            Flexible(
              child: Text("${Journals[index]}",
                  style: Theme.of(context).textTheme.headline4.copyWith(
                      color: Colors.white.withAlpha(200),
                      fontWeight: FontWeight.w300,
                      fontSize: getProportionateScreenWidth(21))),
            )
          ],
        ),
      ),
    );
  }
}