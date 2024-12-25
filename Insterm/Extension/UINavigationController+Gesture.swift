//
//  UINavigationController+Gesture.swift
//  Insterm
//
//  Created by Yusuke Mori on 2024/04/13.
//

import UIKit

// *1...navigationBarBackButtonHidden(true)を使用すると、スワイプで前画面へ戻れなくなるため、下記extensionを追加
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
