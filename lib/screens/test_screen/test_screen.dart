import 'package:flutter/material.dart';
import 'package:karlekstanken/models/query.dart';
import 'package:karlekstanken/models/statement.dart';
import 'package:karlekstanken/screens/test_screen/widgets/animated_progress_bar.dart';
import 'package:karlekstanken/screens/test_screen/widgets/finish_page.dart';
import 'package:karlekstanken/screens/test_screen/widgets/query_page.dart';
import 'package:karlekstanken/screens/test_screen/widgets/start_page.dart';
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
  List<Query> _queries;

  @override
  void initState() {
    super.initState();

    List<Statement> statements = [
      Statement('1', 'hello', 'A'),
      Statement('2', 'Bye', 'B')
    ];
    List<Statement> statements2 = [
      Statement('A', 'muhaha', 'A'),
      Statement('B', 'asd', 'B')
    ];
    List<Statement> statements3 = [
      Statement('A', 'aw', 'D'),
      Statement('B', 'na', 'C')
    ];
    _queries = [
      Query('', statements),
      Query(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce facilisis leo arcu, id semper lorem congue ac. ',
          statements2),
      Query('', statements3),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        builder: (_) => new TestState(),
        child: Builder(
          builder: (BuildContext context) {
            TestState state = Provider.of<TestState>(context);
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
                      '$_pageIndex / ${_queries.length + 1}',
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
                    _pageIndex = pos;
                    _progress = pos / (_queries.length + 1);
                    /*  _pageIndex = pos - 1;
                    _progress = ((pos  - 1) / (_queries.length)); */
                  });
                },
                itemBuilder: (BuildContext context, int position) {
                  if (position == 0) {
                    return StartPage();
                  } else if (position == _queries.length + 1) {
                    return FinishPage();
                  } else {
                    return Column(
                      children: <Widget>[
                        Expanded(
                          child: QueryPage(_queries[position - 1]),
                        ),
                        Container(
                          padding: EdgeInsets.all(16),
                          alignment: Alignment.centerLeft,
                          child: FlatButton.icon(
                            icon: Icon(Icons.keyboard_arrow_left),
                            label: Text('Föregående'),
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
