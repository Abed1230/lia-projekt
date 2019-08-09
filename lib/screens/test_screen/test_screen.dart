import 'package:flutter/material.dart';
import 'package:karlekstanken/models/query.dart';
import 'package:karlekstanken/models/statement.dart';
import 'package:karlekstanken/screens/test_screen/widgets/query_page.dart';
import 'package:karlekstanken/screens/test_screen/widgets/start_page.dart';
import 'package:provider/provider.dart';

class TestState extends ChangeNotifier {
  final PageController _controller = new PageController();

  List<Statement> _selected = []; 

  List<Statement> get selected => _selected;

  /* set selected(Statement newValue) {
    _selected = newValue;
    notifyListeners();
  }    */

  void nextPage() async {
    await _controller.nextPage(
        duration: Duration(milliseconds: 500), curve: Curves.easeOut);
  }
}

// TODO: Convert to statless
class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {

  List<Query> _queries;

  @override
  void initState() {
    super.initState();

    List<Statement> statements = [
      Statement('A','hello', 'A'),
      Statement('B', 'Bye', 'B')
    ];
    List<Statement> statements2 = [
      Statement('A', 'muhaha', 'A'),
      Statement('B', 'asd', 'B')
    ];
    _queries = [Query('', statements), Query('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce facilisis leo arcu, id semper lorem congue ac. ', statements2)];
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
                title: Text('Progressbar here'),
                leading: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: PageView.builder(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                controller: state._controller,
                onPageChanged: (int position) {
                  //TODO: update progress value
                },
                itemBuilder: (BuildContext context, int position) {
                  if (position == 0) {
                    return StartPage();
                  } else if(position == _queries.length + 1) {
                    return Center(child: Text('Done!'));
                  } else {
                     return QueryPage(_queries[position - 1]);
                  }
                },
              ),
            );
          },
        ));
  }
}
