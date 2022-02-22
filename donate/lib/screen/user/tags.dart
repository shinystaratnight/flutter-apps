import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';


class TagsClass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FlutterTagExample(),
    );
  }
}

class FlutterTagExample extends StatefulWidget {
//  List<String> listOfTags = [];

  @override
  _FlutterTagExampleState createState() => _FlutterTagExampleState();
}

class _FlutterTagExampleState extends State<FlutterTagExample> {
  List<String> tagsList = ['apple', 'banana', 'orange', 'kiwi', ''];
  List<String> selectedTags = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 200,
            ),
            TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                  onSubmitted: (val) {
                    print('runtimetype of val is ${val.runtimeType}');
                    _addSuggestion(val);

                  }
              ),
              hideOnLoading: true,
              hideOnEmpty: true,
              getImmediateSuggestions: false,
              onSuggestionSelected: (val) {
                _onSuggestionSelected(val);
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(
                    suggestion,
                  ),
                );
              },
              suggestionsCallback: (val) {
                return _sugestionList(
                  tags: tagsList,
                  suggestion: val,
                );
//                return ;
              },
            ),
            SizedBox(
              height: 20,
            ),
            _generateTags()
          ],
        ),
      ),
    );
  }

  _onSuggestionRemoved(String value) {
    final String exists =
    selectedTags.firstWhere((text) => text == value, orElse: () {
      return null;
    });
    if (exists != null) {
      setState(() {
        selectedTags.remove(value);
        tagsList.add(value);
      });
    }
  }
  _addSuggestion(String value) {
    final String exists = tagsList.firstWhere((text) => text ==value,orElse: () {return null;});
    if(exists !=null) {
      final String isAlreadyInSelectedList = selectedTags.firstWhere((text) => text ==value,orElse: () {return null;});
      if(isAlreadyInSelectedList ==null) {
        setState(() {
          selectedTags.add(value);
          tagsList.remove(value);
        });
      }
    }
    else {
      final String isAlreadyInSelectedList = selectedTags.firstWhere((text) => text==value,orElse: () {return null;});
      if(isAlreadyInSelectedList ==null) {
        setState(() {
          selectedTags.add(value);
//          tagsList.add(value);
        });
      }
    }
  }

  _onSuggestionSelected(String value) {
    final String exists =
    tagsList.firstWhere((text) => text == value, orElse: () {
      return null;
    });
    if (exists != null) {
      final String isAlreadyInSelectedList =
      selectedTags.firstWhere((text) => text == value, orElse: () {
        return null;
      });

      if (isAlreadyInSelectedList == null) {
        setState(() {
          selectedTags.add(value);
          tagsList.remove(value);
        });
      }
    }
  }

  _sugestionList({@required List<String> tags, @required String suggestion}) {
    List<String> modifiedList = [];
    modifiedList.addAll(tags);
    modifiedList.retainWhere(
            (text) => text.toLowerCase().contains(suggestion.toLowerCase()));
    if (suggestion.length >= 2) {
      return modifiedList;
    } else {
      return null;
    }
  }

  _generateTags() {
    return selectedTags.isEmpty
        ? Container()
        : Container(
      alignment: Alignment.topLeft,
      child: Tags(
        alignment: WrapAlignment.center,
        itemCount: selectedTags.length,
        itemBuilder: (index) {
          return ItemTags(
            index: index,
            title: selectedTags[index],
            color: Colors.blue,
            activeColor: Colors.red,
            onPressed: (Item item) {
              print('pressed');
            },
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            elevation: 0.0,
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
//                textColor: ,
            textColor: Colors.white,
            textActiveColor: Colors.white,
            removeButton: ItemTagsRemoveButton(
                color: Colors.black,
                backgroundColor: Colors.transparent,
                size: 14,
                onRemoved: () {
                  _onSuggestionRemoved(selectedTags[index]);
                  return true;
                }),
            textOverflow: TextOverflow.ellipsis,
          );
        },
      ),
    );
  }
}