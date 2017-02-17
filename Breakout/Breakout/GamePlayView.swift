//
//  GamePlayView.swift
//  Breakout
//
//  Created by Yulia Vasenina on 05/01/2017.
//  Copyright © 2017 Yulia Vasenina. All rights reserved.
//

import UIKit

class GamePlayView: UIView {

    private struct Constants{
        static let brickHeight: CGFloat = 25.0
        static let brickSpacing: CGFloat = 5.0
        static let bricksTopSpacing: CGFloat = 20.0
        static let brickSideSpacing: CGFloat = 10.0
        static let paddleBoundaryId = "paddleBoundary"
        static let PaddleBottomMargin: CGFloat = 30.0
        static let PaddleWidthPercentage: Int = 33
        static let PaddleHeight: Int = 15
    }
    
    var behavior = BreakoutBehavior()
    
    var bricks =  [Int:BrickView]()
    
    lazy var paddle: PaddleView = {
        let frame = CGRect(x: -1, y: -1, width: Int(self.bounds.size.width), height: 15)
        let paddle = PaddleView(frame: frame)
        self.addSubview(paddle)
        return paddle;
    }()
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        resetPaddlePosition()
        // Помещаем balls обратно в breakoutView после автовращения
        /*for ball in balls {
            if !self.bounds.contains(ball.frame) {
                placeBallBack(ball: ball)
            }
        }*/
    }
    
    
    // BRICKS
    
    func createBricks(arrangement: [[Int]]) {
        
        if arrangement.count == 0 { return }    // no rows
        if arrangement[0].count == 0 { return } // no columns
        
        let rows = arrangement.count
        
        for row in 0 ..< rows {
            let columns = arrangement[row].count
            
            for column in 0 ..< columns {
                if arrangement[row][column] == 0 { continue }
                
                let width = (self.bounds.size.width - 2 * Constants.brickSpacing) / CGFloat(columns)
                let x = Constants.brickSpacing + CGFloat(column) * width
                let y = Constants.bricksTopSpacing + CGFloat(row) * Constants.brickHeight + CGFloat(row) * Constants.brickSpacing * 2
                createBrick(width: width, x: x, y: y)
            }
        }
    }
    
    func createBrick(width: CGFloat, x: CGFloat, y: CGFloat) {
        var frame = CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: width, height: Constants.brickHeight))
        frame = frame.insetBy(dx: Constants.brickSpacing, dy: 0)
        
        let brick = BrickView(frame: frame)
        bricks[bricks.count] = brick
        
        addSubview(brick)
        //behavior.addBoundary( UIBezierPath(roundedRect: brick.frame, cornerRadius: brick.layer.cornerRadius), named: (bricks.count - 1) )
    }
    
    //PADDLE
    
    var paddleWidthPercentage :Int = Constants.PaddleWidthPercentage {
        didSet{
            if  paddleWidthPercentage == oldValue{ return}
            resetPaddleInCenter()
        }
    }
    
    private var paddleSize : CGSize {
        let width = self.bounds.size.width / 100.0 * CGFloat(paddleWidthPercentage)
        return CGSize(width: width, height: CGFloat(Constants.PaddleHeight))
    }
    
    func translatePaddle(translation: CGPoint) {
        var newFrame = paddle.frame
        newFrame.origin.x = max( min(newFrame.origin.x + translation.x, self.bounds.maxX - paddle.bounds.size.width), 0.0) // min = 0, max = maxX - paddle width
        
        /*for ball in balls {
            if CGRectContainsRect(newFrame, ball.frame) {
                return
            }
        }*/
        
        paddle.frame = newFrame;
        updatePaddleBoundary()
    }
    
    private func resetPaddleInCenter(){
        paddle.center = CGPoint.zero
        resetPaddlePosition()
    }
    
    private func resetPaddlePosition() {
        paddle.frame.size = paddleSize
        if !self.bounds.contains(paddle.frame) {
            paddle.center = CGPoint(x: self.bounds.midX, y: self.bounds.maxY - paddle.bounds.height - Constants.PaddleBottomMargin)
        } else {
            paddle.center = CGPoint(x: paddle.center.x, y: self.bounds.maxY - paddle.bounds.height - Constants.PaddleBottomMargin)
        }
        
        updatePaddleBoundary()
    }
    
    func updatePaddleBoundary() {
        behavior.addBoundary(UIBezierPath(ovalIn: paddle.frame), named: Constants.paddleBoundaryId as NSCopying)
    }
    
    func panPaddle(_ gesture: UIPanGestureRecognizer) {
        let gesturePoint = gesture.translation(in: self)
        switch gesture.state {
        case .ended: fallthrough
        case .changed:
            translatePaddle(translation: gesturePoint)
            gesture.setTranslation(CGPoint.zero, in:self)
        default: break
        }
    }
    

    //
    func reset(){
      
        resetPaddleInCenter()
    }

}
