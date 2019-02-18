//
//  MenuButton.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/02/18.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

class MenuButton:UIButton{
    private var name:String = "name"
    private var iconImage = UIImage()
    private var iconImageView = UIImageView()
    private var nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setView(name: String, icon: UIImage){
        self.name = name
        self.iconImage = icon
        self.backgroundColor = .clear
        self.iconImageView.frame.size = CGSize(width: self.frame.height * 0.6,
                                               height: self.frame.height * 0.6)
        self.iconImageView.frame.origin.x = self.frame.height * 0.2
        self.iconImageView.frame.origin.y = self.frame.height * 0.2
        self.iconImageView.image = self.iconImage
        self.addSubview(self.iconImageView)
        
        self.nameLabel.frame = CGRect(x: self.frame.height * 1.2,
                                      y: 0,
                                      width: self.frame.width - self.frame.height * 1.2,
                                      height: self.frame.height)
        self.nameLabel.text = self.name
        self.nameLabel.textColor = .white
        self.addSubview(self.nameLabel)
    }
}
