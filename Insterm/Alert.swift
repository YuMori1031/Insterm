//
//  Alert.swift
//  Insterm
//
//  Created by Yusuke Mori on 2022/12/15.
//

import UIKit

class Alert {
    
    var title: String
    var message: String
    
    // 初期化処理
    init(title: String, message: String) {
        self.title = title
        self.message = message
    }
    
    var controller: UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { (action) in
            self.controller.dismiss(animated: true)
        })
        
        return alert
    }
    
}
