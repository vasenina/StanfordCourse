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
    }
    
    var bricks =  [Int:BrickView]()
    
    
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
    


}
