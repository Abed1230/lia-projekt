import 'package:flutter/material.dart';
import 'package:karlekstanken/models/query.dart';
import 'package:provider/provider.dart';

import '../test_screen.dart';

class QueryPage extends StatelessWidget {
  QueryPage(this._query);

  final Query _query;

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<TestState>(context);

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _query.statements.map((statement) {
          bool selected = state.selected.contains(statement);

          return Container(
              margin: EdgeInsets.only(bottom: 16.0),
              child: InkWell(
                onTap: () {
                  // remove previously selected
                  _query.statements.forEach((st) {
                    state.selected.remove(st);
                  });

                  state.selected.add(statement);
                  state.nextPage();
                },
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: <Widget>[
                      Icon(selected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked),
                      SizedBox(
                        width: 16.0,
                      ),
                      Expanded(
                        child: Text(statement.text),
                      )
                    ],
                  ),
                ),
              ));
        }).toList(),
      ),
    );
  }
}
