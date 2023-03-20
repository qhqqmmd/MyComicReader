//
//  filemanager.swift
//  MyComicReader
//
//  Created by zirui huang on 3/6/23.
//


import UIKit

class filemanager: UIViewController{

    @IBOutlet weak var tableView: UITableView!

        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
        }
    
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
}
