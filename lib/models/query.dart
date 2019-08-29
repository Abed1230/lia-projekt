class Query {
  final List<Statement> statements;

  Query(this.statements);

  factory Query.fromMap(Map data) {
    return Query(data['statements'].map<Statement>((statement) {
      return Statement.fromMap(statement);
    }).toList());
  }
}

class Statement {
  final String text;
  final String value;

  Statement({this.text, this.value});

  factory Statement.fromMap(Map data) {
    return Statement(text: data['text'] ?? '', value: data['value'] ?? '');
  }

  @override
  String toString(){
    return '$text $value';
  }
}
