class WorkingTimeModel{

  final String from;
  final String to;
  final String id;

  WorkingTimeModel({this.from, this.to, this.id});

  Map<String, dynamic> toMap(){
    return {
      "from": from,
      "to": to,
    };
  }


}