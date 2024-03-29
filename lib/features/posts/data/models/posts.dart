// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class PostsModel {
  final String title;
  final String description;
  final String image;
  final String name;
  final Timestamp time;
  final Category category;
  PostsModel({
    required this.title,
    required this.description,
    required this.image,
    required this.name,
    required this.time,
    required this.category,
  });

  factory PostsModel.fromJson(Map<String, dynamic> json, String id) {
    return PostsModel(
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      image: json["image"] ?? "",
      name: json["name"] ?? "",
      time: json["time"] ?? "",
      category: json["category"]["name"] ?? "",
    );
  }
}

class Category {
  final String name;
  Category({
    required this.name,
  });
}
