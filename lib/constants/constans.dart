// ignore_for_file: deprecated_member_use, non_constant_identifier_names

import 'package:flutter/material.dart';

BoxShadow boxShadow = BoxShadow(
color: const Color(0xFF000000).withOpacity(0.04),
offset: const Offset(0.0,10.0),
spreadRadius: 0.0,
blurRadius: 11.0
);

BoxShadow shadow = BoxShadow(
color: const Color(0xFF000000).withOpacity(0.09),
offset: const Offset(0.0,3.0),
spreadRadius: 0.0,
blurRadius: 12.0
);

String currentTimezone = 'America/Los_Angeles';

BoxShadow boxShadowtop = BoxShadow(
color: const Color(0xFF000000).withOpacity(0.09),
offset: const Offset(0.0,-1.0),
spreadRadius: 0.0,
blurRadius: 12.0
);

BorderRadius radius = BorderRadius.circular(15);


EdgeInsets pad_horizontal = const EdgeInsets.symmetric(horizontal: 16);


enum UserType{
  user,provider
}

UserType currentUserType = UserType.user;

