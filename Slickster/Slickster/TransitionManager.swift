//
//  TransitionManager.swift
//  Slickster
//
//  Created by NonGT on 9/12/2558 BE.
//  Copyright (c) 2558 Donoma Solutions. All rights reserved.
//

import UIKit

class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate  {
    
    var reverse:Bool = false
    var presenting:Bool = false
    var useScreenSize:Bool = false
    var duration:NSTimeInterval = 0.5
    
    convenience init(useScreenSize: Bool, duration: NSTimeInterval) {
    
        self.init()
        
        self.useScreenSize = useScreenSize
        self.duration = duration
    }

    // MARK: UIViewControllerAnimatedTransitioning protocol methods
    
    // animate a change from one viewcontroller to another
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

        // get reference to our fromView, toView and the container view that we should perform the transition in
        let container = transitionContext.containerView()
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        // set up from 2D transforms that we'll use in the animation
        var offScreenRight = CGAffineTransformMakeTranslation(container!.frame.width, 0)
        var offScreenLeft = CGAffineTransformMakeTranslation(-container!.frame.width, 0)
        
        if useScreenSize {
        
            let screenSize: CGRect = UIScreen.mainScreen().bounds
            offScreenRight = CGAffineTransformMakeTranslation(screenSize.width, 0)
            offScreenLeft = CGAffineTransformMakeTranslation(-screenSize.width, 0)
        }
        
        if(!reverse) {
            
            if (self.presenting) {
                toView.transform = offScreenRight
            } else {
                toView.transform = offScreenLeft
            }
            
        } else {
            
            if (self.presenting) {
                toView.transform = offScreenLeft
            } else {
                toView.transform = offScreenRight
            }
        }
        
        // add the both views to our view controller
        container!.addSubview(toView)
        container!.addSubview(fromView)
        
        // get the duration of the animation
        // DON'T just type '0.5s' -- the reason why won't make sense until the next post
        // but for now it's important to just follow this approach
        let duration = self.transitionDuration(transitionContext)
        
        // perform the animation!
        // for this example, just slid both fromView and toView to the left at the same time
        // meaning fromView is pushed off the screen and toView slides into view
        // we also use the block animation usingSpringWithDamping for a little bounce
        UIView.animateWithDuration(duration, delay: 0.0, options: [], animations: {
            
            if(!self.reverse) {
                
                if (self.presenting) {
                    fromView.transform = offScreenLeft
                } else {
                    fromView.transform = offScreenRight
                }
                
            } else {
                
                if (self.presenting) {
                    fromView.transform = offScreenRight
                } else {
                    fromView.transform = offScreenLeft
                }
            }

            toView.transform = CGAffineTransformIdentity
            
            }, completion: { finished in
                
                // tell our transitionContext object that we've finished animating
                transitionContext.completeTransition(true)      
            })
    }
    
    // return how many seconds the transiton animation will take
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        
        return self.duration
    }
    
    // MARK: UIViewControllerTransitioningDelegate protocol methods
    
    // return the animataor when presenting a viewcontroller
    // remmeber that an animator (or animation controller) is any object that aheres to the UIViewControllerAnimatedTransitioning protocol
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        self.presenting = true
        return self
    }
    
    // return the animator used when dismissing from a viewcontroller
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        self.presenting = false
        return self
    }
}
