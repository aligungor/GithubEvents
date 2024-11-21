import UIKit

class ImageLoader {
    static let shared = ImageLoader()
    
    private init() {}
    
    func loadImage(from url: URL, placeholder: UIImage? = nil, completion: @escaping (UIImage?) -> Void) {
        // First check if the image is cached
        if let cachedImage = ImageCache.shared.image(for: url) {
            completion(cachedImage)
            return
        }
        
        // If not in cache, fetch from network
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                // Cache the image
                ImageCache.shared.setImage(image, for: url)
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(placeholder)  // Return placeholder if image fetch fails
                }
            }
        }.resume()
    }
}
