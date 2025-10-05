# SKBaseService

[![Swift Version](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%2013%2B-blue.svg)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/License-MIT-lightgrey.svg)](https://opensource.org/licenses/MIT)

`SKBaseService` is a lightweight, modern, and easy-to-use networking library for Swift. It's designed to simplify network requests in your personal projects by handling the boilerplate code, so you can focus on building your app's features.

## ✨ Features

-   🚀 **Generic Requests:** Make network calls for any `Codable` model with a single, powerful function.
-   🔒 **Type-Safe:** Leverages Swift's `Result` type for clean, compile-time safe handling of success and failure cases.
-   ⚠️ **Clear Error Handling:** A centralized `NetworkError` enum provides descriptive and easy-to-manage error states.
-   ✅ **All HTTP Methods:** Supports `.get`, `.post`, `.put`, `.delete`, and `.patch` right out of the box.
-   📦 **Lightweight & Simple:** No external dependencies. Just pure Swift using `URLSession`.
-    Singleton pattern for easy access from anywhere in your project.

## ⚙️ Installation

You can easily add `SKBaseService` to your project using **Swift Package Manager**.

1.  In your Xcode project, go to `File > Add Packages...`
2.  In the search bar, paste the URL of this repository:
    ```
    https://github.com/sametkorkmaaz/SKBaseService.git
    ```
3.  For the "Dependency Rule", select **"Up to Next Major Version"** and click **"Add Package"**.

## 🚀 Usage

Making network requests is incredibly simple. Just define your data model, create a URL, and call the request function.

### Step 1: Define Your Data Model

First, create a `Codable` struct that matches the JSON structure of your API response.

```swift
// Example: A model for a blog post
struct Post: Codable {
    let id: Int
    let title: String
    let body: String
}
```

### Step 2: Make a GET Request

To fetch data, specify the expected return type (e.g., `[Post].self` for an array of posts) and handle the result.

```swift
import SKBaseService

func fetchPosts() {
    guard let url = URL(string: "[https://jsonplaceholder.typicode.com/posts](https://jsonplaceholder.typicode.com/posts)") else { return }
    
    SKBaseService.shared.request(url: url) { (result: Result<[Post], NetworkError>) in
        switch result {
        case .success(let posts):
            print("✅ Successfully fetched \(posts.count) posts.")
            // Now you can update your UI with the 'posts' array
        case .failure(let error):
            print("❌ Failed to fetch posts: \(error.localizedDescription)")
            // Show an error alert to the user
        }
    }
}
```

### Step 3: Make a POST Request

To send data, provide the HTTP method and an `Encodable` object as the `body`.

```swift
import SKBaseService

func createPost() {
    guard let url = URL(string: "[https://jsonplaceholder.typicode.com/posts](https://jsonplaceholder.typicode.com/posts)") else { return }
    
    // The new object you want to send
    let newPost = Post(id: 101, title: "My New Post", body: "This is a test.")
    
    SKBaseService.shared.request(url: url, method: .post, body: newPost) { (result: Result<Post, NetworkError>) in
        switch result {
        case .success(let createdPost):
            print("✅ Successfully created post with title: \(createdPost.title)")
            // Handle the successful creation
        case .failure(let error):
            print("❌ Failed to create post: \(error.localizedDescription)")
            // Handle the error
        }
    }
}
```

## Error Handling

`SKBaseService` makes error handling transparent. The `NetworkError` enum provides clear cases for what could go wrong:

-   `.invalidURL`
-   `.requestFailed(Error)`
-   `.invalidResponse`
-   `.invalidStatusCode(Int)`
-   `.noData`
-   `.decodingFailed(Error)`
-   `.unknownError`

You can easily handle these in the `.failure` case of your result to provide meaningful feedback to the user.

## 📝 License

This project is licensed under the MIT License. See the `LICENSE` file for more details.
