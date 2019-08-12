import 'package:flutter/material.dart';
import 'package:karlekstanken/models/statement.dart';
import 'package:karlekstanken/my_strings.dart';
import 'package:provider/provider.dart';

import '../test_screen.dart';

class FinishPage extends StatefulWidget {
  @override
  _FinishPageState createState() => _FinishPageState();
}

class _FinishPageState extends State<FinishPage> {
  int _selected = -1;

  List<String> calculateLoveLanguage(List<Statement> selectedStatements) {
    Map<String, int> lettersCount = selectedStatements
        .fold({'A': 0, 'B': 0, 'C': 0, 'D': 0, 'E': 0}, (result, statement) {
      String letter = statement.value;
      switch (letter) {
        case 'A':
          result['A'] = result['A'] + 1;
          break;
        case 'B':
          result['B'] = result['B'] + 1;
          break;
        case 'C':
          result['C'] = result['C'] + 1;
          break;
        case 'D':
          result['D'] = result['D'] + 1;
          break;
        case 'E':
          result['E'] = result['E'] + 1;
          break;
      }
      return result;
    });

    List<String> loveLanguages = [];
    int largest = 0;
    lettersCount.forEach((letter, count) {
      if (count > largest) {
        largest = count;
        loveLanguages = [letter];
      } else if (count == largest) {
        largest = count;
        loveLanguages.add(letter);
      }
    });

    return loveLanguages;
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<TestState>(context);

    List<String> loveLanguages = calculateLoveLanguage(state.selected);
    print(loveLanguages.length);
    bool hasMultipleLoveLanguages = loveLanguages.length > 1;

    // TODO: get love language info from db

    return hasMultipleLoveLanguages
        ? Center(
            child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(MyStrings.finishPageTitle2,
                            style: TextStyle(fontSize: 18)),
                        SizedBox(
                          height: 16,
                        ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: loveLanguages.length,
                          itemBuilder: (context, position) {
                            return RadioListTile(
                              title: Text(loveLanguages[position]),
                              subtitle: Text('Description'),
                              value: position,
                              groupValue: _selected,
                              onChanged: (value) {
                                setState(() {
                                  _selected = value;
                                });
                              },
                            );
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(MyStrings.chooseLoveLanguageMsg),
                        SizedBox(
                          height: 16,
                        ),
                        RaisedButton(
                          child: Text(MyStrings.saveAndQuit),
                          onPressed: _selected < 0 ? null : () {
                            // TODO: Save to db 
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ))))
        : Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(MyStrings.finishPageTitle1,
                    style: TextStyle(fontSize: 18)),
                SizedBox(
                  height: 16,
                ),
                Text(
                  loveLanguages[0],
                  style: TextStyle(fontSize: 16.0),
                ),
                Text('description', style: TextStyle(color: Colors.grey),),
                SizedBox(
                  height: 16,
                ),
                RaisedButton(
                  child: Text(MyStrings.quit),
                  onPressed: () {
                    // TODO: Save to db
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }
}
