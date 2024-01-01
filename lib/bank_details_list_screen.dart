import 'package:flutter/material.dart';
import 'bank_details_form_screen.dart';
import 'bank_details_model.dart';
import 'database_helper.dart';

import 'main.dart';
import 'optimized_bank_details.dart';


class BankDetailsListScreen extends StatefulWidget {
  const BankDetailsListScreen({super.key});

  @override
  State<BankDetailsListScreen> createState() => _BankDetailsListScreenState();
}

class _BankDetailsListScreenState extends State<BankDetailsListScreen> {
  List<BankDetailsModel> _bankDetailsList = <BankDetailsModel>[];

  @override
  void initState() {
    super.initState();
    print('------------------> initState');
    _getBankDetailsRecords();
  }

  _getBankDetailsRecords() async {
    var _bankDetailRecords = await dbHelper.getAllBankDetails();

    _bankDetailRecords.forEach((bankDetailRow) {
      setState(() {
        // log
        print(bankDetailRow[DatabaseHelper.colId]);
        print(bankDetailRow[DatabaseHelper.colBankName]);
        print(bankDetailRow[DatabaseHelper.colBranch]);
        print(bankDetailRow[DatabaseHelper.colAccountType]);
        print(bankDetailRow[DatabaseHelper.colAccountNo]);
        print(bankDetailRow[DatabaseHelper.colIFSCCode]);
        // received - username,  password, dob

        // fill data in model
        var bankDetailsModel = BankDetailsModel(
          bankDetailRow[DatabaseHelper.colId],
          bankDetailRow[DatabaseHelper.colBankName],
          bankDetailRow[DatabaseHelper.colBranch],
          bankDetailRow[DatabaseHelper.colAccountType],
          bankDetailRow[DatabaseHelper.colAccountNo],
          bankDetailRow[DatabaseHelper.colIFSCCode],
        );

        // add into list
        _bankDetailsList.add(bankDetailsModel);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bank Details'),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: _bankDetailsList.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  print('---------->Edit or Delete invoked: Send Data');
                  print(_bankDetailsList[index].id);
                  print(_bankDetailsList[index].bankName);
                  print(_bankDetailsList[index].branch);
                  print(_bankDetailsList[index].accountType);
                  print(_bankDetailsList[index].accountNo);
                  print(_bankDetailsList[index].ifscCode);

                  /*
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditBankDetailsFormScreen(),
                    settings: RouteSettings(
                      arguments: _bankDetailsList[index],
                    ),
                  ));
                   */

                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => OptimizedBankDetailsFormScreen(),
                    settings: RouteSettings(
                      arguments: _bankDetailsList[index],
                    ),
                  ));

                },
                child: ListTile(
                  title: Text(_bankDetailsList[index].bankName +
                      '\n' +
                      _bankDetailsList[index].branch +
                      '\n' +
                      _bankDetailsList[index].accountType +
                      '\n' +
                      _bankDetailsList[index].accountNo +
                      '\n' +
                      _bankDetailsList[index].ifscCode),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('--------------> Launch Bank Details Form Screen');
          /*
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => BankDetailsFormScreen()));
              */
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => OptimizedBankDetailsFormScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
