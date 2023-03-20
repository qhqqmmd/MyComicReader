//
//  SettingView.swift
//  MyComicReader
//
//  Created by zirui huang on 3/10/23.
//

import UIKit

class SettingView: UIViewController{
    
    
    @IBOutlet weak var GapSlide: UISlider!
    
    @IBOutlet weak var Color: UISegmentedControl!
    
    @IBOutlet weak var BackGround: UIColorWell!
    
    @IBAction func setBackgroundColor(_ sender: UIColorWell) {
        let color: UIColor = BackGround.selectedColor ?? .tintColor
        backgroundcolor = color
    }
    
    
    @IBAction func setMyColor(_ sender: Any) {
        let selectedIndex = Color.selectedSegmentIndex
        
        if selectedIndex == 0{
            isblack = 0
            print(isblack)
        }
        else if selectedIndex == 1{
            isblack = 1
            print(isblack)
        }
    }
    

    
    @IBAction func PicGap(_ sender: UISlider) {
        print(GapSlide.value)
        gap = CGFloat(GapSlide.value)
    }
    
    override func viewDidLoad() {
        //GapSlide.maximumValue = 100
        super.viewDidLoad()
    }
}
