import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/user.dart';
import '../models/post.dart';

part 'json_placeholder_api.g.dart';

@RestApi(baseUrl: "https://jsonplaceholder.typicode.com")
abstract class JsonPlaceholderApi {
  factory JsonPlaceholderApi(Dio dio, {String baseUrl}) = _JsonPlaceholderApi;

  @GET("/users")
  Future<List<User>> getUsers();

  @GET("/users/{id}")
  Future<User> getUser(@Path("id") int id);

  @GET("/posts")
  Future<List<Post>> getPosts();

  @GET("/posts/{id}")
  Future<Post> getPost(@Path("id") int id);

  @GET("/users/{userId}/posts")
  Future<List<Post>> getUserPosts(@Path("userId") int userId);

  @POST("/posts")
  Future<Post> createPost(@Body() Post post);

  @PUT("/posts/{id}")
  Future<Post> updatePost(@Path("id") int id, @Body() Post post);

  @DELETE("/posts/{id}")
  Future<void> deletePost(@Path("id") int id);

  @GET("/posts")
  Future<List<Post>> getPostsWithQuery(
    @Query("userId") int? userId,
    @Query("_limit") int? limit,
  );
}
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/user.dart';
import '../models/post.dart';

part 'json_placeholder_api.g.dart';

@RestApi(baseUrl: 'https://jsonplaceholder.typicode.com')
abstract class JsonPlaceholderApi {
  factory JsonPlaceholderApi(Dio dio, {String baseUrl}) = _JsonPlaceholderApi;

  @GET('/users')
  Future<List<User>> getUsers();

  @GET('/users/{id}')
  Future<User> getUser(@Path('id') int id);

  @GET('/posts')
  Future<List<Post>> getPosts();

  @GET('/posts/{id}')
  Future<Post> getPost(@Path('id') int id);

  @GET('/users/{userId}/posts')
  Future<List<Post>> getUserPosts(@Path('userId') int userId);

  @POST('/posts')
  Future<Post> createPost(@Body() Post post);

  @PUT('/posts/{id}')
  Future<Post> updatePost(@Path('id') int id, @Body() Post post);

  @DELETE('/posts/{id}')
  Future<void> deletePost(@Path('id') int id);
}
