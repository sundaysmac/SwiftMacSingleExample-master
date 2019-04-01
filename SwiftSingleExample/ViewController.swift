//
//  ViewController.swift
//  SwiftSingleExample
//
//  Created by cb_2018 on 2019/1/28.
//  Copyright © 2019 cb_2018. All rights reserved.
//
import Foundation
import Cocoa


class ViewController: NSViewController,NSTextStorageDelegate {

    fileprivate let tv:NSTextView = {
        let textView = NSTextView(frame: NSMakeRect(30, 30, 200, 30))
        return textView
    }();
    fileprivate let searchField: NSSearchField = {
        let searchField = NSSearchField(frame: NSMakeRect(70, 30, 200, 30))
        return searchField
    }();
    fileprivate let customView : CustomView = {
//        let custView = NSView(frame: NSMakeRect(100, 30, 50, 50))
        let custView = CustomView()
        
        return custView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.addSubview(self.tv);
        //1设置textStorage的代理，实现NSTextStorageDelegate代理协议的textStorageDidProcessEiting方法
        //实现响应用户输入
        tv.textStorage?.delegate = self;
        
        
        /***
         textStorage存储富文本
         **/
        let attributedString = NSMutableAttributedString(string: "attringbutedString" as String)
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : NSColor.green as Any], range: NSMakeRange(0, 5))
        attributedString.addAttributes([NSAttributedString.Key.font : NSFont(name: "宋体", size: 14) as Any], range: NSMakeRange(5, 10))
        tv.textStorage?.setAttributedString(attributedString)
        
        //NSImageView
        let diameter : CGFloat = 70.0
        let imageView = NSImageView(frame: NSMakeRect(0, 0, diameter, diameter))
        imageView.image = NSImage(named: "name")
        self.view.addSubview(imageView)
        //设置圆角
        imageView.wantsLayer = true
        imageView.layer?.cornerRadius = diameter / 2.0
        imageView.layer?.backgroundColor = NSColor.green.cgColor
        imageView.layer?.masksToBounds = true
        
        
        
        //创建线型NSBox，宽度为1，设置Box内上下左右的边距
        let frameBox = CGRect(x: 15, y: 250, width: 250, height: 1)
        let boxHorizontalSeparator = NSBox(frame: frameBox)
        boxHorizontalSeparator.boxType = .separator //NSBox.BoxType.separator
        self.view.addSubview(boxHorizontalSeparator)
        //创建容器类型Box，设置边距margin，增加一个textField
        let frameBox1 = CGRect(x: 0, y: 0, width: 160, height: 100)
        let box = NSBox(frame: frameBox1)
        box.boxType = .primary
        let margin = NSSize(width: 20, height: 20)
        box.contentViewMargins = margin
        box.title = "Box"
        let frameTextField = CGRect(x: 10, y: 10, width: 80, height: 80)
        let textField = NSTextField(frame: frameTextField)
        box.contentView?.addSubview(textField)
        self.view.addSubview(box)
        
        //分栏视图
        
        
    }
    
    //leftViewWidth变量用来记忆关闭前分割线divider的位置
    var leftViewWidth: CGFloat = 0
    let splitView: NSSplitView = {
        let frameSplitView = CGRect(x: 200, y: 20, width: 200, height: 200)
        let splitView = NSSplitView(frame: frameSplitView)
        //垂直方向
        splitView.isVertical = true
        //中间分割线的样式
        splitView.dividerStyle = .thin  //NSSplitView.DividerStyle.thin
        //左边视图
        let viewLeft = NSView()
        viewLeft.wantsLayer = true
        viewLeft.layer?.backgroundColor = NSColor.green.cgColor
        //右边视图
        let viewRight = NSView()
        viewRight.wantsLayer = true
        viewRight.layer?.backgroundColor = NSColor.magenta.cgColor
        //增加左右两个视图
        splitView.addSubview(viewLeft)
        splitView.addSubview(viewRight)
        return splitView
    }()
    //添加一个按钮，此方法作为按钮的点击事件
    @objc func togglepanel(_ sender: NSButton) {
        let splitViewItem = splitView.arrangedSubviews
        //获取左边自视图
        let leftView = splitViewItem[0]
        //判断左边子视图是否已经隐藏
        if splitView.isSubviewCollapsed(leftView) {
            splitView.setPosition(leftViewWidth, ofDividerAt: 0)
            leftView.isHidden = false
        } else {
            leftViewWidth = leftView.frame.size.width
            splitView.setPosition(0, ofDividerAt: 0)
            leftView.isHidden = true
        }
        splitView.adjustSubviews()
    }
    
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    //实现NSTextStorageDelegate代理协议的textStorageDidProcessEiting方法
    func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
        //文本框高度根据文字高度自适应增长
        self.perform(#selector(self.setHeightToMatchContents), with: nil, afterDelay: 0.0)
    }
    //计算当前输入文本的高度
    func naturalSize()->NSSize {
        let bounds:NSRect = self.tv.bounds;
        let layoutManager:NSLayoutManager = self.tv.textStorage!.layoutManagers[0]
        let textContainer:NSTextContainer = layoutManager.textContainers[0]
        textContainer.containerSize = NSMakeSize(bounds.size.width, 1.0e7)
        layoutManager.glyphRange(for: textContainer)
        let naturalSize: NSSize? = layoutManager.usedRect(for: textContainer).size
        return naturalSize!
    }
    //根据文本高度修改文本框对应的滚动条高度
   @objc func setHeightToMatchContents() {
        let naturalSize: NSSize = self.naturalSize()
        if let scrollView = self.tv.enclosingScrollView {
            let frame = scrollView.frame
            scrollView.frame = NSMakeRect(frame.origin.x, frame.origin.y, frame.size.width, naturalSize.height + 4)
        }
    }
    
    
    func registerSEarchButtonAction(){
        let searchButtonCell = self.searchField.cell as! NSSearchFieldCell
        let searchButtonActionCell = searchButtonCell.searchButtonCell!
        searchButtonActionCell.target = self
        searchButtonActionCell.action = #selector(searchButtonAction(_:))
        let cancelButtonCell = self.searchField.cell as! NSSearchFieldCell
        let cancelButtonActionCell = cancelButtonCell.cancelButtonCell!
        cancelButtonActionCell.target = self
        cancelButtonActionCell.action = #selector(cancelButtonAction(_:))
    }
    
    @objc func searchButtonAction(_ sender:NSSearchField){
        
    }
    @objc func cancelButtonAction(_ sender:NSSearchField){
        sender.stringValue = ""
    }
    
    
    func addRichableLabel(){
        let text = NSString(string: "please visit http//www.apple.com/")
        let attributedString = NSMutableAttributedString(string:text as String)
        let linkURLText = "http://www.apple.com/"
        let linkURL = NSURL(string: linkURLText)
        //查找字符窜范围
        let selectedRange = text.range(of: linkURLText)
        attributedString.beginEditing()
        //设置连接属性
//        attributedString.addAttributes([NSAttributedString.Key.link : linkURL as Any], range: selectedRange)
        attributedString.addAttribute(NSAttributedString.Key.link, value: linkURL as Any, range: selectedRange)
        //设置文件颜色
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: NSColor.blue, range: selectedRange)
        //设置文本下画线
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: selectedRange)
        attributedString.endEditing()
        let frame = CGRect(x: 50, y: 50, width: 280, height: 80)
        let rechTextLabel = NSTextField(frame: frame)
        rechTextLabel.isEditable = false
        rechTextLabel.isBezeled = false
        rechTextLabel.drawsBackground = false
        rechTextLabel.attributedStringValue = attributedString
        self.view.addSubview(rechTextLabel)
        
    }
    
    //注册视图的frame变换通知和对应的处理方法
    func registerNofication() {
        NotificationCenter.default.addObserver(self, selector: #selector(recieveFrameChangeNotificaiton(_:)), name: NSView.frameDidChangeNotification, object: customView)
    }
    @objc func recieveFrameChangeNotificaiton(_ notificaiton: Notification){
        let newFrame = customView.frame;
    }
    
    
    func scrollToPoint() {
        let sframe = CGRect(x: 0, y: 0, width: 200, height: 200)
        let scrollView = NSScrollView(frame: sframe)
        let image = NSImage(named: "img.png")
        let imageViewFrame = CGRect(x: 0, y: 0, width: (image?.size.width)!, height: (image?.size.height)!)
        let imageView = NSImageView(frame: imageViewFrame)
        imageView.image = image
        scrollView.hasVerticalRuler = true
        scrollView.hasHorizontalRuler = true
        scrollView.documentView = imageView
        self.view.addSubview(imageView)
        
        //滚动到顶部位置var newScrollOrigin: NSPoint
        var newScrollOrign: NSPoint
        let contentView: NSClipView = scrollView.contentView
        if self.view.isFlipped {
            newScrollOrign = NSPoint(x: 0.0, y: 0.0)
        }else{
            newScrollOrign = NSPoint(x: 0, y: imageView.frame.size.height - contentView.frame.size.height)
        }
        contentView.scroll(to: newScrollOrign)
    }
    
    fileprivate let popUpButton : NSPopUpButton = {
        let popUpBtn = NSPopUpButton(frame: NSMakeRect(0, 0, 30, 50))
        
        return popUpBtn
    }()
    func popUpButtonFunc(){
        let items = ["1","2","3"]
        //删除初始数据
        self.popUpButton.removeAllItems()
        //增加数据
        self.popUpButton.addItem(withTitle: "4")
        self.popUpButton.addItems(withTitles: items)
        //设置第一行数据为当前选中的数据
        self.popUpButton.selectItem(at: 0)
        //添加事件
        self.popUpButton.target = self
        self.popUpButton.action = #selector(popUpBtnAction(_:))
    }
    //popUpButton事件
    @objc func popUpBtnAction(_ sender: NSPopUpButton){
        let items = sender.itemTitles
        //当前选择的index
        let index = sender.indexOfSelectedItem
        //选择的文本内容
        let title = items[index]
    }
    
    
    
    
    func comBox(){
        let m_combobox = NSComboBox(frame: NSMakeRect(0, 0, 200, 300))
        m_combobox.target = self
        //1.通过添加Item

        m_combobox.addItem(withObjectValue: ("Fre"));
        m_combobox.addItems(withObjectValues: ["March","April","May","June","July","August","September","Octorber"])
        m_combobox.selectItem(at: 0)
        m_combobox.selectItem(withObjectValue: "May")
//        m_combobox.selectAll(m_combobox)
        m_combobox.removeItem(at: 0)
        m_combobox.removeItem(withObjectValue: "May")
        m_combobox.removeAllItems()
        
        m_combobox.usesDataSource = true
        m_combobox.dataSource = self
        m_combobox.delegate = self
    }
    
    fileprivate var dataSource:NSMutableArray = {
        var dataSource = NSMutableArray(array: ["Any","小王"])
        return dataSource
    }()
    
    
    fileprivate var datePicer: NSDatePicker = {
        let datePicer = NSDatePicker(frame: NSMakeRect(0, 0, 300, 300))
        datePicer.wantsLayer = true
        //设置当前日期
        let components = NSDateComponents()
        components.day = 5
        components.month = 01
        components.year = 2016
        components.hour = 19
        components.minute = 30
        let calendar = NSCalendar.current
        let newDate = calendar.date(from: components as DateComponents)
        datePicer.dateValue = newDate!
        //设置最小日期
        datePicer.minDate = newDate
        //设置最大日期
        let date = NSDate()
        datePicer.maxDate = date as Date
        datePicer.action = #selector(updateDateResult(datePicer:))
        
        return datePicer
    }()
    
    @objc func updateDateResult(datePicer:NSDatePicker) {
        //拿到当前日期
        let theDate = datePicer.dateValue
        
        //把日期转化为制定格式
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: theDate)
        NSLog("dataString-----\(dateString)")
    }
    //步进器
    fileprivate let stepper : NSStepper = {
        let stepper = NSStepper(frame: NSMakeRect(0, 0, 100, 40))
        stepper.wantsLayer = true
        //设置背景色
        stepper.layer?.backgroundColor = NSColor.cyan.cgColor
        //最小值
        stepper.minValue = 5
        //最大值
        stepper.maxValue = 10
        //步长
        stepper.increment = 0.2
        //循环，YES - 超过最小值，回到最大值；超过最大值，来到最小值。
        stepper.valueWraps = false
        //默认为YES-用户交互时会立即放松ValueChanged事件，NO 则表示只有等用户交互结束时才放松ValueChanged事件
        stepper.isContinuous = false
        ///默认为 YES-按住加号或减号不松手，数字会持续变化.continuous = NO 时才有意义。
        stepper.autorepeat = true
        stepper.action = #selector(stepperAction(sender:))
        return stepper
    }()
    
    @objc func stepperAction(sender: NSStepper) {
        let theValue = sender.intValue
        let theFloatValue = sender.floatValue
        
    }
    
    //进入指示器NSProgressIndicator
    fileprivate let progressIndicator : NSProgressIndicator = {
        let indicator = NSProgressIndicator(frame: NSMakeRect(40, 50, 100, 10))
        indicator.style = .spinning     // NSProgressIndicator.Style.spinning
        indicator.layer?.backgroundColor = NSColor.cyan.cgColor
        indicator.controlSize = .regular        //NSControl.ControlSize.regular
        indicator.sizeToFit()
        
        return indicator
    }()
    fileprivate var count:Double?
    fileprivate var showTimer: Timer?
    
    func startAnimationProgressIndicator() {
        self.progressIndicator.isHidden = false
        self.progressIndicator.startAnimation(nil)
    }
    func stopAnimationProgressIndicator() {
        self.progressIndicator.isHidden = true
        self.progressIndicator.startAnimation(nil)
    }
    
    
}

