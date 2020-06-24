
///Matthias Maxelon
class BoardCategory {
  String id;
  String title;
  BoardCategory(this.title);

  BoardCategory.fromJson(Map snapshot) {
    title = snapshot["title"] ?? "";
  }
  Map<String, dynamic> toJson() {
    return {"title": title};
  }
}
