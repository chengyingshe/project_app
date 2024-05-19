class Str2Map {
  Str2Map({required this.str}); //构造函数
  final String str;

  Map<String, String> getMapFromString() {
    Map<String, String> dataMap = <String, String>{};
    for (String item in str.split('<br>')) {
      if (item != '') {
        dataMap[item.split('=')[0]] = item.split('=')[1];
      }
    }
    return dataMap;
  }

  String? getItemFromString(String key) {
    return getMapFromString()[key];
  }
}
