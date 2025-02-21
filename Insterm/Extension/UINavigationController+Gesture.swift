//
//  UINavigationController+Gesture.swift
//  Insterm
//
//  Created by Yusuke Mori on 2025/02/21.
//

import UIKit

// *1...戻るボタンの削除処理（navigationBarBackButtonHidden(true)）を実装するとスワイプバックが不可となるため下記の拡張処理を追加
extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1 && presentedViewController == nil
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
