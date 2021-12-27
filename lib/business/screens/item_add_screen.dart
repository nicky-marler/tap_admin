part of business_library;

class ItemAddScreen extends StatefulWidget {
  static const routeName = '/business/item/add';

  @override
  _ItemAddScreenState createState() => _ItemAddScreenState();
}

class _ItemAddScreenState extends State<ItemAddScreen> {
  bool _isInit = true;
  Business business;

  final _formKey = GlobalKey<FormState>();
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final nameController = TextEditingController();
  final detailsController = TextEditingController();

  bool _autoValidate = false;

  ItemForm itemForm;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _isInit = false;
      business = Provider.of<BusinessProvider>(context, listen: false)
          .selectedBusiness;
      itemForm = ItemForm(business: business);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  void _validateAndReview(BuildContext context) async {
    // Validate returns true if the form is valid, otherwise false.
    if (_formKey.currentState.validate() && itemForm.validateSelectedDays) {
      setState(() {
        _formKey.currentState.save();
      });

      //final itemMap = itemForm.toMap();

      final itemMapList = itemForm.toMapList();

      final submitFuture = Provider.of<BusinessProvider>(context, listen: false)
          .addItems(itemMapList);

      final submissionResults = await showSubmissionDialog(
          context: context, onSubmitFuture: submitFuture);
      Navigator.of(context).pop(true);

      bool isSuccess = submissionResults.submissionSuccess;
      //final results = submissionResults.futureResult as DocumentReference;

    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  String get dayHeader {
    String dayResults = "";
    bool _isFirst = true;

    void _getComma() {
      if (_isFirst) {
        _isFirst = false;
      } else {
        dayResults += ", ";
      }
    }

    if (itemForm.isSelectedSunday) {
      _getComma();
      dayResults += "Sunday";
    }
    if (itemForm.isSelectedMonday) {
      _getComma();
      dayResults += "Monday";
    }
    if (itemForm.isSelectedTuesday) {
      _getComma();
      dayResults += "Tuesday";
    }
    if (itemForm.isSelectedWednesday) {
      _getComma();
      dayResults += "Wednesday";
    }
    if (itemForm.isSelectedThursday) {
      _getComma();
      dayResults += "Thursday";
    }
    if (itemForm.isSelectedFriday) {
      _getComma();
      dayResults += "Friday";
    }
    if (itemForm.isSelectedSaturday) {
      _getComma();
      dayResults += "Saturday";
    }

    return dayResults;
  }

//Handle reoccuring days?

  @override
  Widget build(BuildContext context) {
    const sizedBoxSpace = SizedBox(height: 24);

    Widget _missingDays() {
      if (_autoValidate && !itemForm.validateSelectedDays) {
        return Text(
          "Select day(s)",
          style: TextStyle(
            color: Colors.red,
          ),
        );
      }
      return Container(
        child: Wrap(children: [Text(dayHeader)]),
      );
    }

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
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: Text('New Item'),
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () async {
                    final ConfirmAction action =
                        await ConfirmationDialog.asyncConfirmDialog(context);
                    if (action == ConfirmAction.ACCEPT) {
                      Navigator.of(context).pop(true);
                    }
                  },
                );
              },
            ),
          ),
          body: new GestureDetector(
            onTap: () {
              //unfocus textfeild when tap anything else
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              String result = value.trim();
                              if (result.isEmpty) {
                                return 'Please enter a name';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              itemForm.name = value.trim().toUpperCase();
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 18.0, left: 10, right: 10),
                          child: TextFormField(
                            controller: detailsController,
                            decoration: InputDecoration(
                              filled: true,
                              hintText: "Details",
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              String result = value.trim();
                              if (result.isEmpty) {
                                return 'Please enter the details';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              itemForm.details = value.trim().toUpperCase();
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 18.0, left: 10, right: 10),
                          child: Container(
                            child: Text(
                              "Days repeats on",
                              style: TextStyle(
                                fontSize: 20,
                                // decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 4.0, left: 10, right: 10),
                          child: Container(
                            child: Wrap(
                              alignment: WrapAlignment.spaceEvenly,
                              children: <Widget>[
                                ChoiceChip(
                                  label: Text("S"),
                                  tooltip: "Sunday",
                                  shape: CircleBorder(),
                                  selected: itemForm.isSelectedSunday,
                                  onSelected: (bool selected) {
                                    setState(() {
                                      itemForm.isSelectedSunday = selected;
                                    });
                                  },
                                ),
                                const SizedBox(width: 8),
                                ChoiceChip(
                                  label: Text("M"),
                                  tooltip: "Monday",
                                  selected: itemForm.isSelectedMonday,
                                  shape: CircleBorder(),
                                  onSelected: (bool selected) {
                                    setState(() {
                                      itemForm.isSelectedMonday = selected;
                                    });
                                  },
                                ),
                                const SizedBox(width: 8),
                                ChoiceChip(
                                  label: Text("T"),
                                  tooltip: "Tuesday",
                                  selected: itemForm.isSelectedTuesday,
                                  shape: CircleBorder(),
                                  onSelected: (bool selected) {
                                    setState(() {
                                      itemForm.isSelectedTuesday = selected;
                                    });
                                  },
                                ),
                                const SizedBox(width: 8),
                                ChoiceChip(
                                  label: Text("W"),
                                  tooltip: "Wednesday",
                                  selected: itemForm.isSelectedWednesday,
                                  shape: CircleBorder(),
                                  onSelected: (bool selected) {
                                    setState(() {
                                      itemForm.isSelectedWednesday = selected;
                                    });
                                  },
                                ),
                                const SizedBox(width: 8),
                                ChoiceChip(
                                  label: Text("T"),
                                  tooltip: "Thursday",
                                  selected: itemForm.isSelectedThursday,
                                  shape: CircleBorder(),
                                  onSelected: (bool selected) {
                                    setState(() {
                                      itemForm.isSelectedThursday = selected;
                                    });
                                  },
                                ),
                                const SizedBox(width: 8),
                                ChoiceChip(
                                  label: Text("F"),
                                  tooltip: "Friday",
                                  selected: itemForm.isSelectedFriday,
                                  shape: CircleBorder(),
                                  onSelected: (bool selected) {
                                    setState(() {
                                      itemForm.isSelectedFriday = selected;
                                    });
                                  },
                                ),
                                const SizedBox(width: 8),
                                ChoiceChip(
                                  label: Text("S"),
                                  tooltip: "Saturday",
                                  selected: itemForm.isSelectedSaturday,
                                  shape: CircleBorder(),
                                  onSelected: (bool selected) {
                                    setState(() {
                                      itemForm.isSelectedSaturday = selected;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 4.0, left: 10, right: 10),
                          child: Container(
                            child: _missingDays(),
                          ),
                        ),

                        sizedBoxSpace,
                        //  Divider(),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 0.0),
                          ),
                          child: ChangeNotifierProvider.value(
                            value: itemForm,
                            child: Consumer<ItemForm>(
                              builder: (context, hoursEdit, _) {
                                return OperationalHoursTile();
                              },
                            ),
                          ),
                        ),
                        sizedBoxSpace,
                        // if (_formSubmitFailed)
                        //   Container(
                        //     child: Text(
                        //       "Error: Fix missing fields",
                        //       style: TextStyle(
                        //         color: Colors.red,
                        //       ),
                        //     ),
                        //   ),
                        // SizedBox(height: 4),
                      ],
                    ),
                  ),
                  Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Container(
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
