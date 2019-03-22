//
//  Container.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/01/18.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

class ContentView: UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = MyColor.myBlue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
