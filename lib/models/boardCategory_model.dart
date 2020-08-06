
///Matthias Maxelon
class BoardCategory {
  String documentID;
  String title;
  BoardCategory(this.title);

  BoardCategory.fromJson(Map snapshot, String documentID) {
    this.documentID = documentID;
    title = snapshot["title"] ?? "";
  }
  Map<String, dynamic> toJson() {
    return {"title": title};
  }
}
