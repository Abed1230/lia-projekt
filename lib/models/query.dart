import 'package:karlekstanken/models/statement.dart';

class Query {
  String text;
  List<Statement> statements;

  Query(this.text, this.statements);
}