//通过数据源设置数据
extension ViewController:NSComboBoxDelegate,NSComboBoxDataSource{
    
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        
        return self.dataSource.count
    }
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        return self.dataSource[index]
    }
    func comboBox(_ comboBox: NSComboBox, indexOfItemWithStringValue string: String) -> Int {
        return dataSource.index(of:string)
    }
    
    func comboBoxSelectionDidChange(_ notification: Notification) {
        let comBox = notification.object as! NSComboBox
        let selectedIndex = comBox.indexOfSelectedItem
        let selectedContent = comBox.stringValue
        print("selectedIndex = \(selectedIndex) selectedContent = \(selectedContent)")
    }
    
}


class SplistView: NSSplitView {
    /****
     只修改 divider的颜色。 dividerColor是只读属性,通过 NSSplit View子类重置 divider Color
     的颜色即可
     **/
    override var dividerColor: NSColor{
        return NSColor.red
    }
    /****
     重绘外观。通过分栏视图子类实现 drawDivider方法即可
     下面的代码重绘了 divider,做了一个圆角矩形的图形,使用黄色填充,蓝色作为边框的颜色
     **/
    override func drawDivider(in rect: NSRect) {
        let rectDivider = rect.insetBy(dx: 1, dy: 1)
        let path = NSBezierPath(roundedRect: rectDivider, xRadius: 3, yRadius: 3)
        NSColor.blue.setStroke()
        path.stroke()
        NSColor.yellow.setFill()
        path.fill()
        
    }
}

