# General HTTP client for iOS

In this repository you can find **sample HTTPClient** code for **different** cases. 

Following **SOLID** I tried to make an abstraction for **HTTPClient**. 
For the example protocol **HTTPClient** supports **Combine**, **Swift Concurrency** and **Closure**.  

The implementation of HTTPClient is a **URLSession**.

You can choose the way of networking that you **like best**.

# HTTPClient
An abstraction that will allow you to easily substitute the implementation for different cases. 
```
protocol HTTPClient {
    func publisher(request: URLRequest) -> AnyPublisher<(data: Data, response: HTTPURLResponse), Error>
    func data(request: URLRequest) async throws -> (data: Data, response: HTTPURLResponse)
    func make(request: URLRequest, _ completion: @escaping (Result<(data: Data, response: HTTPURLResponse), Error>) -> ())
}
```

If you need to use a **token** for some requests, it is better to use the **Decorator** template.
**Example:** **HTTPClient** with **Decorator** template.
```
final class AuthenticatedHTTPClientDecorator: HTTPClient {
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func publisher(request: URLRequest) -> AnyPublisher<(Data, HTTPURLResponse), Error> {
        var signedRequest = request
        
        let httpTokenKey = "your key"
        let httpTokenValue = "your value"
        
        signedRequest.addValue(httpTokenValue, forHTTPHeaderField: httpTokenKey)
        
        return client.publisher(request: signedRequest)
    }
    
    /// rest of code 
    /// ...
}
```

### This is one possible example of how to make a basic structure for query processing




