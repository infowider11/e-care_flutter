// ignore_for_file: prefer_interpolation_to_compose_strings, constant_identifier_names

class ApiUrls{
  // static const baseUrl = 'https://bluediamondresearch.com/WEB01/e_care/api/';
  // static const baseUrl = 'https://e-care.co.za/api/';
  static const baseUrl = 'https://e-care.co.za/staging/api/';
  // static const userApi = baseUrl +  'User_api/';


  static const String getSpecialistCategory = baseUrl + 'get-specialist-category';
  static const String get_language = baseUrl + 'get-language';
  static const String get_specialization = baseUrl + 'get-specialization';
  static const String get_specialIntrest = baseUrl + 'get-specialIntrest';
  static const String signup = baseUrl + 'signup';
  static const String socialsignup = baseUrl + 'social-login';
  static const String get_user_by_id = baseUrl + 'get-user-by-id';
  static const String login = baseUrl + 'login';
  static const String forgot = baseUrl + 'forget-password';
  static const String change_password = baseUrl + 'change-password';
  static const String edit_profile = baseUrl + 'edit-profile';
  static const String term = baseUrl + 'term?type=';
  static const String privacy = baseUrl + 'privacy';
  static const String ContactUs = baseUrl + 'ContactUs';
  static const String howcontent = baseUrl + 'howitwork';
  static const String editconsultantfees = baseUrl + 'edit-consultant-fees';
  static const String howitswork = baseUrl + 'how-its-work?type=';
  static const String homevideo = baseUrl + 'home-video?type=';
  static const String editcallstatus = baseUrl + 'edit-call-status';
  static const String CreateSlot = baseUrl + 'CreateSlot';
    static const String editSlot = baseUrl + 'editSlot';

  static const String createBulkSlots = baseUrl + 'BulkCreateSlot';
  // static const String createBulkSlots = baseUrl + 'BulkCreateSlot';
  static const String getslot = baseUrl + 'get-slot?user_id=';
  static const String deleteslot = baseUrl + 'delete-slot';
  static const String deleteNotification = baseUrl + 'ClearNotification';
  static const String interval = baseUrl + 'interval';
  static const String skip = baseUrl + 'skip';
  static const String Renewhpscano = baseUrl + 'Renew-hpsca-no';
  static const String medicalcondition = baseUrl + 'medical-condition';
  static const String getsurgeries = baseUrl + 'get-surgeries';
  static const String healthProfile = baseUrl + 'healthProfile';
  static const String familymedicalcondition = baseUrl + 'family-medical-condition';
  static const String getrelatives = baseUrl + 'get-relatives';
  static const String gethabitquestion = baseUrl + 'get-habit-question';
  static const String PatientHabit = baseUrl + 'PatientHabit';
  static const String healthdetail = baseUrl + 'health-detail';
  static const String get_document_image = baseUrl + 'get_document_image';
  static const String documentimage = baseUrl + 'document-image';
  static const String deletedocimage = baseUrl + 'delete-doc-image';
  static const String search_doctor = baseUrl + 'search_doctor';
  static const String available_slot = baseUrl + 'available_slot';
  static const String Booking = baseUrl + 'Booking';
  static const String booking_list = baseUrl + 'booking-list';
  static const String today_appointment = baseUrl + 'appointment';
  static const String rejectBooking = baseUrl + 'rejectBooking';
  static const String acceptBooking = baseUrl + 'acceptBooking';
  static const String GetNotification = baseUrl + 'GetNotification?user_id=';
  static const String MarkAsReadNotification = baseUrl + 'MarkAsReadNotification?user_id=';
  static const String updateDeviceToken = baseUrl + 'updateDeviceToken';
  static const String singleBookingData = baseUrl + 'singleBookingData?booking_id=';
  static const String available_event = baseUrl + 'available_event';
  static const String chat_list = baseUrl + 'MyChatList?user_id=';
  static const String chat_between_users = baseUrl + 'ChatBetweenUser';
  static const String send_msg = baseUrl + 'SendMessage';
  static const String FinalBooking = baseUrl + 'FinalBooking';
  static const String StartCall = baseUrl + 'StartCall';
  static const String endCall = baseUrl + 'EndCall';
  static const String PickCall = baseUrl + 'PickCall?booking_id=';
  static const String rating = baseUrl + 'add_rate';
  static const String reviews_list = baseUrl + 'reviews_list';
  static const String booking_cancel = baseUrl + 'cancel-booking-by-paitent';
  static const String addBankAccount = baseUrl + 'addBankAccount';
  static const String editBankAccount = baseUrl + 'editBankAccount';
  static const String bookingslist = baseUrl + 'prescription_BookingList?user_id=';
  static const String delete_prescription = baseUrl + 'delete_prescription';
  static const String deleteBooking = baseUrl + 'delete-booking';

