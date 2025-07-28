class ConnectionService {
  //*****************Live URl ****************/
  // static var base_url = "https://avpsiddhaacademy.com/app/api";
  static var base_url = "http://192.168.29.111:8000/app/api";

  static var update_popup = "$base_url/fetch.php";

  static var login = "$base_url/fetch.php";
  static var logout = "$base_url/logout";
  static var videoListUrl = "$base_url/video_fetch.php";
  static var profile = "$base_url/fetch.php";
  static var curriculumList = "$base_url/fetch.php";
  static var questions = "$base_url/fetch.php";
  static var answer = "$base_url/fetch.php";
  static var viewresult = "$base_url/fetch.php";
  static var examstart = "$base_url/insert.php";
  static var examtime = "$base_url/insert.php";
  static var submit = "$base_url/submit_answers.php";
}
