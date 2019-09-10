import 'package:flutter/material.dart';
import 'package:ql/bloc.dart';
import 'package:ql/remote.dart';

import 'searchBar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiklyrics',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Raleway",
      ),
      home: BlocProvider<RemoteBloc>(bloc: RemoteBloc(), child: MyHomePage()),
    );
  }
}

class MyHomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final RemoteBloc bloc = BlocProvider.of<RemoteBloc>(context);
    final searchBar = Material(elevation: 3, child: SearchBar(bloc));
    final typeChooser = TypeChooser(bloc);
    final form = searchBar;
    final initialLyrics = LyricsResponse.empty();
    final lyricsBuilder = StreamBuilder<LyricsResponse>(
        stream: bloc.lyricsOut,
        initialData: initialLyrics,
        builder: (c, s) => lyricsWidget(s.data));

    final loading = StreamBuilder<bool>(
        stream: bloc.loading.asBroadcastStream(),
        initialData: false,
        builder: (c, s) {
          return Visibility(
            child: LinearProgressIndicator(
              value: s.data ? null : 0,
              valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),
            ),
            visible: s.data,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
          );
        });

    final appBar = AppBar(
        bottom: PreferredSize(
            child: loading, preferredSize: Size(double.infinity, 5)),
        title: Row(children: [
          Text(
            "QuikLyrics",
            style: TextStyle(fontFamily: "TitilliumWeb"),
          ),
          Padding(child: typeChooser, padding: EdgeInsets.all(10))
        ]));

    final body = Padding(
      padding: EdgeInsets.all(10),
      child: Center(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          form,
          lyricsBuilder,
        ],
      )),
    );

    return Scaffold(appBar: appBar, body: body);
  }

  Widget lyricsWidget(LyricsResponse data) {
    return Flexible(
        child: Padding(
            padding: EdgeInsets.all(5),
            child: SingleChildScrollView(
                child: Column(children: [
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(data.lyrics.title,
                          style: TextStyle(fontSize: 20))),
                  Text(data.lyrics.lyrics,
                      style: TextStyle(
                          fontSize: data.isChords ? 9 : 15,
                          fontFamily: data.isChords ? "RobotoMono" : null,
                          height: data.isChords ? 1.8 : 1.6)),
                ]))));
  }
}

class TypeChooser extends StatelessWidget {
  final RemoteBloc bloc;

  TypeChooser(this.bloc);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LyricsType>(
        stream: bloc.lyricsOrChordsOut,
        initialData: LyricsType.LYRICS,
        builder: (c, s) => toWidget(s.data));
  }

  Widget toWidget(LyricsType lyricsType) {
    final isLyrics = lyricsType == LyricsType.LYRICS;
    final color = isLyrics ? Colors.white : Colors.blue;
    final bgColor = isLyrics ? Colors.blueGrey : Colors.white;
    final button = IconButton(
        icon: Icon(Icons.music_note),
        color: color,
        onPressed: () => bloc.lyricsOrChordsIn.add(isLyrics));
    final decoration = ShapeDecoration(color: bgColor, shape: CircleBorder());
    final ink = Ink(decoration: decoration, child: button);
    return ink;
  }
}
