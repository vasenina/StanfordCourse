//
//  BreakoutBehavior.swift
//  Breakout
//
//  Created by Yulia Vasenina on 04/02/2017.
//  Copyright © 2017 Yulia Vasenina. All rights reserved.
//

import UIKit

class BreakoutBehavior: UIDynamicBehavior, UICollisionBehaviorDelegate{
 
    private lazy var collider: UICollisionBehavior = {
        let lazyCollider = UICollisionBehavior()
        lazyCollider.translatesReferenceBoundsIntoBoundary = false
        lazyCollider.collisionDelegate = self
        lazyCollider.action = { [unowned self] in
            
           /* for ball in self.balls {
                if !self.dynamicAnimator!.referenceView!.bounds.intersects(ball.frame){
                    self.leftPlayingField?( ball as BallView)
                }
                
                self.ballBehavior.limitLinearVelocity(min: Constants.Ball.MinVelocity,
                                                      max: Constants.Ball.MaxVelocity,
                                                      forItem: ball as BallView)
            }*/
        }
        return lazyCollider
    }()
    
    override init() {
        super.init()
        
    }
    
    func addBoundary(_ path: UIBezierPath, named identifier: NSCopying) {
        removeBoundary(identifier)
        collider.addBoundary(withIdentifier: identifier, for: path)
    }
    
    func removeBoundary (_ identifier: NSCopying) {
        collider.removeBoundary(withIdentifier: identifier)
    }
    
}
