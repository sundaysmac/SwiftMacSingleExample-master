//
//  CustomView.swift
//  SwiftSingleExample
//
//  Created by cb_2018 on 2019/1/29.
//  Copyright © 2019 cb_2018. All rights reserved.
//

import Foundation
import Cocoa

class CustomView: NSView {
    
    
    /****1.
     在drawRect方法中绘制
    使用Quartz2D绘图函数在视图上绘制圆角矩形
 ****/
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        NSColor.blue.setFill()
        let frame = self.bounds
        let path = NSBezierPath()
        path.appendRoundedRect(frame, xRadius: 10, yRadius: 10)
        path.fill()
    }
    
    /***2
     在drawRect方法之外实现绘制，需要使用lockFocus方法锁定视图，完成绘图后在执行unlockFocus解锁
     drawRect方法与lockFocus锁定方式不能同时使用
     ***/
    func drawViewShape(){
        self.lockFocus()
        let text: NSString = "RoundedRect"
        let font = NSFont(name: "Palatino-Roman", size: 12)
        let attrs = [NSAttributedString.Key.font: font,NSAttributedString.Key.foregroundColor:NSColor.red]
        let location = NSPoint(x: 50, y: 50)
        text.draw(at: location, withAttributes: attrs)
        self.unlockFocus()
    }
    /****3
     视图截屏
     ***/
    func saveSelfAsImage() {
        self.lockFocus()
        let image = NSImage(data: self.dataWithPDF(inside: self.bounds))
        self.unlockFocus()
        let imageData = image!.tiffRepresentation
        let fileManager = FileManager.default
        //制定文件路径
        let path = "/Users/.../Documents/myCapture.png"
        fileManager.createFile(atPath: path, contents: imageData, attributes: nil)
        //保存结束后Finder中自动定位到文件路径
        let fileUrl = URL(fileURLWithPath: path)
        NSWorkspace.shared.activateFileViewerSelecting([fileUrl])
    }
        
        //如果视图比较大，是带滚动条的大视图，则按下面的方法处理可以保证获得整个滚动页面的截图
    func saveScrollViewAsImage() {
        //
        let pdfdata = self.dataWithPDF(inside: self.bounds)
//        self.dataWithEPS(inside: self.bounds)  ？？？？
        let imageRep = NSPDFImageRep(data: pdfdata)!
        let count = imageRep.pageCount
        for i in 0..<count {
            imageRep.currentPage = i
            let tempImage = NSImage()
            tempImage.addRepresentation(imageRep)
            let rep = NSBitmapImageRep(data: tempImage.tiffRepresentation!)
            let imageData = rep?.representation(using: NSBitmapImageRep.FileType.png, properties: [:])
            //NSBitmapImageRep.PropertyKey : Any
            let fileManager = FileManager.default
            //制定文件路径
            let path = "/Users/.../Documents/myCapture.png"
            fileManager.createFile(atPath: path, contents: imageData, attributes: nil)
            //保存结束后Finder中自动定位到文件路径
            let fileUrl = URL(fileURLWithPath: path)
            NSWorkspace.shared.activateFileViewerSelecting([fileUrl])
            
        }
    }
    
    
    
}
