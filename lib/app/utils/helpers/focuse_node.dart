import 'package:flutter/material.dart';

void fieldFocusChange(BuildContext context , FocusNode current , FocusNode  nextFocus ){
      current.unfocus();
      FocusScope.of(context).requestFocus(nextFocus);
    }