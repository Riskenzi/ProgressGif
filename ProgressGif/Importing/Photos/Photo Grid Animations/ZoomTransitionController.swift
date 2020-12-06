//
//  ZoomTransitionController.swift
//  FluidPhoto
//
//  Created by Masamichi Ueta on 2016/12/29.
//  Copyright © 2016 Masmichi Ueta. All rights reserved.
//

import UIKit

// MARK: - From the open-source library FluidPhoto: https://github.com/masamichiueta/FluidPhoto
/// for animating the transition between the collection view and the paging preview
class ZoomTransitionController: NSObject {
    
    let animator: ZoomAnimator
    let interactionController: ZoomDismissalInteractionController
    var isInteractive: Bool = false
    var deletedLast: Bool = false

    weak var fromDelegate: ZoomAnimatorDelegate?
    weak var toDelegate: ZoomAnimatorDelegate?
    
    override init() {
        animator = ZoomAnimator()
        interactionController = ZoomDismissalInteractionController()
        super.init()
    }
    
    func didPanWith(gestureRecognizer: UIPanGestureRecognizer) {
        self.interactionController.didPanWith(gestureRecognizer: gestureRecognizer)
    }
}

extension ZoomTransitionController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.animator.isPresenting = true
        self.animator.fromDelegate = fromDelegate
        self.animator.toDelegate = toDelegate
        
        return self.animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.animator.isPresenting = false
        let tmp = self.fromDelegate
        self.animator.fromDelegate = self.toDelegate
        self.animator.toDelegate = tmp
      
        return self.animator
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        if !self.isInteractive || self.deletedLast {
            return nil
        }
        
        self.interactionController.animator = animator
        return self.interactionController
    }

}
