import 'package:test/test.dart';
import 'package:dio/dio.dart';
import 'package:api_client/api_client.dart';

void main() {
  group('JsonPlaceholderApi', () {
    late JsonPlaceholderApi api;
    late Dio dio;

    setUp(() {
      dio = Dio();
      api = JsonPlaceholderApi(dio);
    });

    test('should fetch users', () async {
      final users = await api.getUsers();
      expect(users, isNotEmpty);
      expect(users.first.id, isA<int>());
      expect(users.first.name, isA<String>());
    });

    test('should fetch a single user', () async {
      final user = await api.getUser(1);
      expect(user.id, equals(1));
      expect(user.name, isNotEmpty);
    });

    test('should fetch posts', () async {
      final posts = await api.getPosts();
      expect(posts, isNotEmpty);
      expect(posts.first.id, isA<int>());
      expect(posts.first.title, isA<String>());
    });

    test('should fetch user posts', () async {
      final posts = await api.getUserPosts(1);
      expect(posts, isNotEmpty);
      expect(posts.every((post) => post.userId == 1), isTrue);
    });

    test('should create a post', () async {
      final newPost = Post(
        id: 0, // Will be assigned by server
        userId: 1,
        title: 'Test Post',
        body: 'This is a test post body',
      );

      final createdPost = await api.createPost(newPost);
      expect(createdPost.title, equals('Test Post'));
      expect(createdPost.userId, equals(1));
    });
  });
}
import 'package:test/test.dart';
import 'package:api_client/api_client.dart';

void main() {
  group('JsonPlaceholderApi', () {
    late JsonPlaceholderApi apiClient;

    setUp(() {
      apiClient = createApiClient();
    });

    test('should fetch users', () async {
      final users = await apiClient.getUsers();
      expect(users, isNotEmpty);
      expect(users.first.id, isA<int>());
      expect(users.first.name, isA<String>());
    });

    test('should fetch a specific user', () async {
      final user = await apiClient.getUser(1);
      expect(user.id, equals(1));
      expect(user.name, isNotEmpty);
      expect(user.email, contains('@'));
    });

    test('should fetch posts', () async {
      final posts = await apiClient.getPosts();
      expect(posts, isNotEmpty);
      expect(posts.first.id, isA<int>());
      expect(posts.first.title, isA<String>());
    });

    test('should fetch posts by user', () async {
      final posts = await apiClient.getUserPosts(1);
      expect(posts, isNotEmpty);
      expect(posts.every((post) => post.userId == 1), isTrue);
    });

    test('should create a post', () async {
      final newPost = Post(
        userId: 1,
        id: 0,
        title: 'Test Post',
        body: 'Test content',
      );

      final createdPost = await apiClient.createPost(newPost);
      expect(createdPost.title, equals('Test Post'));
      expect(createdPost.body, equals('Test content'));
      expect(createdPost.userId, equals(1));
    });
  });
}
