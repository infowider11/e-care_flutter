import 'package:flutter/material.dart';

import '../services/pay_stack/flutter_paystack_services.dart';

 paymentsuccesspopup(BuildContext context, PaymentStatus paymentStatus) {
  // set up the buttons
  Widget continueButton = TextButton(
    child: Text( paymentStatus==PaymentStatus.ongoing?"Ok":"Continue"),
    onPressed: () async {
      Navigator.pop(context);
      Navigator.popUntil(context, (route) => route.isFirst);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(
      paymentStatus==PaymentStatus.ongoing?"Payment Processing":"Booking finalized",
      style: TextStyle(color: paymentStatus==PaymentStatus.ongoing?Colors.orangeAccent:Colors.green),
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
            paymentStatus==PaymentStatus.ongoing?
            'Your payment is currently being processed. Once we receive confirmation from your bank, it will be automatically reflected as confirmed in the "Confirmed" tab of your "My Consultation" section. Please note that this process may take up to 30 minutes. If the payment status does not update within that time, kindly click on the "Payment processing" button to refresh the status of your payment.':
            // 'Your Payment is being processed from your bank. If approved, it will automatically come in confirmed booking section.':
            'If your consultation does not take place due to your healtcare provider not initiating the call, please contact us via the app or email admin@E-Care.co.za within 24 hours of the appointment, so that we may investigate further and refund you if appropriate.'),
        // Text('Once approved by your healthcare provider, you will be directed to make a payment to finalize your booking.'),
      ],
    ),
    actions: [
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
