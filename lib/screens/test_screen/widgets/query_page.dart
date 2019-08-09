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

    return Column(
      children: <Widget>[
        Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 16.0),
              alignment: Alignment.topLeft,
              child: Text(
                _query.text,
                style: TextStyle(fontSize: 16.0),
              ),
            )),
        Expanded(
            flex: 2,
            child: Container(
                margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Column(
              children: _query.statements.map((statement) {
                bool selected = state.selected.contains(statement);
                // neccessary for when navigating back to the this query
                state.selected.remove(statement);

                return Container(
                    margin: EdgeInsets.only(bottom: 16.0),
                    child: InkWell(
                      onTap: () {
                        if (!selected) state.selected.add(statement);
                        state.nextPage();
                      },
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 30,
                              height: 30,
                              padding: EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.black, width: 1.0),
                                  borderRadius: BorderRadius.circular(3.0)),
                              child: Center(
                                  child: Text(
                                statement.leading,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                            ),
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
            )))
      ],
    );
  }
}
