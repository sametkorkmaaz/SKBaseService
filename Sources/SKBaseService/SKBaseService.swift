// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public final class SKBaseService {

    @MainActor
    public static let shared = SKBaseService()
    private init() {}

    public func request<T: Decodable>(
        url: URL,
        method: HTTPMethod = .get,
        body: (any Encodable)? = nil,
        completion: @escaping @MainActor (Result<T, NetworkError>) -> Void
    ) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let body = body {
            do {
                request.httpBody = try JSONEncoder().encode(body)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.decodingFailed(error)))
                }
                return
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(.requestFailed(error)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(.invalidResponse))
                    return
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(.invalidStatusCode(httpResponse.statusCode)))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.noData))
                    return
                }
                
                do {
                    let decodedObject = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedObject))
                } catch {
                    completion(.failure(.decodingFailed(error)))
                }
            }
        }
        task.resume()
    }
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}
