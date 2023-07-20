import 'package:email_validator/email_validator.dart';

mixin ValidatorMixin{
  String? emailValidate(value) {
    if (!EmailValidator.validate(value!)) {
      return 'Please enter a valid email address';
    }
  }

  String? passValidate(value) {
    if (value == "") {
      return "Please fill the Pass Field!!";
    } else if (value!.length < 6) {
      return "Please enter an valid Password (password must contain atleast 6 chars)";
    }

    return null;
  }

}