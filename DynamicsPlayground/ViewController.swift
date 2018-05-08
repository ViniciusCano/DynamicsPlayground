//
//  ViewController.swift
//  DynamicsPlayground
//
//  Created by Vinícius Cano Santos on 16/05/17.
//  Copyright © 2017 Vinícius Cano Santos. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UICollisionBehaviorDelegate {
    
    let barrier = UIView(frame: CGRect(x: 0, y: 300, width: 130, height: 20))
    var collision: UICollisionBehavior!
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var firstContact = false
    var square: UIView!
    var snap: UISnapBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        square = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        
        square.backgroundColor = .gray
        view.addSubview(square)
        
        barrier.backgroundColor = .red
        view.addSubview(barrier)
        
        animator = UIDynamicAnimator(referenceView: view)
        gravity = UIGravityBehavior(items: [square])
        animator.addBehavior(gravity)
        
        collision = UICollisionBehavior(items: [square])
        collision.addBoundary(withIdentifier: "barrier" as NSCopying, for: UIBezierPath(rect: barrier.frame))
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        collision.collisionDelegate = self
        
        let itemBehaviour = UIDynamicItemBehavior(items: [square])
        itemBehaviour.elasticity = 0.6
        animator.addBehavior(itemBehaviour)
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        
        let collidingView = item as! UIView
        collidingView.backgroundColor = .yellow
        UIView.animate(withDuration: 0.3) {
            collidingView.backgroundColor = .gray
        }
        
        if (!firstContact) {
            firstContact = true
            
            let square = UIView(frame: CGRect(x: 30, y: 0, width: 100, height: 100))
            square.backgroundColor = UIColor.gray
            view.addSubview(square)
            
            collision.addItem(square)
            gravity.addItem(square)
            
            let attach = UIAttachmentBehavior(item: collidingView, attachedTo:square)
            animator.addBehavior(attach)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (snap != nil) {
            animator.removeBehavior(snap)
        }
        
        let touch = touches.first
        snap = UISnapBehavior(item: square, snapTo: (touch?.location(in: view))!)
        animator.addBehavior(snap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


