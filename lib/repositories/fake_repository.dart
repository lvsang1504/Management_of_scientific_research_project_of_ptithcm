class DataModel {
  final String serviceName;
  final String date;
  final String time;

  DataModel({this.serviceName, this.date, this.time});
}

class FakeRepository {
  static List<DataModel> data = [
    DataModel(
        serviceName: "push Notification", time: "9:58 PM", date: "Mon, 31 Aug"),
    DataModel(
        serviceName: "Backed Integration",
        time: "9:58 PM",
        date: "Mon, 31 Aug"),
    DataModel(
        serviceName: "Flutter Developer", time: "9:58 PM", date: "Mon, 31 Aug"),
    DataModel(
        serviceName: "Fix code bugs", time: "9:58 PM", date: "Mon, 31 Aug"),
    DataModel(serviceName: "Bloc Arch", time: "9:58 PM", date: "Mon, 31 Aug"),
    DataModel(
        serviceName: "Facebook Integration",
        time: "9:58 PM",
        date: "Mon, 31 Aug"),
  ];
}
