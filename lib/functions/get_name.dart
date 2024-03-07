String getName({

  required String? prefixText,
  required String doctorLastName,
  required String userLastName,
  required String? dateTimeConsultation,

}){
  String text = '$doctorLastName/$userLastName';
  if(prefixText!=null){
    text = '${prefixText} : '+text;
  }
  if(dateTimeConsultation!=null){
    text+='/$dateTimeConsultation';
  }
  print('the text is ${text}');
  return text;

  // 'prefixText: ${consultationNotes[i][ApiVariableKeys.doctor_lastname]}/${consultationNotes[i][ApiVariableKeys.user_lastname]}'
}