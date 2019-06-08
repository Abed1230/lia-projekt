import 'package:flutter/material.dart';
import 'package:karlekstanken/my_strings.dart';
import 'package:karlekstanken/widgets/error_message.dart';

class PairingScreen extends StatefulWidget {
  
  @override
  _PairingScreenState createState() => _PairingScreenState();
}

class _PairingScreenState extends State<PairingScreen> {
  String _SendingErrMsg;


  void _sendPartnerRequest(String email) {
    print('Sending request');
  }

  void _cancelPartnerRequest() {
    print('Canceling request...');
  }

  void _respondPartnerRequest(bool accepted) {
    accepted ? print('accepting...') : print('declining...');
  }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyStrings.pairingScreenTitle),
      ),
      body: Center(
        child: Padding(padding: EdgeInsets.all(8.0), child: _Sending(_sendPartnerRequest, _SendingErrMsg),//_Received('johndoe@mail.com', _respondPartnerRequest)),//)),
      ),
    );
  }
}

class _Sending extends StatelessWidget {
  _Sending(this._sendPartnerRequest, this._errMsg);

  final void Function(String email) _sendPartnerRequest;
  final String _errMsg;
  final TextEditingController _controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: MyStrings.inputPartnerEmail),
          ),
          SizedBox(height: 8.0,),
          _errMsg == null ? SizedBox() : ErrorMessage(_errMsg),
          RaisedButton(
            child: Text(MyStrings.sendRequest),
            onPressed: () {
              if (_controller.text.length > 0)
                _sendPartnerRequest(_controller.text);
            },
          )
        ],
      ),
    );
  }
}

class _Sent extends StatelessWidget {
  _Sent(this._userEmail, this._cancelPartnerRequest);  

  String _userEmail;
  void Function() _cancelPartnerRequest;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(MyStrings.waitingFor + ' $_userEmail ' + MyStrings.toAccept),
          RaisedButton(
            child: Text(MyStrings.cancel),
            onPressed: _cancelPartnerRequest,
          )
        ],
      ),
    );
  }
}

class _Received extends StatelessWidget {
  _Received(this._email, this._respondPartnerRequest);

  String _email;
  void Function(bool accepted) _respondPartnerRequest;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(_email + " " + MyStrings.receivedRequestMsg),
          SizedBox(height: 8.0,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
            RaisedButton(
              child: Text(MyStrings.accept),
              onPressed: () {
                _respondPartnerRequest(true);
              },
            ),
            RaisedButton(
              child: Text(MyStrings.decline),
              onPressed: () {
                _respondPartnerRequest(false);
              },
            )
          ],)
        ],
      ),
    );
  }
}
