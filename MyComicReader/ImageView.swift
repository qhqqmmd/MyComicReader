//
//  ImageView.swift
//  MyComicReader
//
//  Created by zirui huang on 3/9/23.
//

import UIKit

class ImageView:UIViewController{
    
    
    @IBOutlet weak var navigationitem: UINavigationItem!
    
    @IBOutlet weak var Nbar: UINavigationItem!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    var url:URL!
    var Index:Int!
    //var Pfiles: [File]!
    
    override func viewWillAppear(_ animated: Bool) {
        scrollView.backgroundColor = backgroundcolor
        
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        //setImage()
        super.viewDidLoad()
        
        var contentHeight: CGFloat = 0
        var point: CGFloat = 0
        for file in Dfiles {
            let imageView = UIImageView(image: file.fileImage)
            imageView.contentMode = .scaleAspectFit
            let aspectRatio = imageView.frame.width / scrollView.frame.width
            //let imageViewWidth = imageView.frame.width
            let imageViewHeight = imageView.frame.height / aspectRatio //for no gap !!!
            scrollView.addSubview(imageView)
            
            if file.url == Dfiles[Index].url {
                imageView.frame = CGRect(x: 0, y: contentHeight, width: scrollView.frame.width, height: imageViewHeight)
                point = contentHeight
                
            } else {
                imageView.frame = CGRect(x: 0, y: contentHeight, width: scrollView.frame.width, height: imageViewHeight)
               
            }
            contentHeight += imageViewHeight + gap
        }
        scrollView.contentOffset = CGPoint(x: 0, y: point)
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: contentHeight)
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
                doubleTapGesture.numberOfTapsRequired = 2
                scrollView.addGestureRecognizer(doubleTapGesture)
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(_:)))
                singleTapGesture.numberOfTapsRequired = 1
                view.addGestureRecognizer(singleTapGesture)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let y = scrollView.contentOffset.y
            if y > 0 {
                navigationController?.setNavigationBarHidden(true, animated: true)
            } else {
                navigationController?.setNavigationBarHidden(true, animated: true)
            }
        }
    
    @objc func handleDoubleTap(_ sender: UITapGestureRecognizer) {
        if scrollView.transform.isIdentity {
            let scale:CGFloat = 3
            scrollView.transform = CGAffineTransform(scaleX: scale, y: scale)
            
                scrollView.contentSize = CGSize(width: scrollView.contentSize.width * scale, height: scrollView.contentSize.height * scale)
            
            scrollView.contentInset = UIEdgeInsets(top:scrollView.contentSize.height/scale/2 , left: scrollView.contentSize.width/scale/scale, bottom: .zero, right: .zero)
        } else {
            scrollView.transform = CGAffineTransform.identity
            scrollView.contentSize = CGSize(width: scrollView.contentSize.width / 3, height: scrollView.contentSize.height / 3)
            scrollView.contentInset = .zero
            
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
