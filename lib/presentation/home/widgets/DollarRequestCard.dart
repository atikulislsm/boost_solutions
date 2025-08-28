import 'package:boost_solutions/presentation/edit_transaction.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DollarRequestCard extends StatelessWidget {
  final Map<String, dynamic> request;

  const DollarRequestCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    String status = request['status'].toString() ;
    String dollar = request['dollar'] ?? '0';
    String accountNumber = request['balance'] != null && request['balance']['name'] != null
        ? request['balance']['name'].toString()
        : 'N/A';
    String amount = request['amount']?.toString() ?? '0';
    String createdAt = request['created_at'] ?? 'N/A';
    String updatedAt = request['updated_at'] ?? 'N/A';


    Color statusColor;
    Color textColor;
    switch (status) {
      case '3':
        statusColor =Colors.red.withOpacity(0.5);
        textColor = Colors.red.shade900;
        break;
      case '2':
        statusColor = const Color(0x4001FFAC);
        textColor = const Color(0xFF002C1D);
        break;
      case '1':
        statusColor = Colors.blue.withOpacity(0.5);
        textColor = Colors.blueAccent.shade700;
        break;
      case '0':
        statusColor = Colors.yellow.withOpacity(0.5);
        textColor = Colors.yellow.shade900;
        break;
      default:
        statusColor = Colors.grey.shade200;
        textColor = Colors.black54;
    }

    return Card(
      elevation: 3,
      //margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Row(
          children: [
            SizedBox(
              width: 115.w,
              child: AutoSizeText(
                accountNumber,
                style:  TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 12.r,
                ),
                maxLines: 4,
              ),
            ),
            SizedBox(
              width: 135.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    createdAt,
                    style: const TextStyle(fontSize: 12),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: status =="0" ?
                    Center(
                      child: AutoSizeText(
                        "Pending $updatedAt",
                        style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.normal,
                            fontSize: 12.r
                        ),
                      ),
                    ):
                    status == "1" ?
                    AutoSizeText(
                      "Processing $updatedAt",
                      style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 12.r
                      ),
                    ):
                    status == "2" ?
                    AutoSizeText(
                      "Completed $updatedAt",
                      style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 12.r
                      ),
                    ):
                    AutoSizeText(
                      "Rejected $updatedAt",
                      style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 12.r
                      ),
                    )
                    ,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 65.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AutoSizeText(
                    '\$$dollar',
                    style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 12),
                  ),

                  AutoSizeText(
                    '৳$amount',
                    style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 12),
                  ),
                ],
              ),
            ),

            if(status == "1" || status == "0")
            SizedBox(
              width: 24.w,
              child: GestureDetector(
                onTap: (){
                  Get.to(() => EditTransaction(request: request));
                },
                  child: Image.asset("assets/images/edit.png",width: 18,height: 18,)
              ),
            )
            else
              Container(
                width: 24.w,
              )

          ],
        ),
      ),
    );
  }
}