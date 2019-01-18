//
//  ViewController.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/01/18.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let canvas = CanvasView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCanvas()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.canvas.adjustCanvas(frame:self.view.bounds)
    }
    
    private func setupCanvas(){
        self.view.backgroundColor = .white
        self.view.addSubview(self.canvas)
    }
}

