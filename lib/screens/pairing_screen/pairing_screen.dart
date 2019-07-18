import 'package:flutter/material.dart';
import 'package:karlekstanken/models/other_user.dart';
import 'package:karlekstanken/models/user.dart';
import 'package:karlekstanken/my_cloud_functions_error_codes.dart';
import 'package:karlekstanken/my_strings.dart';
import 'package:karlekstanken/utils/validators.dart';
import 'package:karlekstanken/widgets/error_message.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:provider/provider.dart';

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
          case MyCloudFunctionsErrorCodes.ERROR_RECEIVER_EMAIL_IS_SENDERS:
            _sendingErrMsg = MyStrings.cannotSendPartnerReqToSelfMsg;
            break;
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

  void _respondPartnerRequest(bool accepted) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _cloudFunctions
          .getHttpsCallable(
              functionName:
                  accepted ? 'acceptPartnerRequest' : 'rejectPartnerRequest')
          .call();

      // success
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

  @override
  void initState() {
    super.initState();
    _cloudFunctions = CloudFunctions(region: 'europe-west1');
    _isLoading = false;
    //_sendingTextFieldController = new TextEditingController();
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
                    child: Builder(
                      builder: (context) {
                        User user = Provider.of<User>(context);
                        if (user == null) {
                          // should handel this another way
                          return SizedBox();
                        }

                        if (user.partner != null) {
                          OtherUser other = OtherUser.fromMap(user.partner);
                          return _Partners(other);
                        } else if (user.partnerRequestTo != null) {
                          OtherUser other =
                              OtherUser.fromMap(user.partnerRequestTo);
                          return _Sent(other, _cancelPartnerRequest);
                        } else if (user.partnerRequestFrom != null) {
                          OtherUser other =
                              OtherUser.fromMap(user.partnerRequestFrom);
                          return _Received(other, _respondPartnerRequest);
                        } else {
                          return _Sending(
                              user.email, _sendPartnerRequest, _sendingErrMsg);
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

class _Partners extends StatelessWidget {
  _Partners(this._user);

  final OtherUser _user;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        '${MyStrings.you} & ${_user.name} ${MyStrings.arePartners}',
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }
}

class _Sending extends StatefulWidget {
  _Sending(this._userEmail, this._sendPartnerRequest, this._errMsg);

  final String _userEmail;
  final void Function(String email) _sendPartnerRequest;
  final String _errMsg;

  @override
  __SendingState createState() => __SendingState();
}

class __SendingState extends State<_Sending> {
  String _errMsg;
  TextEditingController _controller = new TextEditingController();

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget._errMsg != widget._errMsg) {
      _errMsg = widget._errMsg;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: MyStrings.inputPartnerEmail,
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          _errMsg == null ? SizedBox() : ErrorMessage(_errMsg),
          RaisedButton(
            child: Text(MyStrings.sendRequest),
            onPressed: () {
              // validate if correct email format & email is not users own
              String email = _controller.text;
              if (email != widget._userEmail) {
                if (Validators.validateEmail(email)) {
                  setState(() {
                    _errMsg = null;
                  });
                  widget._sendPartnerRequest(email);
                } else {
                  setState(() {
                    _errMsg = MyStrings.invalidEmail;
                  });
                }
              } else {
                setState(() {
                  _errMsg = MyStrings.cannotSendPartnerReqToSelfMsg;
                });
              }
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
