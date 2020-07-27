class RoutePathBean {
  String path;
  Param param;

  RoutePathBean({this.path, this.param});

  RoutePathBean.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    param = json['param'] != null ? new Param.fromJson(json['param']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['path'] = this.path;
    if (this.param != null) {
      data['param'] = this.param.toJson();
    }
    return data;
  }
}

class Param {
  String name;
  String version;

  Param({this.name, this.version});

  Param.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['version'] = this.version;
    return data;
  }
}
