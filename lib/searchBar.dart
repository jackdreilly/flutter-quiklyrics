import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:ql/remote.dart';

class SearchBar extends StatefulWidget {
  final RemoteBloc bloc;

  SearchBar(this.bloc);

  @override
  State<StatefulWidget> createState() {
    return _SearchBarState(bloc);
  }
}

class _SearchBarState extends State<SearchBar> {
  final FocusNode _focusNode = FocusNode();

  OverlayEntry _overlayEntry;

  final RemoteBloc bloc;

  final TextEditingController controller = TextEditingController();

  StreamBuilder<Suggestions> suggestionsBuilder;

  _SearchBarState(this.bloc);

  final initialSuggestions = Suggestions([]);

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        this._overlayEntry = this._createOverlayEntry();
        Overlay.of(context).insert(this._overlayEntry);
      } else {
        this._overlayEntry.remove();
      }
    });
    suggestionsBuilder = StreamBuilder<Suggestions>(
        stream: bloc.suggestionsOut.asBroadcastStream(),
        initialData: initialSuggestions,
        builder: (c, s) => suggestiontoWidget(s.data));
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);
    return OverlayEntry(
        builder: (context) => Positioned(
              left: offset.dx,
              top: offset.dy + size.height + 5.0,
              width: size.width,
              child: Material(
                elevation: 4.0,
                child: suggestionsBuilder,
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: this._focusNode,
      decoration: InputDecoration(
          hintText: 'Lyrics or Chords',
          prefixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
                bloc.lyricsIn.add(controller.text);
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  _focusNode.unfocus();
                });
            },
          ),
          suffixIcon: _focusNode.hasFocus || controller.text.isNotEmpty
          ? IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  _focusNode.unfocus();
                  controller.clear();
                });
              },
            )
          : null),
      controller: controller,
      onChanged: (t) {
        bloc.suggestIn.add(t);
      },
      onSubmitted: (t) {
        bloc.lyricsIn.add(t);
        setState(() {
          this._focusNode.unfocus();
        });
      },
    );
  }

  Widget suggestiontoWidget(Suggestions suggestions) {
    if (suggestions.suggestions.length == 0) {
      return Container();
    }
    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      children: suggestions.suggestions
          .map((s) => ListTile(
                title: Text(s),
                onTap: () {
                  bloc.suggestionTapIn.add(s);
                  setState(() {
                    print("Should unfocus");
                    this._focusNode.unfocus();
                    controller.text = s;
                  });
                },
              ))
          .toList(),
    );
  }
}
