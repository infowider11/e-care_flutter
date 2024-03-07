
class ValidationFunction {
  static String? requiredValidation(val,{String? msg}) {
    if (val == null ||val.length == 0) {
      return msg??"Required";
    } else {
      return null;
    }
  }


  // static doubleNumberValidation(val,{String? msg, double? maxValue, double? minValue}){
  //   if (val == null ||val.length == 0) {
  //     return "Required";
  //   } else if(double.tryParse(val)==null){
  //     return msg??"It should be a valid number";
  //   }else{
  //     double amount = double.parse(val);
  //     if(minValue!=null && minValue>amount){
  //       return "${translate('theEnteredAmountMin')} $minValue";
  //     }else if(maxValue!=null && maxValue<amount){
  //       return "${translate('theEnteredAmountMax')} $maxValue";
  //     }else{
  //       return null;
  //     }
  //   }
  // }
  static mobileNumberValidation(val) {
    if (val.length == 0) {
      return "Required";
    }
    // else if (val.length < 10) {
    //   return "Enter 10 digit mobile number";
    // }
    else {
      return null;
    }
    // return null;
  }

  static passwordValidation(val) {
    if (val.length == 0) {
      return "Required";
    } else if (val.length < 6) {
      return "Enter at least 6 character password";
    } else {
      return null;
    }
    // return null;
  }

  static nameValidation(val) {
    RegExp nameRegex = RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
    if (val.length == 0) {
      return "Required";
    } else if (!nameRegex.hasMatch(val)) {
      return "Please Enter Correct Name";
    } else {
      return null;
    }

  }
  static  emailValidation(val) {
    RegExp emailAddress = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (val.length == 0) {
      return "Please enter your email id*";
    } else if (!emailAddress.hasMatch(val)) {
      return "Enter correct email address";
    } else {
      return null;
    }

  }
}