  // new api assuming now
  static const String send_notification_toprovider = baseUrl + 'send_notification_toprovider';
  static const String add_precriptions = baseUrl + 'addPrecription';
  static const String edit_prescription = baseUrl + 'edit_prescription';
  static const String edit_precriptions = baseUrl + 'edit_precriptions';
  static const String get_reffral = baseUrl + 'referal_list';
  static const String get_precriptions = baseUrl + 'prescription_list';
  static const String add_reffral = baseUrl + 'referal_reference';
  static const String edit_reffral = baseUrl + 'edit_referal_reference';
  static const String get_notes = baseUrl + 'get_notes?user_id=';
  static const String add_notes = baseUrl + 'add_notes';
  static const String add_sicknotes = baseUrl + 'add-sick-note';
  static const String edit_sicknotes = baseUrl + 'edit_sick_note';
  static const String get_sicknotes = baseUrl + 'sick-note-list';
  static const String mark_as_complete = baseUrl + 'mark-as-complete?booking_id=';
  static const String delete_refral = baseUrl + 'delete_referal';
  static const String consultant_note_list = baseUrl + 'consultant_note_list';
  static const String add_consulatant_note = baseUrl + 'add_consulatant_note';
  static const String edit_consulatant_note = baseUrl + 'edit_consulatant_note';
  static const String delete_consultation_note = baseUrl + 'delete_consultation_note';
  static const String my_transactions = baseUrl + 'my-transactions';
  static const String adminCommission = baseUrl + 'admin-comission';
  static const String refundrequest = baseUrl + 'refund-request';
  static const String invoice_list = baseUrl + 'invoice-list?user_id=';
  static const String delete_sick_note = baseUrl + 'delete_sick_note';


  static const String change_booking_status = baseUrl + 'change_booking_status';
  static const String addIcdNotes = baseUrl + 'addIcdCode';
  static const String editIcdNotes = baseUrl + 'editIcdCode';
  static const String listIcdNotes = baseUrl + 'icdCode_list';
  static const String deleteIcdNotes = baseUrl + 'delete_icdCode';
  // static const String usericdCode_list = baseUrl + 'usericdCode_list';
  static const String usericdCode_list = baseUrl + 'booking-icd-code-list';
  static const String callStatus = baseUrl + 'call-status';
  static const String deleteInvoice = baseUrl + 'delete-invoice';
  static const String deleteIcd = baseUrl + 'delete-icd';
  static const String deletePrescription = baseUrl + 'delete-prescription';
  static const String deleteChat = baseUrl + 'delete-chat';
  static const String deleteReferal = baseUrl + 'delete-referal';
  static const String new_delete_sick_note = baseUrl + 'delete-sick-note';
  static const String deletIcdCode = baseUrl + 'delete_icdCode';
  static const String getDoctorByHpcsa = baseUrl + 'get-doctor-by-hpcsa';
// static const String  getSpecialistCategory = baseUrl + 'get-specialist-category';

}

