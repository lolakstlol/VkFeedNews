import Foundation

protocol Networking {
    func request(path: String, params: [String: String], completion: @escaping (Data?,Error?) -> Void)
}

final class NetworkingService: Networking{
    
    var authService = AuthService.shared
    
    func request(path: String, params: [String: String], completion: @escaping (Data?, Error?) -> Void) {
        guard let token = authService.token else {return}
        var allParams = params
        allParams["access_token"] = token
        allParams["v"] = API.version
        let url = getURL(from: path, params: allParams)
        let request = URLRequest(url: url)
        let task = createDataTask(from: request, completion: completion)
        task.resume()
        print(url)
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request, completionHandler: { (data, responce, error) in
            DispatchQueue.main.async {
                completion(data,error)
            }  
        })
    }
    
    private func getURL(from path: String, params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.path = path
        components.queryItems = params.map{ URLQueryItem(name: $0, value: $1) }
        return components.url!
    }
}
