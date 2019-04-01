//
//  NoScrollerScrollView.swift
//  SwiftSingleExample
//
//  Created by cb_2018 on 2019/1/30.
//  Copyright © 2019 cb_2018. All rights reserved.
//

import Foundation
import Cocoa

class NoScrollerScrollView: NSScrollView {
    //重载tile 隐藏滚动条
    override func tile() {
        super.tile()
        var hFrame = self.horizontalScroller?.frame
        hFrame?.size.height = 0
        if let hframe = hFrame {
            self.horizontalScroller?.frame = hframe
        }
        
        var vFrame = self.verticalScroller?.frame
        vFrame?.size.width = 0
        if let vframe = vFrame {
            self.verticalScroller?.frame = vframe
        }
        
    }
    //禁止一个方向上的滚动 重载scrollView
    override func scrollWheel(with event: NSEvent) {
        let f = abs(event.deltaY)
        if event.deltaX == 0.0 && f >= 0.01 {
            return
        }else if event.deltaX == 0 && f == 0.0 {
            return
        }
        else {
            super.scrollWheel(with: event)
        }
    }
    
    
}

