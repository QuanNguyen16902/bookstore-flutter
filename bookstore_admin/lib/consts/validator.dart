class MyValidator {
    static String? uploadBookText({String? value, String? toBeReturnedString}){
      if(value!.isEmpty){
        return toBeReturnedString;
      }
      return null;
    }
}
