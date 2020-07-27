class ScoreBean {
  String title;
  List<String> data;

  ScoreBean({this.title, this.data});

  ScoreBean.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    data = json['data'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['data'] = this.data;
    return data;
  }
}
