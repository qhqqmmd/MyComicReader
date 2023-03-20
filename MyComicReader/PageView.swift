//
//  PageView.swift
//  MyComicReader
//
//  Created by zirui huang on 3/10/23.
//

import UIKit

class PageView: UIViewController, UIScrollViewDelegate{

    //var Dfiles: [File] = []
    var currentIndex = 0
    
    @IBOutlet weak var Nbar: UINavigationItem!
    
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: view.bounds.width * CGFloat(Dfiles.count), height: view.bounds.height)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        //let backgroundImageView = UIImageView(image: UIImage(named: "background"))
        //backgroundImageView.frame = scrollView.bounds
        //scrollView.insertSubview(backgroundImageView, at: 0)

        
        return scrollView
    }()

    /*let image = imageView.image!
    let currentFilter = CIFilter(name: "CIPhotoEffectMono")
    currentFilter!.setValue(CIImage(image: image), forKey: kCIInputImageKey)
    
    let output = currentFilter!.outputImage
    let cgimg = context.createCGImage(output!, from: output!.extent)
    let processedImage = UIImage(cgImage: cgimg!)
    
    imageView.image = processedImage*/
    override func viewDidLoad() {
        super.viewDidLoad()
            view.addSubview(scrollView)
            let context = CIContext(options: nil)
            
            for (index, file) in Dfiles.enumerated() {
                let imageView = UIImageView(image: file.fileImage)
                
                imageView.contentMode = .scaleAspectFit
                imageView.frame = CGRect(x: view.bounds.width * CGFloat(index), y: 0, width: view.bounds.width, height: view.bounds.height)
                scrollView.addSubview(imageView)
            }

        loadNextImage()
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
                doubleTapGesture.numberOfTapsRequired = 2
                scrollView.addGestureRecognizer(doubleTapGesture)
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(_:)))
                singleTapGesture.numberOfTapsRequired = 1
                view.addGestureRecognizer(singleTapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        scrollView.backgroundColor = backgroundcolor
        super.viewWillAppear(animated)
    }

    func loadNextImage() {
        guard currentIndex < Dfiles.count - 1 else {
            return
        }

        let nextIndex = currentIndex + 1
        let nextFile = Dfiles[nextIndex]
        guard let nextImage = nextFile.fileImage else {
            return
        }
        let nextImageView = UIImageView(image: nextImage)
        nextImageView.contentMode = .scaleAspectFit
        nextImageView.frame = CGRect(x: view.bounds.width * CGFloat(nextIndex), y: 0, width: view.bounds.width, height: view.bounds.height)
        scrollView.addSubview(nextImageView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentIndex = Int(round(scrollView.contentOffset.x / view.bounds.width))
        loadNextImage()
    }
    @objc func handleDoubleTap(_ sender: UITapGestureRecognizer) {
        if scrollView.transform.isIdentity {
            let scale:CGFloat = 3
            scrollView.transform = CGAffineTransform(scaleX: scale, y: scale)
            
           } else {
               scrollView.transform = CGAffineTransform.identity
           }
    }
    @objc func handleSingleTap(_ sender: UITapGestureRecognizer) {
        if ((Nbar.hidesBackButton) == true){
            Nbar.hidesBackButton = false
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.tabBarController?.tabBar.isHidden = false

        }
        else{
            Nbar.hidesBackButton = true
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.tabBarController?.tabBar.isHidden = true

        }
    }
    
    
}


    
    

