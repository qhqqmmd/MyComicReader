//
//  DetilView.swift
//  MyComicReader
//
//  Created by zirui huang on 3/8/23.
//

import UIKit

class DetilView: UICollectionViewController {
    
    
    
    
    //var Dfiles: [File] = []
    var url:URL!
    
    @objc func zoom(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .changed {
            // 获取缩放比例
            let scale = sender.scale
            
            // 更新集合视图单元格大小
            let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.itemSize = CGSize(width: 100 * scale, height: 120 * scale)
            
        }
    }

    
    override func viewDidLoad() {
        //print(url)
        //images.removeAll()
        Dfiles.removeAll()
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(zoom(_:)))

        collectionView.addGestureRecognizer(pinchGesture)
        super.viewDidLoad()
        
        // 加载file class对象到files数组中
        
        // 设置UICollectionView的布局方式
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 120)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        collectionView.collectionViewLayout = layout
        //collectionView.reloadData()
        AlllistImage(inDirectory: url)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Reload collection view data
        //AlllistImage(inDirectory: url)//if I put here the image will view twice
        collectionView.reloadData()
    }
    
    
    
    
    var imageReferences = [UIImage]()
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        for file in Dfiles {
            imageReferences.append(file.fileImage!)
        }

        return Dfiles.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let file = Dfiles[indexPath.item]
        let selectedImage = file.fileImage
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: file.type.rawValue, for: indexPath) as! MyCustomCollectionViewCell
        
        // 将file对象的标题和图片分别添加到单元格的子视图中
        cell.myImageView.image = selectedImage
        cell.myTitleLabel.text = file.name
        //cell.myImageView.image = file.fileImage
        //images.append(selectedImage!)
        cell.index = indexPath.item
        
        return cell
    }
    
    /*override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedImage = Dfiles[indexPath.item].fileImage
        let fullScreenController = ImageViewController(image: selectedImage)
        present(fullScreenController, animated: true, completion: nil)
    }*/
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ImageView {
            let cell = sender as! MyCustomCollectionViewCell
            let index = collectionView.indexPath(for: cell)!.item
            let url = cell.url
            let nextVC = segue.destination as! ImageView
            nextVC.Index = index
            nextVC.url = url
        }
        else if segue.destination is PageView {
            let cell = sender as! MyCustomCollectionViewCell
            let index = collectionView.indexPath(for: cell)!.item
            let nextVC = segue.destination as! PageView
            nextVC.currentIndex = index
            //nextVC.url = url
        }
    }
    
    
}
