//
//  LoginViewController.swift
//  TerminalApp
//
//  Created by Yusuke Mori on 2022/12/01.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var connectButton: UIButton! {
        didSet {
            connectButton.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @objc func tapButton(_: UIResponder) {
        let tv = TerminalViewController.instantiate()
        self.navigationController?.pushViewController(tv, animated: true)
    }
    
}
