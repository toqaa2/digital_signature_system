
class CommentModel {
  String? userID;
  String? comment;

  CommentModel({
    required this.userID,
    required this.comment,
  });

  Map<String, dynamic> toMap() => {
    'userID': userID,
    'comment': comment,
  };

  CommentModel.fromJson(Map<String, dynamic>? json) {
    userID = json!['userID'];
    comment = json['comment'];
  }
}
