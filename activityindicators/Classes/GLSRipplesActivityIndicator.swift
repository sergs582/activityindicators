//
//  GLSRipplesActivityIndicator.swift
//  activityindicators
//
//  Created by Moises Anthony Aranas on 7/15/15.
//  Copyright © 2015 ganglion software. All rights reserved.
//

import UIKit

class GLSRipplesActivityIndicator: UIView {

    fileprivate var animating : Bool = false
    fileprivate var _color : UIColor? = UIColor.gray
    
    /**
    If true, the activity indicator becomes hidden when stopped.
    */
    var hidesWhenStopped : Bool = false
    var circles : [UIView] = []
    
    /**
    The color to be used for the indicator.
    */
    var color : UIColor? {
        get
        {
            return _color!
        }
        set
        {
            _color = newValue
            if let unwrappedColor = _color {
                for index in 0...3
                {
                    let currentBar : UIView = self.circles[index]
                    currentBar.layer.borderColor = unwrappedColor.cgColor
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override required init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    /**
    Common initializer logic for the ripples indicator.
    */
    fileprivate func commonInit() {
        self.backgroundColor = UIColor.clear
        let circleWidth = min(self.bounds.size.width,self.bounds.size.height);
        let circleHeight = circleWidth
        let cornerRadius = circleWidth/2
        let borderWidth = (circleWidth * 0.2)
        for _ in 0...3
        {
            let currView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: circleWidth, height: circleHeight))
            currView.backgroundColor = UIColor.clear
            currView.layer.cornerRadius = cornerRadius
            currView.layer.borderColor = UIColor.gray.cgColor
            currView.layer.borderWidth = borderWidth
            self.circles.append(currView)
            self.addSubview(currView)
        }
    }
    
    /**
    Starts the ripples animation.
    */
    func startAnimating() {
        if self.isAnimating()
        {
            return
        }
        self.layer.isHidden = false
        self.animating = true
        
        var animationMin = 0.2
        let animationDiffs = (1.0 - animationMin) / Double(self.circles.count)
        let animationKeyframeDiffs = 1.0 / Double(self.circles.count)
        for index in 0...3
        {
            let currentCircle : UIView = self.circles[index]
            let animationX = CAKeyframeAnimation(keyPath: "transform.scale.x")
            let animationY = CAKeyframeAnimation(keyPath: "transform.scale.y")
            let animationAlpha = CAKeyframeAnimation(keyPath: "opacity")
            var values : [Double] = []
            var startValue = animationMin
            for _ in 0...self.circles.count
            {
                if startValue > 1.0
                {
                    startValue = 0.2
                }
                values.append(startValue)
                startValue += animationDiffs
            }
            animationMin += animationDiffs
            animationX.values = values
            animationY.values = values
            animationAlpha.values = values.map {
                (scaleVal) -> Double in
                return 1.0 - scaleVal
            }
            var animationStart = 0.0
            var keyFrames : [Double] = []
            for _ in 0...self.circles.count
            {
                keyFrames.append(animationStart)
                animationStart += animationKeyframeDiffs
            }
            animationX.keyTimes = keyFrames as [NSNumber]
            animationX.calculationMode = kCAAnimationPaced
            animationX.repeatCount = Float.infinity
            animationX.duration = 3.0
            animationX.autoreverses = true
            currentCircle.layer.add(animationX, forKey: "animationX\(index)")
            
            animationY.keyTimes = keyFrames as [NSNumber]
            animationY.calculationMode = kCAAnimationPaced
            animationY.repeatCount = Float.infinity
            animationY.duration = 3.0
            animationY.autoreverses = true
            currentCircle.layer.add(animationY, forKey: "animationY\(index)")
            
            animationAlpha.keyTimes = keyFrames as [NSNumber]
            animationAlpha.calculationMode = kCAAnimationPaced
            animationAlpha.repeatCount = Float.infinity
            animationAlpha.duration = 3.0
            animationAlpha.autoreverses = true
            currentCircle.layer.add(animationAlpha, forKey: "animationAlpha\(index)")
        }
    }
    
    /**
    Stops the ripples animation.
    */
    func stopAnimating() {
        if !self.isAnimating()
        {
            return
        }
        self.animating = false
        self.layer.isHidden = self.hidesWhenStopped
        for index in 0...3
        {
            let currentCircle : UIView = self.circles[index]
            currentCircle.layer.removeAllAnimations()
        }
    }
    
    /**
    Returns if the ripples is animating.
    
    *returns* - A boolean indicator if the animation is in progress.
    */
    func isAnimating() -> Bool {
        return self.animating
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let circleWidth = min(self.bounds.size.width,self.bounds.size.height);
        let circleHeight = circleWidth
        let cornerRadius = circleWidth/2
        for index in 0...3
        {
            let currentCircle : UIView = self.circles[index]
            currentCircle.frame = CGRect(x: 0, y: 0, width: circleWidth, height: circleHeight)
            currentCircle.layer.cornerRadius = cornerRadius
        }
    }

}
