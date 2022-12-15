//
//  TerminalViewController.swift
//  TerminalApp
//
//  Created by Yusuke Mori on 2022/12/01.
//

import UIKit
import SwiftTerm
import NMSSH

class TerminalViewController: UIViewController {
    
    var connection: SSHConnection?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // storyboardからViewControllerを生成
    static func instantiate() -> TerminalViewController {
        let vc = UIStoryboard(name: "Terminal", bundle: nil).instantiateInitialViewController() as! TerminalViewController
        return vc
    }

}
