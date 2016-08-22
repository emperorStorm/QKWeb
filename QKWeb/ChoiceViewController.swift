//
//  ChoiceViewController.swift
//  QKWeb
//
//  Created by mac on 16/8/20.
//  Copyright © 2016年 Jon. All rights reserved.
//

import UIKit

class ChoiceViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        var array = [String]()
        for _ in 0..<5 {
            array.append("background")
        }
        let picture = CyclePictureView()
        picture.setCyclePicture(scrollView, pageControl: pageControl, pictureArray: array)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
