import 'package:flutter/material.dart';
import 'package:karlekstanken/db_service_provider.dart';
import 'package:karlekstanken/models/other_user.dart';
import 'package:karlekstanken/models/user.dart';
import 'package:karlekstanken/my_cloud_functions_error_codes.dart';
import 'package:karlekstanken/my_strings.dart';
import 'package:karlekstanken/widgets/error_message.dart';
import 'package:cloud_functions/cloud_functions.dart';

class PairingScreen extends StatefulWidget {
  PairingScreen(this._uid);

  final String _uid;

  @override
  _PairingScreenState createState() => _PairingScreenState();
}

class _PairingScreenState extends State<PairingScreen> {
  CloudFunctions _cloudFunctions;

  bool _isLoading;
  String _sendingErrMsg;
  TextEditingController _sendingTextFieldController;

  void _sendPartnerRequest(String email) async {
    setState(() {
      _sendingErrMsg = null;
      _isLoading = true;
    });

    final HttpsCallable callable =
        _cloudFunctions.getHttpsCallable(functionName: 'sendPartnerRequest');

    try {
      //HttpsCallableResult res =
      await callable.call(<String, dynamic>{
        'email': email,
      });

      // partner request sent
      setState(() {
        _isLoading = false;
      });
    } on CloudFunctionsException catch (e) {
      print('code: ' + e.code + ' message: ' + e.message);
      setState(() {
        // important compare e.message instead of e.code
        switch (e.message) {
          case MyCloudFunctionsErrorCodes.ERROR_USER_NOT_FOUND:
            _sendingErrMsg = MyStrings.userNotFoundMsg;
            break;
          case MyCloudFunctionsErrorCodes.ERROR_RECEIVER_ALREADY_HAS_PARTNER:
            _sendingErrMsg = MyStrings.receiverHasPartnerMsg;
            break;
          case MyCloudFunctionsErrorCodes.ERROR_RECEIVER_HAS_PENDING_REQUEST:
            _sendingErrMsg = MyStrings.receiverHasRequestMsg;
            break;
          default:
            _sendingErrMsg = MyStrings.unknownErrorMsg;
        }
        _isLoading = false;
      });
    } catch (e) {
      print('code: ' + e.code + ' message: ' + e.message);
      setState(() {
        _sendingErrMsg = MyStrings.unknownErrorMsg;
        _isLoading = false;
      });
    }
  }

  void _cancelPartnerRequest() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _cloudFunctions
          .getHttpsCallable(functionName: 'cancelPartnerRequest')
          .call();

      // partner request canceled
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('code: ' + e.code + ' message: ' + e.message);
      // maybe show message?
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _respondPartnerRequest(bool accepted) {
    accepted ? print('accepting...') : print('declining...');
  }

  @override
  void initState() {
    super.initState();
    _cloudFunctions = CloudFunctions(region: 'europe-west1');
    _isLoading = false;
    _sendingTextFieldController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(MyStrings.pairingScreenTitle),
        ),
        body: Stack(
          children: <Widget>[
            Center(
                child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: StreamBuilder<User>(
                      stream: DatabaseServiceProvider.of(context)
                          .db
                          .streamUser(widget._uid),
                      builder:
                          (BuildContext context, AsyncSnapshot<User> snapshot) {
                        User user = snapshot.data;
                        // if user doesn't have a user document
                        if (user == null) {
                          // should handel this another way
                          return SizedBox();
                        }

                        if (user.partnerRequestTo != null) {
                          OtherUser other =
                              OtherUser.fromMap(user.partnerRequestTo);
                          return _Sent(other, _cancelPartnerRequest);
                        } else if (user.partnerRequestFrom != null) {
                          OtherUser other =
                              OtherUser.fromMap(user.partnerRequestFrom);
                          return _Received(other, _respondPartnerRequest);
                        } else {
                          return _Sending(_sendPartnerRequest, _sendingErrMsg,
                              _sendingTextFieldController);
                        }
                      },
                    ))),
                    _isLoading
                ? Center(child: CircularProgressIndicator())
                : SizedBox(),
          ],
        ));
  }
}

class _Sending extends StatelessWidget {
  _Sending(this._sendPartnerRequest, this._errMsg, this._controller);

  final void Function(String email) _sendPartnerRequest;
  final String _errMsg;
  final TextEditingController _controller;
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
          SizedBox(
            height: 8.0,
          ),
          _errMsg == null ? SizedBox() : ErrorMessage(_errMsg),
          RaisedButton(
            child: Text(MyStrings.sendRequest),
            onPressed: () {
              //FocusScope.of(context).requestFocus(new FocusNode());
              // todo: validate if correct email format
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

  final OtherUser _user;
  final void Function() _cancelPartnerRequest;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(MyStrings.waitingFor +
              ' ${_user.name} (${_user.email}) ' +
              MyStrings.toAccept),
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

  final OtherUser _user;
  final void Function(bool accepted) _respondPartnerRequest;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(_user.email + " " + MyStrings.receivedRequestMsg),
          SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
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
            ],
          )
        ],
      ),
    );
  }
}
