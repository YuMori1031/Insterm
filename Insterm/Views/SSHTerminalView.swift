//
//  SSHTerminalView.swift
//  Insterm
//
//  Created by Yusuke Mori on 2024/01/09.
//

import UIKit
import SwiftUI
import SwiftTerm
import NMSSH

struct SSHTerminalView: View {
    var model: SSHTerminalModel
    
    var body: some View {
        VStack {
            VStack {
                AdmobBannerView()
                NavigationStack {
                    UIKitSSHTerminalViewWrapper(connection: model.connection)
                }
                .navigationBackButton()
                .navigationBarTitle(Text(model.hostname), displayMode: .inline)
            }
        }
    }
}

struct UIKitSSHTerminalViewWrapper: UIViewRepresentable {
    var connection: SSHConnection
    
    func makeUIView(context: Context) -> UIKitSSHTerminalView {
        let view = UIKitSSHTerminalView(connection: connection, frame: CGRect.zero)
        view.connection = self.connection
        return view
    }
    
    func updateUIView(_ uiView: UIKitSSHTerminalView, context: Context) {}
}

class UIKitSSHTerminalView: TerminalView, TerminalViewDelegate, NMSSHChannelDelegate {
    var connection: SSHConnection?
    var isPreview: Bool { // プレビュー実行時の判定プロパティ
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
    
    // 初期化処理
    init(connection: SSHConnection?, frame: CGRect) {
        super.init(frame: frame)
        self.connection = connection
        terminalDelegate = self // TerminalViewDelegateを適用
        connection?.session.channel.delegate = self // NMSSHChannelDelegateを適用
        
        // SSHシェルを実行　※プレビュー時にクラッシュするため、プレビュー環境のみ実行させない
        if !isPreview {
            connection?.startSSHShell()
        }
        
        try? connection?.write(data: [0x08][...]) // バックスペースのASCIIコードをArraySliceに変換して書き込み
        _ = becomeFirstResponder() // SwiftTermの拡張キーボードを表示
        addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(pinchInOut))) // ピンチ操作を適用
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
    
    func isConnected() -> Bool {
        return connection?.isConnected() ?? false
    }
    
    // ピンチイン・アウトでフォントサイズを変更
    @objc func pinchInOut(_ gestureRecognizer: UIPinchGestureRecognizer) {
        guard gestureRecognizer.state == .began || gestureRecognizer.state == .changed else { return }
        let newSize = font.pointSize * gestureRecognizer.scale
        gestureRecognizer.scale = 1.0
        
        if newSize >= 10 && newSize <= 40  {
            font = UIFont.monospacedSystemFont(ofSize: newSize, weight: .regular)
        }
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
    
    func rangeChanged(source: SwiftTerm.TerminalView, startY: Int, endY: Int) {}
}

#Preview {
    let dummyCredentials = SSHSetupModel(hostname: "192.168.0.1", port: 22, username: "test", password: "***")
    let dummyConnection = SSHConnection(credentials: dummyCredentials)
    let model = SSHTerminalModel(connection: dummyConnection, hostname: "Test Host")
    NavigationStack {
        SSHTerminalView(model: model)
    }
}
