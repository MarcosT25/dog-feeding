class ApiController {
  String url = "http://192.168.15.5/";
  void setPath(String path) {
    url = "http://" + path + "/";
  }
}

var apiController = ApiController();
