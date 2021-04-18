class Global{
  static String AdminEmail = "qca45162@gmail.com";//pass@word
  static String EditorEmail = "qceditor0@gmail.com";//qwert321

  static bool isNumeric(String s) {
    if(s == null || s.isEmpty) {
      return false;
    }
    if(double.parse(s, (e) => null) != null){
      if(!s.contains(".") && !s.contains("+") && !s.contains("-") && !s.contains(",") && s != "0"){
        return true;
      }
    }
    return false;
  }
}