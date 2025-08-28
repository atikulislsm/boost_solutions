import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(110.h), 
          child: Text("ক্রেডিট লাইন অ্যাকাউন্টের শর্ত সমূহ")
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Text(
              '• পুরানো ফেসবুক পেজ লাগবে, এবং রেস্ট্রিকটেড পেজ দিয়ে একাউন্ট হবে না। (একেবারে নতুন পেইজ দিয়ে একাউন্ট হবে না)',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '• ৫০ বা ১০০ ডলারের পেমেন্ট এডভান্স করতে হবে। উক্ত ৫০/১০০ ডলার একাউন্ট এর সাথে এড করে দেয়া হবে যা খরচ করতে পারবেন।',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '• একাউন্ট প্রসেস হওয়ার জন্য ১-৩ দিন সময় দিতে হবে।',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '• ডলার লেনদেন ব্যাংকের মাধ্যমে করতে হবে।',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '• ডলার রিকোয়েস্ট সকাল ১১:০০ টা থেকে রাত ৮:০০ টার মধ্যে পাঠানো যাবে।',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '• ডেইলি মাত্র সর্বনিম্ন ৫০০ ডলার খরচ করতে হবে।',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '• এক মাসে ২ মাস একাউন্ট ব্যবহার না করলে দিন গোনাগুনি রিসেট হবে এবং একাউন্ট টি একটিভ না থাকার কারণে একাউন্টটি বন্ধ হয়ে যেতে পারে।',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '• একাউন্ট বন্ধ হয়ে গেলে অফিশিয়াল বলানোর জন্য ২-৪ দিনের সময় দিতে হবে।',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '• একাউন্ট বন্ধ হওয়ার রিফান্ড প্রসেসের জন্য ৭-১০ দিন সময় দিতে হবে।',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}


