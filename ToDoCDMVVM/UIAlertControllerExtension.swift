//
//  UIAlertControllerExtension.swift
//  ToDoCDMVVM
//
//  Created by Никита Чечнев on 10.05.2023.
//

import UIKit

extension UIAlertController {
    
    func show(animated: Bool = true, completion: (() -> Void)? = nil) {
        if let visibleViewController = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController {
          visibleViewController.present(self, animated: animated, completion: completion)
            
        }
      }
}
