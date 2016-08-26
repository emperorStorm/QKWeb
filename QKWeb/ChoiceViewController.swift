//
//  ChoiceViewController.swift
//  QKWeb
//
//  Created by mac on 16/8/20.
//  Copyright © 2016年 Jon. All rights reserved.
//

import UIKit

class ChoiceViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "HotTableViewCell", bundle: nil), forCellReuseIdentifier: "HotTableViewCell")
        configureProperty()
        setCyclePicture()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - 设置组建属性
    func configureProperty() {
        refreshControl.addTarget(self, action: #selector(ChoiceViewController.didRefresh), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    //MARK: - 下拉加载
    func didRefresh() {
        refreshControl.beginRefreshing()
        var total = 0
        for i in 0...10000 {
            total += i
        }
        refreshControl.endRefreshing()
    }
    
    //设置轮播图
    func setCyclePicture() {
        var array = [String]()
        for _ in 0..<5 {
            array.append("background")
        }
        let picture = CyclePictureView()
        picture.setCyclePicture(scrollView, pageControl: pageControl, pictureArray: array)
    }

}

//MARK: - UITableViewDataSource
extension ChoiceViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HotTableViewCell", forIndexPath: indexPath)
        return cell
    }
}

//MARK: - UITableViewDelegate
extension ChoiceViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 250
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = NSBundle.mainBundle().loadNibNamed("HotTableViewHeaderView", owner: nil, options: nil)[0] as! HotTableViewHeaderView
        return header
    }
}
