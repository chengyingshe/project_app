//传入probTakenTime，获取当前的时间，再将两个时间进行相减
//获得当前问题单得进度时间（传回String）
String getDays(String probTakenTime) {
  DateTime now = DateTime.now();
  DateTime t = DateTime.parse(probTakenTime);
  return now.difference(t).inDays.toString();
}
