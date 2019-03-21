//
//  MenuButton.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/02/18.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

class MenuButton:UIButton{
    private var iconImage = UIImage()
    private var iconImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setView(icon: UIImage){
        self.iconImage = icon
        self.backgroundColor = .clear
        self.iconImageView.frame.size = CGSize(width: self.frame.height * 0.6,
                                               height: self.frame.height * 0.6)
        self.iconImageView.frame.origin.x = self.frame.height * 0.2
        self.iconImageView.frame.origin.y = self.frame.height * 0.2
        self.iconImageView.image = self.iconImage
        self.addSubview(self.iconImageView)
        self.showsTouchWhenHighlighted = true
    }
}
