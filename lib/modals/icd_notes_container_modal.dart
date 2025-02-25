
 // ignore_for_file: deprecated_member_use, non_constant_identifier_names
 
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/sized_box.dart';
import '../widgets/customtextfield.dart';

class IcdNotesContainerModal{

  TextEditingController descriptionController;
  TextEditingController icdCodeController;
  TextEditingController costController;
  TextEditingController procedureCode;
  String? id;
  String? doctor_id;

  IcdNotesContainerModal({
   required this.descriptionController,
    required this.icdCodeController,
    required this.costController,
    required this.procedureCode,
    this.id,
    this.doctor_id,
  });


  Widget showContainer({required Function? onRemove}){
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(top:40.0,left:8.0,right: 8.0,bottom: 10.0),
            // height: 270,
            width: double.infinity,
            decoration: BoxDecoration(
              color: MyColors.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextField(controller: descriptionController, hintText: 'Description of services rendered as per ICD-10', maxLines: 4,height: 120,),
                  vSizedBox,
                  CustomTextField(controller: icdCodeController, hintText: 'ICD-10 code'),
                  vSizedBox,
                  CustomTextField(controller: procedureCode, hintText: 'Procedure Code (If Applicable)'),
                  vSizedBox,
                  CustomTextField(controller: costController, hintText: 'Cost (In Rands)', keyboardType: TextInputType.number,),
                ],
              ),
            ),
          ),
          if(onRemove!=null)
            new Positioned(
                right: 0,
                child: IconButton(
                  onPressed: () {
                   onRemove();
                  },
                  icon: const Icon(Icons.remove_circle,color: Colors.red,),
                )
            )
        ],
      ),
    );
  }
}