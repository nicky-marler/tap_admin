part of business_library;

class BusinessAddScreen extends StatefulWidget {
  static const routeName = '/business/add';

  @override
  _BusinessAddScreenState createState() => _BusinessAddScreenState();
}

class _BusinessAddScreenState extends State<BusinessAddScreen> {
  bool _isInit = true;

  final _formKey = GlobalKey<FormState>();
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final nameController = TextEditingController();

  bool _formSubmitFailed = false;
  bool _autoValidate = false;

  BusinessForm businessForm = BusinessForm();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _isInit = false;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void _validateAndReview(BuildContext context) async {
    // Validate returns true if the form is valid, otherwise false.
    if (_formKey.currentState.validate()) {
      setState(() {
        _formSubmitFailed = false;
        _formKey.currentState.save();
      });
      await businessForm
          .setLocation(); //Needing to add this function due to lat/long being taken out of Placemark
      final businessMap = businessForm.toMap();
      final submitFuture = Provider.of<BusinessProvider>(context, listen: false)
          .addBusiness(businessMap);

      final submissionResults = await showSubmissionDialog(
          context: context, onSubmitFuture: submitFuture);

      Navigator.of(context).pop(true);

      bool isSuccess = submissionResults.submissionSuccess;
      final results = submissionResults.futureResult as DocumentReference;

      print(isSuccess);
      print(results.id);
    } else {
      setState(() {
        _autoValidate = true;
        _formSubmitFailed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const sizedBoxSpace = SizedBox(height: 24);

    return WillPopScope(
      onWillPop: () async {
        final ConfirmAction action =
            await ConfirmationDialog.asyncConfirmDialog(context);
        if (action == ConfirmAction.ACCEPT) {
          return new Future(() => true);
        }
        return new Future(() => false);
      },
      child: Form(
        key: _formKey,
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  floating: true,
                  pinned: false,
                  snap: false,
                  forceElevated: innerBoxIsScrolled,
                  automaticallyImplyLeading: true,
                  title: Text('New Business'),
                  leading: Builder(
                    builder: (BuildContext context) {
                      return IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () async {
                          final ConfirmAction action =
                              await ConfirmationDialog.asyncConfirmDialog(
                                  context);
                          if (action == ConfirmAction.ACCEPT) {
                            Navigator.of(context).pop(false);
                          }
                        },
                      );
                    },
                  ),
                ),
              ];
            },
            body: new GestureDetector(
              onTap: () {
                //unfocus textfeild when tap anything else
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Scrollbar(
                child: SingleChildScrollView(
                  dragStartBehavior: DragStartBehavior.down,
                  // padding:
                  //     const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 18.0, left: 10, right: 10),
                        child: TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            filled: true,
                            hintText: "Name",
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            String result = value.trim();
                            if (result.isEmpty) {
                              return 'Please enter a name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            businessForm.name = value.trim().toUpperCase();
                          },
                        ),
                      ),
                      sizedBoxSpace,
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          // borderRadius: new BorderRadius.all(
                          //   new Radius.circular(15.0),
                          // ),
                        ),
                        child: FormLocationListTile(
                          //        placemark: businessForm.placemark,
                          context: context,
                          autovalidate: _autoValidate,
                          validator: (value) {
                            if (value == null) {
                              return 'Missing Placemark'; //This is copied code. Get rid of later
                            }
                            return null;
                          },
                          onSaved: (value) {
                            businessForm.placemark = value;
                          },
                        ),
                      ),
                      sizedBoxSpace,
                      //  Divider(),
                      Container(
                        child: ChangeNotifierProvider.value(
                          value: businessForm.operationalHoursProvider,
                          child: Consumer<OperationalHoursProvider>(
                            builder: (context, hoursEdit, _) {
                              return OperationalHoursList();
                            },
                          ),
                        ),
                      ),
                      sizedBoxSpace,
                      sizedBoxSpace,
                      sizedBoxSpace,
                      if (_formSubmitFailed)
                        Center(
                          child: Text(
                            "Error: Fix missing fields",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      SizedBox(height: 4),
                      Container(
                        //color: Colors.white,
                        height: 50,
                        // padding: const EdgeInsets.symmetric(horizontal: 100),
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: FlatButton(
                            color: Colors.blue,
                            // shape: new RoundedRectangleBorder(
                            //     borderRadius:
                            //         new BorderRadius.circular(30.0)),
                            child: Text(
                              "Submit",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () => _validateAndReview(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
