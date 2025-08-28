import 'dart:io';
import 'package:boost_solutions/controller/AppController.dart';
import 'package:boost_solutions/controller/auth_controller.dart';
import 'package:boost_solutions/presentation/term.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class EditTransaction extends StatefulWidget {
  final Map<String, dynamic> request;

  const EditTransaction({super.key, required this.request});

  @override
  State<EditTransaction> createState() => _EditTransactionState();
}

class _EditTransactionState extends State<EditTransaction> {
  final _formKey = GlobalKey<FormState>();
  String? selectedAccount;
  String? selectedPaymentMethod;
  String? dollarAmount;
  String? rate;
  String? amount;
  String? _selectedImage;
  File? _selectedGalImage;
  final GetStorage storage = GetStorage();
  final dio.Dio _dio = dio.Dio();
  final ImagePicker _picker = ImagePicker();
  final AuthController _authController = Get.find();
  final AppController _appController = Get.find();

  // Checkboxes state
  final List<Map<String, dynamic>> _checkboxes = [
    {'text': 'আমি নিশ্চিত সঠিক অ্যাকাউন্টে টাকা ট্রান্সফার হয়েছে ।', 'isChecked': true},
    {'text': 'আমি নিশ্চিত অ্যাকাউন্ট থেকে ব্যালেন্স ইন্সট্যান্ট ট্রান্সফার হয়েছে।', 'isChecked': true},
    {'text': 'আমি কর্তৃপক্ষের শর্তাবলী পড়েছি এবং তাতে সম্মত ।', 'isChecked': true},
  ];

  @override
  void initState() {
    super.initState();
    selectedAccount = widget.request['account']['id']?.toString();
    selectedPaymentMethod = widget.request['balance']['id']?.toString();
    dollarAmount = widget.request['dollar']?.toString();
    rate = widget.request['rate']?.toString();
    amount = widget.request['amount']?.toString();
    _selectedImage = widget.request['image'];
    _calculateAmount();
  }

  void _calculateAmount() {
    if (dollarAmount != null && rate != null) {
      final double dollar = double.tryParse(dollarAmount!) ?? 0.0;
      final double exchangeRate = double.tryParse(rate!) ?? 0.0;
      setState(() {
        amount = (dollar * exchangeRate).toStringAsFixed(2);
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedGalImage = File(pickedFile.path);
        _selectedImage = null;
      });
    }
  }

  bool _areAllCheckboxesChecked() {
    return _checkboxes.every((checkbox) => checkbox['isChecked'] == true);
  }

  Future<void> updateDollarRequest() async {
    if (!_formKey.currentState!.validate() || _selectedGalImage == null || !_areAllCheckboxesChecked()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields, select an image, and agree to all conditions.')),
      );
      return;
    }

    final String updateUrl =
        "https://boost.mohasagorit.solutions/api/dollar-request/update/${widget.request['id']}";
    String bearerToken = await storage.read('token');

    try {
      final formData = dio.FormData.fromMap({
        "boost_agency_reseller_ad_account_id": selectedAccount,
        "balance_id": selectedPaymentMethod,
        "dollar": dollarAmount,
        "rate": rate,
        "amount": amount,
        if (_selectedGalImage != null)
          "image": await dio.MultipartFile.fromFile(_selectedGalImage!.path),
      });

      final response = await _dio.post(
        updateUrl,
        data: formData,
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $bearerToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Update successful!')),
        );
        _appController.fetchApiResponse();
        Navigator.pop(context);
      } else {
        throw Exception('Failed to update');
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
        title: const Text('Update Information'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(height: 5,),
              Obx(() {
                final accounts = _authController.balanceAndAccount.value.data?.addAccounts;
                return DropdownButtonFormField<String>(
                  value: selectedAccount,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Select Advertise Account *',
                    border: OutlineInputBorder(),
                  ),
                  items: accounts?.map((account) => DropdownMenuItem(
                    value: account.id,
                    child: Text(account.name ?? '',),
                  )).toList(),
                  onChanged: (value) => setState(() => selectedAccount = value),
                  validator: (value) => value == null ? 'Please select an account' : null,
                );
              }),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: dollarAmount,
                decoration: const InputDecoration(
                  labelText: 'Dollar *',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    dollarAmount = value;
                    _calculateAmount();
                  });
                },
                validator: (value) => value == null || value.isEmpty ? 'Please enter dollar amount' : null,
              ),
              const SizedBox(height: 8),
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
                  items: balances?.map((balance) => DropdownMenuItem(
                    value: balance.id,
                    child: selectedPaymentMethod == balance.id
                        ? Text(balance.name ?? '') // No padding for selected item
                        : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(balance.name ?? ''), // Padding for menu items
                    ),
                  )
                  ).toList(),
                  onChanged: (value) => setState(() => selectedPaymentMethod = value),
                  validator: (value) => value == null ? 'Please select a payment method' : null,
                );
              }),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickImageFromGallery,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedGalImage == null ? 'Payment Screenshot *' : 'Image Selected',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.image),
                    ],
                  ),
                ),
              ),
              if (_selectedImage != null && _selectedImage!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    "https://boost.mohasagorit.solutions/public/storage/$_selectedImage",
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child; // Image has been loaded
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        );
                      }
                    },
                  ),
                )
              else if (_selectedGalImage != null)
                Image.file(
                  _selectedGalImage!,
                  fit: BoxFit.cover,
                ),
              const SizedBox(height: 16),
              ..._checkboxes.map((checkbox) {
                return CheckboxListTile(
                  title:   GestureDetector(
                      onTap: (){
                        if(checkbox['text']=="আমি কর্তৃপক্ষের শর্তাবলী পড়েছি এবং তাতে সম্মত ।"){
                          Get.to(const TermScreen());
                        }
                      },
                      child: Text(checkbox['text'])),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: checkbox['isChecked'],
                  onChanged: (value) {
                    setState(() {
                      checkbox['isChecked'] = value ?? false;
                    });
                  },
                );
              }),
              ElevatedButton(
                onPressed: updateDollarRequest,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade800,
                    minimumSize: const Size(double.infinity, 50)),
                child: const Text('Submit',style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
