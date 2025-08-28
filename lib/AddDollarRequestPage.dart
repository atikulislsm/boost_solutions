import 'package:boost_solutions/invoice_controll/invoicePage.dart';
import 'package:boost_solutions/presentation/term.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart' as dio;
import 'controller/AppController.dart';
import 'controller/auth_controller.dart';

class AddDollarRequestPage extends StatefulWidget {
  const AddDollarRequestPage({super.key});

  @override
  _AddDollarRequestPageState createState() => _AddDollarRequestPageState();
}

class _AddDollarRequestPageState extends State<AddDollarRequestPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedAccount;
  String? selectedPaymentMethod;
  String? dollarAmount;
  File? _selectedImage;
  double? rate;
  double? amount;

  final GetStorage storage = GetStorage();
  final dio.Dio _dio = dio.Dio();
  final ImagePicker _picker = ImagePicker();
  final AuthController _authController = Get.find();
  final AppController _appController = Get.find();

  bool isCheckbox1Checked = true;
  bool isCheckbox2Checked = true;
  bool isCheckbox3Checked = true;

  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void calculateAmount() {
    if (rate != null && dollarAmount != null && dollarAmount!.isNotEmpty) {
      amount = double.tryParse(dollarAmount!)! * rate!;
    } else {
      amount = null;
    }
    setState(() {});
  }

  Future<void> updateDollarRequest() async {
    if (!_formKey.currentState!.validate() ||
        _selectedImage == null ||
        !isCheckbox1Checked ||
        !isCheckbox2Checked ||
        !isCheckbox3Checked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please complete all fields and select an image')),
      );
      return;
    }

    const String storeUrl =
        "https://boost.mohasagorit.solutions/api/dollar-request/store";
    String bearerToken = await storage.read('token');

    try {
      final formData = dio.FormData.fromMap({
        "boost_agency_reseller_ad_account_id": selectedAccount,
        "balance_id": selectedPaymentMethod,
        "dollar": dollarAmount,
        'rate': rate,
        'amount': amount,
        if (_selectedImage != null)
          "image": await dio.MultipartFile.fromFile(_selectedImage!.path),
      });

      final response = await _dio.post(
        storeUrl,
        data: formData,
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $bearerToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Store successful!')),
        );
        _appController.fetchApiResponse();
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => InvoicePage(
                customerName: "",
                customerMobile: "",
                account: selectedAccount ?? "",
                dollar: dollarAmount ?? '',
                rate: rate ?? 0,
                amount: amount?? 0,
                paymentMethod: selectedPaymentMethod ?? '',
                transactionDate: DateTime.now(),
              paymentScreenshot: _selectedImage,
            )
        )
        ); // Go back to the previous screen
      } else {
        throw Exception('Failed to store data');
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Dollar Request'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Obx(() {
                final accounts =
                    _authController.balanceAndAccount.value.data?.addAccounts;
                return DropdownButtonFormField<String>(
                  value: selectedAccount,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Select Advertise Account *',
                    border: OutlineInputBorder(),
                  ),
                  items: accounts
                      ?.map((account) => DropdownMenuItem(
                    value: account.id,
                    child: Text(account.name ?? '',),

                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedAccount = value;
                      String? temp = accounts
                          ?.firstWhere((account) => account.id == value)
                          .dollarRate ;
                      rate = double.parse(temp!);
                      calculateAmount();
                    });
                  },
                  validator: (value) =>
                  value == null ? 'Please select an account' : null,
                );
              }),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Dollar *',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    dollarAmount = value;
                    calculateAmount();
                  });
                },
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter dollar amount'
                    : null,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Rate: ${rate ?? '0'} BDT'),
                  Text('Amount: ${amount ?? '0'} BDT'),
                ],
              ),
              const SizedBox(height: 16),
              Obx(() {
                final balances = _authController.balanceAndAccount.value.data?.balances;
                return DropdownButtonFormField<String>(
                  value: selectedPaymentMethod,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Select Payment Method *',
                    border: OutlineInputBorder(),
                  ),
                  items: balances
                      ?.map((balance) => DropdownMenuItem(
                    value: balance.id,
                    child: selectedPaymentMethod == balance.id
                        ? Text(balance.name ?? '') // No padding for selected item
                        : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(balance.name ?? ''), // Padding for menu items
                    ),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentMethod = value;
                    });
                  },
                  validator: (value) =>
                  value == null ? 'Please select a payment method' : null,
                );
              }),

              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickImageFromGallery,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedImage == null
                            ? 'Payment Screenshot *'
                            : 'Image Selected',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.image),
                    ],
                  ),
                ),
              ),
              if (_selectedImage != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.file(
                    _selectedImage!,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('আমি নিশ্চিত সঠিক অ্যাকাউন্টে টাকা ট্রান্সফার হয়েছে ।'),
                value: isCheckbox1Checked,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (value) {
                  setState(() {
                    isCheckbox1Checked = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('আমি নিশ্চিত অ্যাকাউন্ট থেকে ব্যালেন্স ইন্সট্যান্ট ট্রান্সফার হয়েছে।'),
                value: isCheckbox2Checked,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (value) {
                  setState(() {
                    isCheckbox2Checked = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: GestureDetector(
                    onTap: (){
                      Get.to((const TermScreen()));
                    },
                    child: const Text('আমি কর্তৃপক্ষের শর্তাবলী পড়েছি এবং তাতে সম্মত ।')),
                value: isCheckbox3Checked,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (value) {
                  setState(() {
                    isCheckbox3Checked = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: updateDollarRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade800,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Submit',style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
