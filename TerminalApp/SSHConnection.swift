//
//  SSHConnection.swift
//  TerminalApp
//
//  Created by Yusuke Mori on 2022/12/12.
//

import Foundation
import NMSSH

// エラー理由を列挙
enum SSHSessionError: Error {
    case authorizationFailed
    case connectFailed
}

class SSHConnection {
    
    var session: NMSSHSession
    var password: String
    
    // 初期化処理
    init(host: String, port: Int, andUsername: String, password: String) {
        session = NMSSHSession(host: host, port: port, andUsername: andUsername)
        self.password = password
    }
    
    // インスタンス破棄時にセッションを閉じる
    deinit {
        disconnect()
    }
    
    // SSH接続処理
    func connect() throws {
        guard session.connect() else { throw  SSHSessionError.connectFailed } // SSHセッションが確立できない場合エラーを返す
        session.authenticate(byPassword: password) // パスワード認証を実行
        
        // 認証失敗した場合はセッションを閉じてエラーを返す
        if(!session.isAuthorized) {
            session.disconnect()
            throw SSHSessionError.authorizationFailed
        }
        
        session.channel.requestPty = true // 疑似端末を有効化
        session.channel.ptyTerminalType = NMSSHChannelPtyTerminal.xterm // SwiftTermが動作するように端末タイプをxtermに指定
        
    }
    
    // SSH切断処理
    func disconnect() {
        session.channel.closeShell()
        session.disconnect()
    }
    
    // SSH通信開始
    func startSSHShell() {
        do {
            try session.channel.startShell()
        } catch {
            print(error)
        }
    }
    
    // SSH上でコマンドを実行、その結果を文字列で取得する処理
    func executeCommand(command: String) -> String {
        let errorPointer: NSErrorPointer = nil
        let result = session.channel.execute(command, error: errorPointer)
        return result
    }
    
    // 入力されたデータをUTF-8にエンコードして、確立したSSH上へ書き込み
    func write(data: ArraySlice<UInt8>) throws {
        guard let letter = String(bytes: data, encoding: .utf8) else { return }
        let new_data = Data(letter.utf8)
        try session.channel.write(new_data)
    }
    
    // 接続中の端末サイズの変更処理
    func requestTerminalSize(width: UInt, height: UInt) -> Bool {
        return session.channel.requestSizeWidth(width, height: height)
    }
    
    // 接続状態の判定
    func isConnected() -> Bool {
        return session.isConnected
    }
    
}
