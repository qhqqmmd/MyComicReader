//
//  ImageViewController.swift
//  MyComicReader
//
//  Created by zirui huang on 3/9/23.
//

import Foundation
import UIKit

class ImageViewController: UIViewController {
    
    var imge: UIImage?
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    init(image: UIImage?) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(imageView)
        imageView.image = image
        imageView.frame = view.bounds
    }
}
