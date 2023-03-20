//
//  CollectionView.swift
//  MyComicReader
//
//  Created by zirui huang on 3/8/23.
//
import UIKit

class MyCustomCollectionViewCell: UICollectionViewCell {
    
    
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myTitleLabel: UILabel!
    var url:URL!
    var index:Int!
    
    
    
}


class CollectionView: UICollectionViewController {

   

    @IBOutlet var multipletouch: UIPinchGestureRecognizer!
    
    
    
    
    
    var lastScale: CGFloat = 1.0

    @objc func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "Page View") as! PageView
            
            let navigationController = UINavigationController(rootViewController: destinationVC)
            UIApplication.shared.keyWindow?.rootViewController = navigationController
            
            
        }
    }
    
    @objc func zoom(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .changed {
            // 获取缩放比例
            let scale = sender.scale
            let currentScale = lastScale * scale

            // 更新集合视图单元格大小
            let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.itemSize = CGSize(width: 200 * currentScale, height: 240 * currentScale)

            lastScale = scale
        }
    }


    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Reload collection view data
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(zoom(_:)))

        collectionView.addGestureRecognizer(pinchGesture)
        // 设置UICollectionView的布局方式
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 120)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        collectionView.collectionViewLayout = layout
        //collectionView.reloadData()

    }

    // 实现numberOfItemsInSection方法，返回files数组中元素的数量
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return files.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let file = files[indexPath.item]
            

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: file.type.rawValue, for: indexPath) as! MyCustomCollectionViewCell

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        cell.addGestureRecognizer(longPressGesture)
        //let image = UIImage(contentsOfFile: file.url.path)
        //file.fileImage = image
        cell.myTitleLabel.text = file.name
        cell.myImageView.image = file.fileImage
        
        cell.url = file.url
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is DetilView {
            if let cell = sender as? MyCustomCollectionViewCell, let url = cell.url {
                
                let nextVC = segue.destination as! DetilView
                nextVC.url = url
            }
        }
        
        else if segue.destination is PageView {
            if let cell = sender as? MyCustomCollectionViewCell, let url = cell.url {
                if Dfiles.isEmpty{
                    Dfiles.removeAll()
                    AlllistImage(inDirectory: url)
                }
            }
        }
        
        
    }
    
}
