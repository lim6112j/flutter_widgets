import 'package:api_client/api_client.dart';

void main() async {
  // Create the API client
  final apiClient = createApiClient();

  try {
    // Example 1: Get all users
    print('Fetching all users...');
    final users = await apiClient.getUsers();
    print('Found ${users.length} users');
    
    // Example 2: Get a specific user
    print('\nFetching user with ID 1...');
    final user = await apiClient.getUser(1);
    print('User: ${user.name} (${user.email})');
    
    // Example 3: Get all posts
    print('\nFetching all posts...');
    final posts = await apiClient.getPosts();
    print('Found ${posts.length} posts');
    
    // Example 4: Get posts by a specific user
    print('\nFetching posts by user 1...');
    final userPosts = await apiClient.getUserPosts(1);
    print('User 1 has ${userPosts.length} posts');
    
    // Example 5: Create a new post
    print('\nCreating a new post...');
    final newPost = Post(
      userId: 1,
      id: 0, // Will be assigned by the server
      title: 'My New Post',
      body: 'This is the content of my new post.',
    );
    
    final createdPost = await apiClient.createPost(newPost);
    print('Created post with ID: ${createdPost.id}');
    
  } catch (e) {
    print('Error: $e');
  }
}
