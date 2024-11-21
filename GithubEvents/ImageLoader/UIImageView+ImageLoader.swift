import UIKit

extension UIImageView {
    func loadImage(from url: URL, placeholder: UIImage? = nil) {
        ImageLoader.shared.loadImage(from: url, placeholder: placeholder) { [weak self] image in
            guard let self else { return }
            
            if let image = image {
                self.image = image
            } else {
                self.image = placeholder
            }
        }
    }
}
