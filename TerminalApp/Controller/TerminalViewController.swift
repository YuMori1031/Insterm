//
//  TerminalViewController.swift
//  TerminalApp
//
//  Created by Yusuke Mori on 2022/12/01.
//

import UIKit

class TerminalViewController: UIViewController {
    
    var connection: SSHConnection!
    var terminalView: SSHTerminalView!
    var hostname: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        terminalView = SSHTerminalView(connection: connection, frame: CGRect.zero)
        navigationItem.title = hostname
        
        view.addSubview(terminalView)
        terminalLayout()
        terminalView.becomeFirstResponder()
        
        terminalView.connection?.startSSHShell()
    }
    
    // 端末の回転を検知した際に画面サイズに合わせて再描画
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        terminalView.frame = CGRect(origin: terminalView.frame.origin, size: size)
    }
    
    func terminalLayout() {
        // コードでターミナル画面をAutoLayoutしたいためOFF
        terminalView.translatesAutoresizingMaskIntoConstraints = false
        
        // ターミナル画面をsafearea内に収めるよう調整
        terminalView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        terminalView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        terminalView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        // キーボードがターミナル画面の入力部を隠さないように位置調整
        terminalView.keyboardLayoutGuide.topAnchor.constraint(equalTo: terminalView.bottomAnchor).isActive = true
        
    }

    // storyboardからViewControllerを生成
    static func instantiate() -> TerminalViewController {
        let vc = UIStoryboard(name: "Terminal", bundle: nil).instantiateInitialViewController() as! TerminalViewController
        return vc
    }
    
}
