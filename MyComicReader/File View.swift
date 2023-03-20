//
//  File View.swift
//  MyComicReader
//
//  Created by zirui huang on 3/6/23.
//


import UIKit

class FileView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
}