//实现NSSplitViewDelegate协议方法实现分栏视图控制的例子
extension ViewController: NSSplitViewDelegate {
    //只允许左边视图拉伸移动
    func splitView(_ splitView: NSSplitView, canCollapseSubview subview: NSView) -> Bool {
        if subview == splitView.subviews[0] {
            return true
        }
        return false
    }
    //向左移动拉伸距离最小为30
    func splitView(_ splitView: NSSplitView, constrainMinCoordinate proposedMinimumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
        return 30
    }
    //向右移动拉伸最大值为100
    func splitView(_ splitView: NSSplitView, constrainMaxCoordinate proposedMaximumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
        return 100
    }
    //允许调整子视图
    func splitView(_ splitView: NSSplitView, shouldAdjustSizeOfSubview view: NSView) -> Bool {
        return true
    }
    //调整子视图大小
    func splitView(_ splitView: NSSplitView, resizeSubviewsWithOldSize oldSize: NSSize) {
        
    }
    //允许拉伸移动子视图最小化后隐藏分割线
    func splitView(_ splitView: NSSplitView, shouldHideDividerAt dividerIndex: Int) -> Bool {
        return true
    }
    //视图Size变化的通知
    func splitViewDidResizeSubviews(_ notification: Notification) {
        
    }
    func splitViewWillResizeSubviews(_ notification: Notification) {
        
    }
}

