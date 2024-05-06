class MyValidator {
  static String? displayNameValidator(String? displayName) {
    if (displayName == null || displayName.isEmpty) {
      "Tên không được để trống";
    }
    if (displayName!.length < 3 || displayName.length > 20) {
      return "Tên phải trong khoảng 3 - 20 ký tự";
    }
    return null;
  }

  static String? emailValidator(String value) {
    if (value.isEmpty) {
      return "Hãy nhập email";
    }
    if (!RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b')
        .hasMatch(value)) {
      return "Hãy nhập đúng định dạng email";
    }
    return null;
  }

  static String? passwordValidator(String value){
    if(value.isEmpty){
        return "Hãy nhập mật khẩu";
    }
    if(value.length < 6){
      return "Mật khẩu phải ít nhất 6 ký tự";
    }
    return null;
  }

  static String? repeatPasswordValidator(String? value, String? password){
    if(value != password){
      return "Mật khẩu không khớp";
    }
    if(value!.isEmpty){
        return "Hãy nhập mật khẩu";
    }
    if(value.length < 6){
      return "Mật khẩu phải ít nhất 6 ký tự";
    }
    return null;
  }

  static String? uploadProdTexts({String? value, String? toBeReturnedString}){
    if(value!.isEmpty){
      return toBeReturnedString;
    }
    return null;
    
  }
}
