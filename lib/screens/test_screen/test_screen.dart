import 'package:flutter/material.dart';
import 'package:karlekstanken/models/query.dart';
import 'package:karlekstanken/my_strings.dart';
import 'package:karlekstanken/screens/loading_screen/loading_screen.dart';
import 'package:karlekstanken/screens/test_screen/widgets/animated_progress_bar.dart';
import 'package:karlekstanken/screens/test_screen/widgets/finish_page.dart';
import 'package:karlekstanken/screens/test_screen/widgets/query_page.dart';
import 'package:karlekstanken/screens/test_screen/widgets/start_page.dart';
import 'package:karlekstanken/services/database.dart';
import 'package:provider/provider.dart';

// Shared state
class TestState extends ChangeNotifier {
  final PageController _controller = new PageController();

  List<Statement> _selected = [];

  List<Statement> get selected => _selected;

  void nextPage() async {
    await _controller.nextPage(
        duration: Duration(milliseconds: 400), curve: Curves.easeOut);
  }

  void previousPage() async {
    await _controller.previousPage(
        duration: Duration(milliseconds: 400), curve: Curves.easeOut);
  }
}

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int _pageIndex = 0;
  double _progress = 0;

  @override
  Widget build(BuildContext context) {
    DatabaseService dbService = Provider.of<DatabaseService>(context);

    return ChangeNotifierProvider(
        builder: (_) => new TestState(),
        child: FutureBuilder(
          future: dbService.getTestQueries(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.hasError) {
              return LoadingScreen();
            }

            TestState state = Provider.of<TestState>(context);

            List<Query> queries = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                title: Row(
                  children: <Widget>[
                    Expanded(
                      child: AnimatedProgressbar(
                        height: 10,
                        value: _progress,
                      ),
                    ),
                    Text(
                      '$_pageIndex / ${queries.length}',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                leading: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: PageView.builder(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                controller: state._controller,
                onPageChanged: (int pos) {
                  setState(() {
                    /*  _pageIndex = pos;
                    _progress = pos / (queries.length + 1); */
                    _pageIndex = pos - 1;
                    _progress = ((pos - 1) / (queries.length));
                  });
                },
                itemBuilder: (BuildContext context, int position) {
                  if (position == 0) {
                    return StartPage();
                  } else if (position == queries.length + 1) {
                    return FinishPage();
                  } else {
                    return Column(
                      children: <Widget>[
                        Expanded(
                          child: QueryPage(queries[position - 1]),
                        ),
                        Container(
                          padding: EdgeInsets.all(16),
                          alignment: Alignment.centerLeft,
                          child: FlatButton.icon(
                            icon: Icon(Icons.keyboard_arrow_left),
                            label: Text(MyStrings.previous),
                            onPressed: state.previousPage,
                          ),
                        )
                      ],
                    );
                  }
                },
              ),
            );
          },
        ));
  }
}
