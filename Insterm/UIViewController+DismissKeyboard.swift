//
//  UIViewController+DismissKeyboard.swift
//  Insterm
//
//  Created by Yusuke Mori on 2022/12/25.
//

// UIViewControllerを拡張して、画面の他の場所をタップするとキーボードを閉じる処理の実装

import UIKit

extension UIViewController {
    func setDismissKeyboard() {
        
        // 画面のどこかがタップされた時に dismissKeyboard()関数を呼び出す、UITapGestureRecognizerを定義
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        // UITapGestureRecognizer がジェスチャーを受け取った以降のタップ関連のイベントも実行されるようにcancelsTouchesInViewをfalseに設定
        tapGR.cancelsTouchesInView = false
        
        // ViewControllerのViewに、生成したUITapGestureRecognizerを追加
        self.view.addGestureRecognizer(tapGR)
    }
    
    // view階層の中のファーストレスポンダーの有無を確認し、ある場合はresignFirstResponder() メソッド実行してキーボードを閉じる。
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
