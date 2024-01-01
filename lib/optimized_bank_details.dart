import 'package:flutter/material.dart';

import 'bank_details_list_screen.dart';
import 'bank_details_model.dart';
import 'database_helper.dart';
import 'main.dart';

class OptimizedBankDetailsFormScreen extends StatefulWidget {
  const OptimizedBankDetailsFormScreen({super.key});

  @override
  State<OptimizedBankDetailsFormScreen> createState() => _OptimizedBankDetailsFormScreenState();
}

class _OptimizedBankDetailsFormScreenState extends State<OptimizedBankDetailsFormScreen> {
  var _bankNameController = TextEditingController();
  var _branchController = TextEditingController();
  var _accountTypeController = TextEditingController();
  var _accountNoController = TextEditingController();
  var _IFSCCodeController = TextEditingController();

  // Edit mode
  bool firstTimeFlag = false;
  int _selectedId = 0;
  // Optimized
  String buttonText = 'Save';

  _deleteFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  print('--------------> Cancel Button Clicked');
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  print('--------------> Delete Button Clicked');
                  _delete();
                },
                child: const Text('Delete'),
              )
            ],
            title: const Text('Are you sure you want to delete this?'),
          );
        });
  }

  @override
  Widget build(BuildContext context) {

    // Edit - Receive Data
    if (firstTimeFlag == false) {
      print('---------->once execute');

      firstTimeFlag = true;

      //final bankDetails = ModalRoute.of(context)!.settings.arguments as BankDetailsModel;
      final bankDetails = ModalRoute.of(context)!.settings.arguments;

      if(bankDetails == null) {
        print('----------->FAB: Insert/Save:');
      } else {
        print('----------->ListView: Received Data: Edit/Delete');

        bankDetails as BankDetailsModel;

        print('----------->Received Data');

        buttonText = 'Update';

        print(bankDetails.id);
        print(bankDetails.bankName);
        print(bankDetails.branch);
        print(bankDetails.accountType);
        print(bankDetails.accountNo);
        print(bankDetails.ifscCode);

        _selectedId = bankDetails.id!;

        _bankNameController.text = bankDetails.bankName;
        _branchController.text = bankDetails.branch;
        _accountTypeController.text = bankDetails.accountType;
        _accountNoController.text = bankDetails.accountNo;
        _IFSCCodeController.text = bankDetails.ifscCode;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Bank Account Details Form'),
        actions: _selectedId == 0 ? null :[
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem(value: 1, child: Text("Delete")),
            ],
            elevation: 2,
            onSelected: (value) {
              if (value == 1) {
                print('Delete option clicked');
                _deleteFormDialog(context);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _bankNameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      labelText: 'Bank Name',
                      hintText: 'Enter Bank Name'
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _branchController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      labelText: 'Branch Name',
                      hintText: 'Enter Branch Name'
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _accountTypeController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      labelText: 'Account Type',
                      hintText: 'Enter Account Type'
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _accountNoController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      labelText: 'Account No',
                      hintText: 'Enter Account No'
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _IFSCCodeController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      labelText: 'IFSC Code',
                      hintText: 'Enter IFSC Code'
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    print('--------------> Update Button Clicked');
                    if (_selectedId == 0) {
                      print('---------------> Save');
                      _save();
                    } else {
                      print('---------------> Update');
                      _update();
                    }
                  },
                  child: Text('Update'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _save() async{
    print('--------------> _save');
    print('--------------> Bank Name: ${_bankNameController.text}');
    print('--------------> Branch: ${_branchController.text}');
    print('--------------> Account Type: ${_accountTypeController.text}');
    print('--------------> Account No: ${_accountTypeController.text}');
    print('--------------> IFSC Code: ${_IFSCCodeController.text}');

    Map<String, dynamic> row = {
      DatabaseHelper.colBankName: _bankNameController.text,
      DatabaseHelper.colBranch: _branchController.text,
      DatabaseHelper.colAccountType: _accountTypeController.text,
      DatabaseHelper.colAccountNo: _accountNoController.text,
      DatabaseHelper.colIFSCCode: _IFSCCodeController.text,
    };

    final result = await dbHelper.insertBankDetails(row);
    debugPrint('--------> Inserted Row Id: $result');

    if(result != 0) {
      _showSuccessSnackBar(context, 'Successfully Saved');
      backToListScreen();
    }else{
      _showSuccessSnackBar(context, 'Failed to save.');
    }
  }

  void _update() async{
    print('--------------> _update');
    print('---------------> Selected ID: $_selectedId');
    print('--------------> Bank Name: ${_bankNameController.text}');
    print('--------------> Branch: ${_branchController.text}');
    print('--------------> Account Type: ${_accountTypeController.text}');
    print('--------------> Account No: ${_accountTypeController.text}');
    print('--------------> IFSC Code: ${_IFSCCodeController.text}');

    Map<String, dynamic> row = {
      DatabaseHelper.colId: _selectedId,
      DatabaseHelper.colBankName: _bankNameController.text,
      DatabaseHelper.colBranch: _branchController.text,
      DatabaseHelper.colAccountType: _accountTypeController.text,
      DatabaseHelper.colAccountNo: _accountNoController.text,
      DatabaseHelper.colIFSCCode: _IFSCCodeController.text,
    };

    final result = await dbHelper.updateBankDetails(row);
    debugPrint('--------> Updated Row Id: $result');

    if(result != 0) {
      _showSuccessSnackBar(context, 'Successfully Updated');
      backToListScreen();
    }else{
      _showSuccessSnackBar(context, 'Failed to update.');
    }
  }

  void _delete() async{
    print('--------------> _delete');

    final result = await dbHelper.deleteBankDetails(_selectedId);

    debugPrint('-----------------> Deleted Row Id: $result');

    if(result != 0) {
      _showSuccessSnackBar(context, 'Successfully Deleted.');
      backToListScreen();
    }else{
      _showSuccessSnackBar(context, 'Failed to delete.');
    }
  }

  backToListScreen(){
    setState(() {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => BankDetailsListScreen()));
    });
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: new Text(message)));
  }
}
