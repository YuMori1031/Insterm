//
//  LoginViewController.swift
//  TerminalApp
//
//  Created by Yusuke Mori on 2022/12/01.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var hostname: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var port: UITextField!
    
    @IBOutlet weak var connectButton: UIButton! {
        didSet {
            connectButton.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @objc func tapButton(_: UIResponder) {
        if hostname.text == "" || username.text == "" || password.text == "" || port.text == "" {
            let alert = UIAlertController(title: "入力エラー", message: "全ての項目は必須入力です", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            
            alert.addAction(ok)
            
            present(alert, animated: true, completion: nil)
        } else {
            let tv = TerminalViewController.instantiate()
            self.navigationController?.pushViewController(tv, animated: true)
        }
    }
    
}
