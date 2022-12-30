//
//  SSHTerminalView.swift
//  TerminalApp
//
//  Created by Yusuke Mori on 2022/12/17.
//

import Foundation
import SwiftTerm
import NMSSH

class SSHTerminalView: TerminalView, TerminalViewDelegate, NMSSHChannelDelegate {
    
    var connection: SSHConnection?
    
    // 初期化処理
    init(connection: SSHConnection?, frame: CGRect) {
        super.init(frame: frame)
        self.connection = connection
        connection?.session.channel.delegate = self // NMSSHChannelDelegateを適用
        terminalDelegate = self // TerminalViewDelegateを適用
    }
    
    // Swiftの仕様でUIViewを継承したサブクラス（この場合はTerminalViewになる）で、上記のような初期化を定義すると下記メソッドの実装が必須となる模様
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // SSHで受信したデータをターミナル上に非同期で表示する
    func channel(_ channel: NMSSHChannel, didReadData message: String) {
        DispatchQueue.main.sync {
            self.feed(text: message)
        }
    }
    
    // データ受信時にエラーとなった場合に表示する
    func channel(_ channel: NMSSHChannel, didReadError error: String) {
        print("didReadError: \(error)")
    }
    
    // 以下はTerminalViewDelegate適用時に実装する必要のある各種メソッド
    public func scrolled(source: TerminalView, position: Double) {}
    
    public func setTerminalTitle(source: TerminalView, title: String) {}
    
    public func sizeChanged(source: TerminalView, newCols: Int, newRows: Int) {
        _ = connection?.requestTerminalSize(width: UInt(newCols), height: UInt(newRows))
    }
    
    public func hostCurrentDirectoryUpdate(source: TerminalView, directory: String?) {}
    
    public func send(source: TerminalView, data: ArraySlice<UInt8>) {
        do {
            try connection?.write(data: data)
        } catch {
            print(error)
        }
    }
    
    public func clipboardCopy(source: SwiftTerm.TerminalView, content: Data) {
        if let str = String (bytes: content, encoding: .utf8) {
            UIPasteboard.general.string = str
        }
    }
    
    public func requestOpenLink(source: SwiftTerm.TerminalView, link: String, params: [String : String]) {
        if let fixedup = link.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if let url = NSURLComponents(string: fixedup) {
                if let nested = url.url {
                    UIApplication.shared.open (nested)
                }
            }
        }
    }
    
}
