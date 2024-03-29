import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xmed/core/exception/server_exception.dart';
import 'package:xmed/features/posts/data/models/posts.dart';

abstract class PostsRemoteDataSource {
  Future<List<PostsModel>> getPosts();

  factory PostsRemoteDataSource() => _PostRemoteDataSource();
}

class _PostRemoteDataSource implements PostsRemoteDataSource {
  @override
  Future<List<PostsModel>> getPosts() async {
    try {
      final firebase = FirebaseFirestore.instance;
      final collection = await firebase.collection("posts").get();
      final posts = collection.docs
          .map((e) => PostsModel.fromJson(e.data(), e.id))
          .toList();
      return posts;
    } on ServerException catch (error) {
      throw ServerException(
          errorMessage: error.errorMessage, errorCode: error.errorCode);
    }
  }
}
