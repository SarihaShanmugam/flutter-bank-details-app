import 'package:flutter/material.dart';

import 'bank_details_list_screen.dart';
import 'database_helper.dart';
import 'main.dart';

class BankDetailsFormScreen extends StatefulWidget {
  const BankDetailsFormScreen({super.key});

  @override
  State<BankDetailsFormScreen> createState() => _BankDetailsFormScreenState();
}

class _BankDetailsFormScreenState extends State<BankDetailsFormScreen> {
  var _bankNameController = TextEditingController();
  var _branchController = TextEditingController();
  var _accountTypeController = TextEditingController();
  var _accountNoController = TextEditingController();
  var _IFSCCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bank Account Details Form'),
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
                    print('--------------> Save Button Clicked');
                    _save();
                  },
                  child: Text('Save'),
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

    _showSuccessSnackBar(context, 'Successfully Saved');

    setState(() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => BankDetailsListScreen()));
    });
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: new Text(message)));
  }
}
