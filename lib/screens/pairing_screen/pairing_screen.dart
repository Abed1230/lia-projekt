import 'package:flutter/material.dart';
import 'package:karlekstanken/models/user.dart';
import 'package:karlekstanken/my_strings.dart';
import 'package:karlekstanken/widgets/error_message.dart';

class PairingScreen extends StatefulWidget {
  
  @override
  _PairingScreenState createState() => _PairingScreenState();
}

class _PairingScreenState extends State<PairingScreen> {
  User _otherUser;
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
  void initState() {
    _otherUser = User(email: 'johndoe@mail.com', name: 'John Doe');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyStrings.pairingScreenTitle),
      ),
      body: Center(
        child: Padding(padding: EdgeInsets.all(8.0), child: _Received(_otherUser, _respondPartnerRequest)), //_Sending(_sendPartnerRequest, _SendingErrMsg),
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
  _Sent(this._user, this._cancelPartnerRequest);  

  User _user;
  void Function() _cancelPartnerRequest;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(MyStrings.waitingFor + ' ${_user.email} ' + MyStrings.toAccept),
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
  _Received(this._user, this._respondPartnerRequest);

  User _user;
  void Function(bool accepted) _respondPartnerRequest;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(_user.email + " " + MyStrings.receivedRequestMsg),
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
