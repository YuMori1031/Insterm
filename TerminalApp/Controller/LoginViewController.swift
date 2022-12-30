//
//  LoginViewController.swift
//  TerminalApp
//
//  Created by Yusuke Mori on 2022/12/01.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var session: SSHConnection? // SSHセッション
    var sshQueue: DispatchQueue? // SSH接続処理キュー
    
    var indicator = UIActivityIndicatorView()
    
    let loadingView = UIView(frame: UIScreen.main.bounds) // SSH接続中に表示するためのロード画面
    
    @IBOutlet weak var hostname: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var port: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var connectButton: UIButton! {
        didSet {
            connectButton.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // returnキーでキーボードを非表示にするため、各入力フォームにUITextFieldDelegateを設定
        hostname.delegate = self
        username.delegate = self
        password.delegate = self
        
        portNumberPadDone() // ポート番号の入力キーにキーボードを閉じるボタンを設定
        
        showIndicator() // インジケーター表示
        
        setDismissKeyboard() // 画面のどこかをタップするとキーボードを閉じる
        
        setUpKeyboard() // 入力フォームをタップするとキーボードを入力フォーム下に表示
    }
    
    // テキストフィールド入力時にreturnキーを押すとキーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // 入力フォームがキーボードで隠れないように位置調整
    func setUpKeyboard() {
        view.keyboardLayoutGuide.topAnchor.constraint(greaterThanOrEqualTo: scrollView.bottomAnchor, constant: 10).isActive = true
    }
    
    // インジケーター設定
    func showIndicator() {
        indicator.center = view.center
        indicator.style = .large
        indicator.color = .white
        indicator.hidesWhenStopped = true
        
        loadingView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        loadingView.addSubview(indicator) // ロード画面にインジケーターを追加
    }
    
    func portNumberPadDone() {
        // inputAccesoryViewに入れるtoolbar
        let toolbar = UIToolbar()
        
        // 完了ボタンを右寄せにする為に、左側を埋めるスペース作成
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // 完了ボタンを作成
        let done = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(didTapDoneButton))
        
        // toolbarのitemsに作成したスペースと完了ボタンを追加
        toolbar.items = [space, done]
        toolbar.sizeToFit()
        
        // 作成したtoolbarをportのinputAccessoryViewに入れる
        port.inputAccessoryView = toolbar
    }
    
    // ポート番号入力時に完了ボタンを押すとキーボードを閉じる
    @objc func didTapDoneButton() {
        port.resignFirstResponder()
    }

    @objc func tapButton(_: UIResponder) {
        guard let host = hostname.text, !host.isEmpty, let user = username.text, !user.isEmpty, let pass = password.text, !pass.isEmpty, let portNum = port.text, !portNum.isEmpty else {
            let alert = Alert(title: "入力エラー", message: "全ての項目は必須入力です")
            present(alert.controller, animated: true, completion: nil)
            return
        }
        
        view.addSubview(loadingView) // ロード画面を表示
        indicator.startAnimating() // インジケーターのアニメーション開始
        
        sshQueue = DispatchQueue(label: "SSH Queue")
        
        session = SSHConnection(host: host, port: Int(portNum)!, andUsername: user, password: pass)
        
        // SSH接続処理を実行
        // エラー内容に応じてアラートを表示、処理完了後にインジケーターを停止
        sshQueue?.async {
            // SSH接続処理が完了後、スコープを抜ける際にインジケーターのアニメーション停止とロード画面を削除
            defer {
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                    self.loadingView.removeFromSuperview()
                }
            }
            
            do {
                try self.session?.connect()
                DispatchQueue.main.async {
                    let tv = TerminalViewController.instantiate()
                    tv.connection = self.session // セッション情報をTerminalViewControllerへ値渡し
                    tv.hostname = self.hostname.text // ホスト名をTerminalViewControllerへ値渡し
                    self.navigationController?.pushViewController(tv, animated: true)
                }
            } catch SSHSessionError.connectFailed {
                DispatchQueue.main.async {
                    let alert = Alert(title: "接続エラー", message: "ホストへ接続が出来ませんでした。")
                    self.present(alert.controller, animated: true, completion: nil)
                }
                return
            } catch SSHSessionError.authorizationFailed {
                DispatchQueue.main.async {
                    let alert = Alert(title: "認証エラー", message: "ホストとの認証に失敗しました。")
                    self.present(alert.controller, animated: true, completion: nil)
                }
                return
            } catch {
                print(error)
                return
            }
        }
    }
}
