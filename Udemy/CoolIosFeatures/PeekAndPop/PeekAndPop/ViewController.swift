//
//  ViewController.swift
//  PeekAndPop
//
//  Created by Aliona on 30/01/2018.
//  Copyright © 2018 Aliona. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIViewControllerPreviewingDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: view)
        } else {
            print("No force touch for this device")
        }
    }

    // MARK: - UIViewControllerPreviewingDelegate
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        return storyboard?.instantiateViewController(withIdentifier: "Peek")
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: "Pop") else {
            return
        }
        show(viewController, sender: self)
    }
}

