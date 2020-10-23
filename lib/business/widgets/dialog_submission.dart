part of business_library;

/* 

1) Get rid of review screen
2) Add submit load button to add screen 
3) Add pop with true to submit button, but with dialog. dialog success or failure with continue button for return for pop or retry
4) Remove pop with true from back out button

Note) I really, really hate my review screen

*/


class _SubmitDialog extends StatefulWidget {
  const _SubmitDialog({
    Key key,
    @required this.submitFuture,
  })  : assert(submitFuture != null),
        super(key: key);

  final Future submitFuture;

  @override
  _SubmitDialogState createState() => _SubmitDialogState();
}

class _SubmitDialogState extends State<_SubmitDialog> {
  Future<dynamic> futureResult;

  EdgeInsetsGeometry contentPadding =
      const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0);

  double width = 100;
  double height = 100;

  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
   // final ThemeData theme = Theme.of(context);
   // final DialogTheme dialogTheme = DialogTheme.of(context);

    Widget _waitingResponse = Column(
      key: UniqueKey(),
      children: <Widget>[
        SizedBox(
          height: 100,
          width: 100,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Sending", style: TextStyle(fontSize: 16)),
              SizedBox(height: 24.0),
              SizedBox(
                  height: 50, width: 50, child: CircularProgressIndicator()),
            ],
          ),
        ),
      ],
    );

    Widget _successResponse(dynamic results) { return Container(
      child: Column(
        key: UniqueKey(),
        children: <Widget>[
          Expanded(
            flex: 2,
            child: CircleAvatar(
              backgroundColor: Colors.green,
              radius: 36,
              child: Icon(
                Icons.check,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
         SizedBox(
          height: 16,
        ),
          Expanded(
                      child: Text(
              "Success",
              style: TextStyle(fontSize: 32),
            ),
          ),
     
          Expanded(
                      child: Text(
              "Your submission was successful",
             // style: TextStyle(fontSize: 32),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                child: FlatButton(
                  color: Colors.green,
                  onPressed: () {
                    Navigator.pop(
                      context,
                      SubmissionResponse(
                          futureResult: results, submissionSuccess: true),
                    );
                  },
                  child: Text(
                    "Continue",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );}

    Widget _errorResponse(dynamic results){return Column(
      key: UniqueKey(),
      children: <Widget>[
        Expanded(
          flex: 2,
          child: CircleAvatar(
            backgroundColor: Colors.red,
            radius: 36,
            child: Icon(
              Icons.clear,
              size: 40,
              color: Colors.white,
            ),
          ),
        ),
        
        Expanded(
                  child: Text(
            "Oops!",
            style: TextStyle(fontSize: 32),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Expanded(
                  child: Text(
            "Your submission was not successful",
           // style: TextStyle(fontSize: 32),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: double.infinity,
              child: FlatButton(
                color: Colors.red,
                onPressed: () {
                  Navigator.pop(
                    context,
                    SubmissionResponse(
                        futureResult: results, submissionSuccess: false),
                  );
                },
                child: Text(
                  "Try Again",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );}

    dialogContent(BuildContext context) {
      return FutureBuilder(
        future: widget.submitFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          //List<Widget> children;
          Widget futureChild;
          

          switch (snapshot.connectionState) {
            case ConnectionState.none:

            case ConnectionState.active:
            case ConnectionState.waiting:
              futureChild = _waitingResponse;

              break;
            case ConnectionState.done:
              if (snapshot.hasError) {
                width = 300;
                height = 250;
                futureChild = _errorResponse(snapshot.data);
                //Scaffold.of(context).showSnackBar(SnackBar(content: Text('Submission Failed')));
              } else {
                width = 300;
                height = 250;
                futureChild = _successResponse(snapshot.data);
              }
          }

          return Center(
            child: 
                Container(
                  padding: contentPadding,
                  //  margin: EdgeInsets.only(top: _dAvatarRadius),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: const Offset(0.0, 10.0),
                      ),
                    ],
                  ),
                  child: AnimatedContainer(
                    width: width,
                    height: height,
                    child: futureChild,
                    duration: Duration(milliseconds: 100),
                  ),
                )
             
            
          ); // unreachable
        },
      );
    }

    //I don't want this widget to be dissmissed without a response
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Padding(
                    padding: contentPadding,
                    child: dialogContent(context),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class SubmissionResponse {
  final dynamic futureResult;
  final bool submissionSuccess;

  const SubmissionResponse(
      {@required this.futureResult, @required this.submissionSuccess})
      : 
        assert(submissionSuccess != null);
}

Future<SubmissionResponse> showSubmissionDialog({
  @required BuildContext context,
  @required Future onSubmitFuture,
  TransitionBuilder builder,
  bool useRootNavigator = true,
}) async {
  assert(context != null);
  assert(onSubmitFuture != null);
  assert(useRootNavigator != null);
  assert(debugCheckHasMaterialLocalizations(context));

  final Widget submitDialog = _SubmitDialog(submitFuture: onSubmitFuture);
  // final Widget submitContext = _SubmitContext(submitFuture: onSubmitFuture);

  return await showDialog(
    context: context,
    barrierDismissible: false,
    useRootNavigator: useRootNavigator,
    builder: (BuildContext context) {
      return builder == null ? submitDialog : builder(context, submitDialog);
    },
  );
}
