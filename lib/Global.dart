import "dart:convert" show utf8;

class Global {
  static String URL_products = "https://6731c05f7aaf2a9aff11dd05.mockapi.io";

  static String vifont(String str) {
    String str1 = str ?? '';
    return utf8.decode(str1.runes.toList());
  }
}
