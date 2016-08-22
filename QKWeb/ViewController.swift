//
//  ViewController.swift
//  QKWeb
//
//  Created by mac on 16/8/18.
//  Copyright © 2016年 Jon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let titles: [String] = ["精选","CTO访谈","Java","Android","IOS","Ruby","PHP"]
    let mainScrollView = UIScrollView() //底部滚动视图
    let topScrollMenu = TopScrollMenu() //头部菜单滚动视图

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        addChildVC()
        setMainScrollView()
        setProperty()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - 设置属性
    func setProperty() {
        self.automaticallyAdjustsScrollViewInsets = false
        topScrollMenu.frame = CGRectMake(0, 20, ScreenWidth, 60)
        topScrollMenu.delegateMenu = self
        topScrollMenu.setTitles(titles)
        self.view.addSubview(topScrollMenu)
    }

    //MARK: - 设置底部滚动视图
    func setMainScrollView() {
        
        mainScrollView.frame = CGRectMake(0, 80, ScreenWidth, ScreenHeight - 80)
        mainScrollView.contentSize = CGSizeMake(ScreenWidth * CGFloat(titles.count), ScreenHeight - 80)
        mainScrollView.backgroundColor = UIColor.clearColor()
        mainScrollView.pagingEnabled = true
        mainScrollView.bounces = false
        mainScrollView.showsHorizontalScrollIndicator = false
        mainScrollView.delegate = self
        self.view.addSubview(mainScrollView)
        
        showVC(0)
    }
    
    //MARK: - 添加子控制器
    func addChildVC() {
        addChildViewController(ChoiceViewController())
        addChildViewController(TestTwoViewController())
        addChildViewController(TestThreeViewController())
        addChildViewController(TestFourViewController())
        addChildViewController(TestFiveViewController())
        addChildViewController(TestSixViewController())
        addChildViewController(TestSevenViewController())
    }
    
    //MARK: - 显示控制器的View
    func showVC(index: Int) {
        //获取当前页的坐标
        let offsetX = CGFloat(index) * ScreenWidth
        //获取当前页的控制器
        let vc = self.childViewControllers[index]
        //判断此控制器是否已经加载过了
        if vc.isViewLoaded() {return}
        //将控制器的view添加到底部控制器的view里
        vc.view.frame = CGRectMake(offsetX, 0, ScreenWidth, ScreenHeight - 80)
        mainScrollView.addSubview(vc.view)
    }
    
}

//MARK: - TopScrollMenuDelegate
extension ViewController: TopScrollMenuDelegate {
    func topScrollMenu(topScrollMenu: TopScrollMenu, index: Int) {
        //计算滚动的位置
        let offsetX = CGFloat(index) * ScreenWidth
        mainScrollView.contentOffset = CGPointMake(offsetX, 0)
        
        //给对应位置添加子控制器
        showVC(index)
    }
}

//MARK: - UIScrollViewDelegate
extension ViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        //1.计算滚动到哪一页
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        
        //2.添加子控制器到view
        showVC(index)
        
        //3.把对应的标题选中
        let currentLabel = topScrollMenu.allTitleLabel[index]
        topScrollMenu.selectLabel(currentLabel)
        
        //4.让对应的标题居中
        topScrollMenu.setupTitleCenter(currentLabel)
        
        //5.让指示器居中
        topScrollMenu.setupIndicatorCenter(currentLabel)
    }
}

