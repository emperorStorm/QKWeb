//
//  CyclePictureView.swift
//  CyclePicture
//
//  Created by mac on 16/8/11.
//  Copyright © 2016年 mac. All rights reserved.
//

/*
    使用方法：
    实例化类对象，调用类的setCyclePicture方法
    传入参数：
        1.轮播入的scrollView
        2.轮播的pageControl
        3.轮播图片的url字符串数组
    注：
        调用此方法前需要初始化scrollView和pageControl，
        并且pageControl的numberOfPages与图片数量一致
 */

import UIKit

class CyclePictureView: NSObject, UIScrollViewDelegate {
    var timer :NSTimer!                 //定时器
    var sumArray : [String] = []        //共多少个图片
    var showArray : [String] = []       //拿出三个图片
    var imageWidth = CGFloat()          //scrollView的宽度
    var imageHeight = CGFloat()         //scrollView的高度
    var pageControl = UIPageControl()
    var scrollView = UIScrollView()

    //MARK: - 调用此方法设置轮播图片
    func setCyclePicture(scrollView: UIScrollView, pageControl: UIPageControl, pictureArray: [String]) {
        self.sumArray = pictureArray
        self.pageControl = pageControl
        self.scrollView = scrollView
        
        imageWidth = scrollView.bounds.width
        imageHeight = scrollView.bounds.height

        loadImage()
    }
  
    
    //MARK: - 加载图片
    func loadImage() {
        //获取三个imageView的url字符串数组
        changeShowArray()
        
        //根据showArray提供的数据，创建三个UIImageView
        for index in 0..<showArray.count {
            let image = UIImageView(image: UIImage(named: showArray[index]))
            image.frame = CGRect(x: CGFloat(index)*imageWidth, y: 0, width: imageWidth, height: imageHeight)
            scrollView.addSubview(image)
        }
        
        scrollView.contentSize = CGSize(width: CGFloat(sumArray.count) * imageWidth, height: imageHeight)
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        //让scrollView显示在三个UIImageView的中间位置
        scrollView.setContentOffset( CGPoint(x: imageWidth,y: 0), animated: false)
        //设置定时器
        timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(CyclePictureView.nextImage), userInfo: nil, repeats: true)
    }
    
    //MARK: - 下一张图片
    func nextImage() {
        self.scrollView.setContentOffset( CGPoint(x: CGFloat(2) * self.imageWidth,y: 0), animated: true)
    }
    
    //MARK: - 当scrollView的contentOffset发生变化时调用
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //判断是不是这个scrollView，可能存在多个scrollView的contentOffset发生变化
        if scrollView != scrollView{
            return
        }
        
        let x = scrollView.contentOffset.x
        var page = pageControl.currentPage
        //根据contentOffset.x判断page，从而获得显示内容
        if x >= 2 * imageWidth {
            page = (page + 1) % 5    //0的下一页 1，2，3，4，0
            pageControl.currentPage = page
            changeShowView()
        }else if x <= 0 {
            page = (page + 4) % 5    //0的上一页 4，3，2，1，0
            pageControl.currentPage = page
            changeShowView()
        }
    }
    
    //MARK: - 设置showArray数组里的图片
    func changeShowView() {
        changeShowArray()
        //获取scrollView的所有子元素（UIImageView），根据showArray渲染图片
        var  scrollImages = scrollView.subviews as! [UIImageView]
        for (index,imageStr) in showArray.enumerate() {
            scrollImages[index] =  UIImageView(image: UIImage(named: imageStr))
        }
        //渲染之后，重新将scrollView显示在三个UIImageView的中间位置
        scrollView.setContentOffset(CGPoint(x: imageWidth, y: 0), animated: false)
    }

    
    //MARK: - 改变showArray的数组
    func changeShowArray() {
        //根据当前页判断上下页
        let page = pageControl.currentPage
        let count = sumArray.count
        let firstPage = (page + count - 1)%count
        let lastPage = (page + 1)%count
        //根据页数重新排列showArray
        showArray.removeAll()
        showArray.append(sumArray[firstPage])
        showArray.append(sumArray[page])
        showArray.append(sumArray[lastPage])
    }
}
