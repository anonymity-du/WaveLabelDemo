//
//  ViewController.swift
//  WaveLabel-Swift
//
//  Created by 杜奎 on 2019/7/24.
//  Copyright © 2019 du. All rights reserved.
//

import UIKit

let kWaveWidth: CGFloat = 100

class ViewController: UIViewController {
    
    private var offset: Int = 0
    private var speed: CGFloat = 6
    private var displayLink: CADisplayLink?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.bgView)
        
        self.bgView.addSubview(self.label)
        self.bgView.addSubview(self.upLabel)
        self.label.center = CGPoint.init(x: self.bgView.frame.width * 0.5, y: self.bgView.frame.height * 0.5)
        self.upLabel.center = self.label.center
        
        self.bgView.layer.insertSublayer(self.waveLayer, below: self.label.layer)
        self.upLabel.layer.mask = self.shapeLayer
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.displayLink = CADisplayLink.init(target: self, selector: #selector(waveAction))
        self.displayLink?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.displayLink != nil {
            self.displayLink?.invalidate()
            self.displayLink = nil
        }
    }
    
    func updateWave(with width: CGFloat, height: CGFloat) {
        
        let degree: CGFloat = CGFloat.pi/180.0
        
        let wavePath = CGMutablePath()
        wavePath.move(to: CGPoint.init(x: 0, y: height))
        
        var offsetX: CGFloat = 0
        while offsetX < width {
            let offsetY = height * 0.5 + 10 * sin(offsetX * degree + CGFloat(self.offset) * degree * self.speed)
            wavePath.addLine(to: CGPoint.init(x: offsetX, y: offsetY))
            offsetX += 1.0
        }
        
        wavePath.addLine(to: CGPoint.init(x: width, y: height))
        wavePath.addLine(to: CGPoint.init(x: 0, y: height))
        wavePath.closeSubpath()
        
        self.waveLayer.path = wavePath
        waveLayer.fillColor = kColorWithHex(0xA28DFF).cgColor
        self.shapeLayer.path = wavePath
    }
    
    //MARK:- action
    
    @objc private func waveAction() {
        self.offset += 1
        
        let width: CGFloat = self.view.frame.width
        let height: CGFloat = self.view.frame.height
        
        self.updateWave(with: width, height: height)
    }
    
    //MARK:- setter & getter
    
    private lazy var bgView: UIView = {
        let view = UIView.init(frame: self.view.bounds)
        view.backgroundColor = UIColor.white
        return view
    }()
    
    private lazy var waveLayer: CAShapeLayer = {
        let layer = CAShapeLayer.init()
        layer.frame = CGRect.init(x: 0, y: 0, width: kWaveWidth, height: kWaveWidth)
        return layer
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel.init()
        label.text = "Wave Label"
        label.font = UIFont.boldSystemFont(ofSize: 60)
        label.textColor = kColorWithHex(0xA28DFF)
        label.sizeToFit()
        return label
    }()
    
    private lazy var upLabel: UILabel = {
        let label = UILabel.init()
        label.text = "Wave Label"
        label.font = UIFont.boldSystemFont(ofSize: 60)
        label.textColor = UIColor.white
        label.sizeToFit()
        return label
    }()
    
    private lazy var shapeLayer: CAShapeLayer = {
        let maskLayer = CAShapeLayer.init()
        maskLayer.bounds = self.bgView.bounds
        maskLayer.position = CGPoint.init(x: self.label.bounds.width * 0.5, y: self.label.bounds.height * 0.5)
        return maskLayer
    }()
    
}

func kRGBA (r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

func kColorWithHex(_ hex: UInt) -> UIColor {
    return kColorWithHex(hex, 1)
}

func kColorWithHex(_ hex: UInt,_ alpha: CGFloat) -> UIColor {
    let r: CGFloat = CGFloat((hex & 0xff0000) >> 16)
    let g: CGFloat = CGFloat((hex & 0x00ff00) >> 8)
    let b: CGFloat = CGFloat(hex & 0x0000ff)
    return kRGBA(r: r, g: g, b: b, a: alpha)
}


