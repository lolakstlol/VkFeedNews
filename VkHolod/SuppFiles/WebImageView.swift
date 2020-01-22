
import UIKit

class WebImageView: UIImageView {
    
    func set(imageURL: String?){
        guard let imageURL = imageURL, let url = URL(string: imageURL) else {
            self.image = nil
            return }
        
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            self.image = UIImage(data: cachedResponse.data)
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, _) in
            guard let data = data else { return }
            guard let response = response else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
                self.handleLoadedImage(data: data, response: response)
            }
            
        }.resume()
    }
    
    private func handleLoadedImage(data: Data, response : URLResponse) {
        guard let responseURl = response.url else { return }
        let cahcedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cahcedResponse, for: URLRequest(url: responseURl))
    }
}
