import 'package:flutter/material.dart';
import 'package:iww_frontend/repository/comment.repository.dart';
import 'package:iww_frontend/model/comment/comment.model.dart';

// 방명록 상태관리
class CommentsProvider with ChangeNotifier {
  final String _userId;
  String _ownerId;
  final CommentRepository _commentRepository;
  List<Comment> comments = [];
  // 방을 클릭할때마다 유지되는 상태

  CommentsProvider(
    this._userId,
    this._ownerId,
    this._commentRepository,
  );

  // 댓글 데이터 불러오기
  Future<void> fetchComment() async {
    comments = await _commentRepository.fetchComments(_ownerId);
    notifyListeners(); // 상태 변경 알림
  }

  // 댓글 생성
  Future<bool> addComment(String content) async {
    return await _commentRepository.addComment(_ownerId, _userId, content);
  }

  // 댓글 수정
  Future<bool> updateComment(String comId, String content) async {
    return await _commentRepository.updateComment(_ownerId, comId, content);
  }

  // 댓글 삭제
  Future<bool> deleteComment(String comId) async {
    return await _commentRepository.deleteComment(_ownerId, comId);
  }

  // 현재 유저 정보 반환
  // Future<int?> getUserId() async {
  //   return await _authService._getCurrentUser().then((user) => user?.user_id);
  // }
  void changeOwner(String ownerId) {
    _ownerId = ownerId;
  }
}

// 방명록 bottom sheet 트리거
void showCommentsBottomSheet(BuildContext context,
    CommentsProvider commentsProvider) async {
  // 댓글 데이터 가져오기
  await commentsProvider.fetchComment();

  if (context.mounted) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return CommentsBottomSheet(
            commentsProvider: commentsProvider,
          );
        });
  }
}

// 방명록 bottom sheet 뷰
class CommentsBottomSheet extends StatelessWidget {
  final CommentsProvider commentsProvider;

  const CommentsBottomSheet({
    Key? key,
    required this.commentsProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String ownerId = commentsProvider._ownerId;
    String userId = commentsProvider._userId;
    bool isOwner = ownerId == userId;
    final comments = commentsProvider.comments;

    return DraggableScrollableSheet(
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
          child: Scaffold(
              body: Column(
            children: <Widget>[
              Expanded(
                  child: ListView.builder(
                controller: scrollController,
                itemCount: comments.length,
                itemBuilder: (BuildContext context, int index) {
                  Comment comment = comments[index];
                  bool isCurrentUserComment = (comment.authorId == userId);
                  return isCurrentUserComment
                      ? _buildDismissibleComment(comment, context)
                      : _buildListTile(comment);
                },
              )),
              if (!isOwner)
                CommentInputField(
                    commentsProvider: commentsProvider,
                    ownerId: ownerId,
                    authorId: userId),
            ],
          )),
        );
      },
    );
  }

  Widget _buildDismissibleComment(Comment comment, BuildContext context) {
    return Dismissible(
      key: Key(comment.comId),
      direction: DismissDirection.horizontal,
      background: Container(
        color: Colors.green,
        child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(Icons.edit, color: Colors.white),
            )),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(Icons.delete, color: Colors.white),
            )),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          // 오른쪽으로 밀었을 때 (삭제)
          bool confirm =
              await _showConfirmationDialog(context, comment, commentsProvider);
          if (confirm) {
            bool success = await commentsProvider.deleteComment(comment.comId);
            if (success) {
              commentsProvider.fetchComment();
            }
            return success;
          }
          return false;
        } else {
          // 왼쪽으로 밀었을 때 (수정)
          _showEditCommentDialog(context, comment, commentsProvider);
          return false;
        }
      },
      child: _buildListTile(comment),
    );
  }

  Widget _buildListTile(Comment comment) {
    return ListTile(
      leading: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: CircleAvatar(
          radius: 20,
          backgroundImage: AssetImage(comment.userImage),
          // backgroundImage: NetworkImage(comment.userImage),
          // onBackgroundImageError: (exception, stackTrace) {},
          // child: Image.network(
          //   comment.userImage,
          //   fit: BoxFit.cover,
          //   errorBuilder: (context, error, stackTrace) {
          //     return CircleAvatar(
          //       radius: 20,
          //       backgroundImage: AssetImage("assets/profile.jpg"),
          //     );
          //   },
          // ),
        ),
      ),
      title: Row(
        children: [
          Text(comment.authorName),
          if (comment.isMod)
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                "(수정됨)",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
        ],
      ),
      subtitle: Text(comment.content),
    );
  }

  Future<bool> _showConfirmationDialog(BuildContext context, Comment comment,
      CommentsProvider commentsProvider) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('확인'),
              content: Text('댓글을 삭제하시겠습니까?'),
              actions: <Widget>[
                TextButton(
                  child: Text('취소'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: Text('확인'),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  void _showEditCommentDialog(BuildContext context, Comment comment,
      CommentsProvider commentsProvider) {
    TextEditingController controller =
        TextEditingController(text: comment.content);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('댓글 수정'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "댓글을 입력하세요"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: controller.text != comment.content
                  ? () async {
                      bool success = await commentsProvider.updateComment(
                          comment.comId, controller.text);
                      if (success) {
                        // 댓글 새로고침
                        commentsProvider.fetchComment();
                      }
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    }
                  : null,
              child: Text('수정'),
            ),
          ],
        );
      },
    );
  }
}

class CommentInputField extends StatelessWidget {
  final CommentsProvider commentsProvider;
  final String ownerId;
  final String authorId;

  CommentInputField(
      {Key? key,
      required this.commentsProvider,
      required this.ownerId,
      required this.authorId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return Container(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: '댓글을 입력해주세요',
          suffixIcon: IconButton(
            icon: Icon(Icons.send),
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                bool success =
                    await commentsProvider.addComment(controller.text);
                if (success) {
                  // 댓글 새로고침
                  commentsProvider.fetchComment();
                }
                controller.clear();
              }
            },
          ),
        ),
      ),
    );
  }
}
