//
//  TopScrollMenu.swift
//  QKWeb
//
//  Created by mac on 16/8/18.
//  Copyright © 2016年 Jon. All rights reserved.
//
/**
    顶部滚动菜单栏：
        1.菜单居中
        2.菜单形状变化
        3.指示器变化
 */
import UIKit

//MARK: - TopScrollMenuDelegate传递: 1.控件本身 2.被点击的label的下标
protocol TopScrollMenuDelegate {
    func topScrollMenu(topScrollMenu: TopScrollMenu, index: Int)
}

let LabelFontOfSize: UIFont = UIFont.systemFontOfSize(18)       //字体大小
let labelMargin: CGFloat = 10                                   //label间距
let indicatorHeight: CGFloat = 3                                //指示器的高度
let radio:CGFloat = 1.1                                         //缩放比例

class TopScrollMenu: UIScrollView {
    
    var selectedLabel = UILabel()   //被点击的Lable
    let indicatorView = UIView()    //指示器
    var titlesArray = [String]()      //标题字符串数组
    var allTitleLabel = [UILabel]() //存入所有的Lable
    var delegateMenu:TopScrollMenuDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.bounces = false
        self.showsHorizontalScrollIndicator = false
        self.backgroundColor = UIColor(colorLiteralRed: 51 / 255, green: 128 / 255, blue: 252 / 255, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - 设置Lable
    func setTitles(titles: [String]) {
        titlesArray = titles
        var labelX: CGFloat = 0
        let labelY: CGFloat = 0
        let labelH: CGFloat = self.frame.size.height - indicatorHeight
        
        for index in 0..<titlesArray.count {
            let titleLabel = UILabel()
            
            //使Lable可交互、点击
            titleLabel.userInteractionEnabled = true
            titleLabel.text = self.titlesArray[index]
            
            //设置高亮颜色
            titleLabel.highlightedTextColor = UIColor.whiteColor()
            titleLabel.textAlignment = .Center
            titleLabel.tag = index
            
            //根据字符串获取字符串的size
            let labelSize = getTextRectSize(titleLabel.text!, font: LabelFontOfSize, size: CGSizeMake(CGFloat(MAXFLOAT), labelY))
            
            //计算label的宽度
            let labelW = labelSize.width + 2 * labelMargin
            titleLabel.frame = CGRectMake(labelX, labelY, labelW, labelH)
            
            //计算每个label的X
            labelX += labelW
            
            //将label添加到label的数组里
            allTitleLabel.append(titleLabel)
            
            //给label添加手势
            let tap = UITapGestureRecognizer(target: self, action: #selector(TopScrollMenu.titleClick(_:)))
            titleLabel.addGestureRecognizer(tap)
            
            //默认是第一个label
            if index == 0 {titleClick(tap)}
            
            self.addSubview(titleLabel)
        }
        
        //计算scrollView的宽度
        let scrollViewWidth = CGRectGetMaxX((self.subviews.last?.frame)!)
        self.contentSize = CGSizeMake(scrollViewWidth, self.frame.height)
        
        //添加指示器
        let firstLabel = self.subviews.first
        indicatorView.backgroundColor = UIColor.whiteColor()
        indicatorView.center.x = (firstLabel?.center.x)!
        indicatorView.frame.origin.y = self.frame.size.height - indicatorHeight
        indicatorView.frame.size.width = (firstLabel?.frame.size.width)! - 2 * labelMargin
        indicatorView.frame.size.height = indicatorHeight
        self.addSubview(indicatorView)
        
    }
    
    //MARK: - 获取字符串宽度和长度
    func getTextRectSize(text: NSString, font: UIFont, size: CGSize) -> CGRect {
        let attributes = [NSFontAttributeName: font]
        let option = NSStringDrawingOptions.UsesLineFragmentOrigin
        let rect:CGRect = text.boundingRectWithSize(size, options: option, attributes: attributes, context: nil)
        return rect;
    }
    
    //MARK: - 点击label
    func titleClick(tap: UITapGestureRecognizer) {
        //1.选中label
        let currentLabel = tap.view as! UILabel
        
        //2.label发生形状、位置的变化
        selectLabel(currentLabel)
        
        //3.让选中的label居中
        setupTitleCenter(currentLabel)
        
        //4.指示器居中
        setupIndicatorCenter(currentLabel)
        
        //5.代理取值
        self.delegateMenu?.topScrollMenu(self, index:currentLabel.tag)
    }
    
    //MARK: - 设置选中的label的形状和位置的变化
    func selectLabel(label: UILabel) {
        UIView.animateWithDuration(0.2) {
            //取消上一个label的高亮、形变、颜色
            self.selectedLabel.highlighted = false
            self.selectedLabel.transform = CGAffineTransformIdentity
            self.selectedLabel.textColor = UIColor.blackColor()
            
            //使被点击label高亮、形变
            label.highlighted = true
            label.transform = CGAffineTransformMakeScale(radio, radio)
            self.selectedLabel = label
        }
    }
    
    //MARK: - 使标题居中
    func setupTitleCenter(centerLabel: UILabel) {
        //计算偏移量
        var offsetX = centerLabel.center.x - ScreenWidth * 0.5
        //最大滚动范围
        let maxOffserX = self.contentSize.width - ScreenWidth   //此处要注意，滚动菜单栏的宽度可能小于屏幕宽度
        
        if offsetX > maxOffserX {offsetX = maxOffserX}
        
        if offsetX < 0 {offsetX = 0}
        
        //滚动标题
        self.setContentOffset(CGPointMake(offsetX,0), animated: true)
    }
    
    //MARK: - 使指示器居中
    func setupIndicatorCenter(currentLabel: UILabel) {
        UIView.animateWithDuration(0.2) {
            //注：此处属性设置先后顺序不能颠倒，先大小，后位置
            self.indicatorView.frame.size.width = currentLabel.frame.size.width - 2 * labelMargin
            self.indicatorView.center.x = currentLabel.center.x
        }
    }
    
}
