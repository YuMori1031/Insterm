//
//  SSHSetupView.swift
//  Insterm
//
//  Created by Yusuke Mori on 2023/11/30.
//

import SwiftUI

struct SSHSetupView: View {
    @State private var hostname: String = ""
    @State private var port: String = "22"
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var connection: SSHConnection?
    @State private var isShowingTerminal = false
    @State private var isShowingPassword: Bool = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isConnecting = false
    
    private enum Field: Hashable {
        case hostname, port, username, password
    }
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        ZStack {
            NavigationStack {
                formView
            }
            .navigationDestination(isPresented: $isShowingTerminal, destination: {
                if let sshConnection = connection {
                    let model = SSHTerminalModel(connection: sshConnection, hostname: hostname)
                    SSHTerminalView(model: model)
                }
            })
            .alert(isPresented: $showAlert) {
                Alert(title: Text(String(localized: "Connection Error")), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .opacity(isConnecting ? 0.5 : 1.0)
            
            // isConnectingがtrueの場合にのみProgressViewを表示
            if isConnecting {
                ZStack {
                    Color.black.opacity(0.5) // 背景を半透明の黒に
                        .edgesIgnoringSafeArea(.all) // 画面の端まで広げる
                    
                    VStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5) // インジケータのサイズを調整
                        
                        Text(String(localized: "Connecting...")) // インジケータの下にテキストを表示
                            .foregroundColor(.white)
                            .padding(.top, 20) // テキストとインジケータの間隔
                    }
                    .frame(width: 150, height: 150) // VStackのサイズを設定
                    .background(Color.black.opacity(0.8)) // VStackの背景を黒に
                    .cornerRadius(20) // 角を丸くする
                }
            }
        }
    }

    var formView: some View {
        VStack {
            AdmobBannerView()
            Form {
                Section(header: Text(String(localized: "SSH Server")).textCase(nil)) {
                    HStack {
                        Text(String(localized: "Host"))
                            .frame(width: 80, alignment: .leading)
                        TextField(String(localized: "IP or domain"), text: $hostname)
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.leading)
                            .autocapitalization(.none)
                            .padding()
                            .focused($focusedField, equals: .hostname)
                    }
                    HStack {
                        Text(String(localized: "Port"))
                            .frame(width: 80, alignment: .leading)
                        TextField(String("22"), text: $port)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.leading)
                            .padding()
                            .focused($focusedField, equals: .port)
                            .onChange(of: port) {
                                // 数字のみかつ5桁以内の文字列に制限
                                let filtered = port.filter { "0123456789".contains($0) }
                                if filtered != port || filtered.count > 5 {
                                    port = String(filtered.prefix(5))
                                }
                            }
                    }
                }
                Section(header: Text(String(localized: "Authentication")).textCase(nil)) {
                    HStack {
                        Text(String(localized: "Username"))
                        .frame(width: 80, alignment: .leading)
                        TextField(String("admin"), text: $username)
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.leading)
                            .autocapitalization(.none)
                            .padding()
                            .focused($focusedField, equals: .username)
                    }
                    HStack {
                        Text(String(localized: "Password"))
                        .frame(width: 80, alignment: .leading)
                        passwordField
                    }
                }
            }
            .navigationBackButton()
            .navigationBarTitle(String(localized: "SSH Setup"), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button(String(localized: "Done")) {
                            focusedField = nil
                        }
                    }
                }
            }
            .onTapGesture {
                focusedField = nil
            }
            connectButton
        }
    }

    var passwordField: some View {
        Group {
            if isShowingPassword {
                TextField(String(""), text: $password)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.leading)
                    .autocapitalization(.none)
                    .padding()
                    .focused($focusedField, equals: .password)
            } else {
                SecureField(String(""), text: $password)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.leading)
                    .autocapitalization(.none)
                    .padding()
                    .focused($focusedField, equals: .password)
            }
            Button(action: { isShowingPassword.toggle() }, label: {
                Image(systemName: isShowingPassword ? "eye" : "eye.slash")
            })
            .buttonStyle(.plain)
            .foregroundColor(.blue)
        }
    }

    var connectButton: some View {
        Button(String(localized: "Connect")) {
            if isValidInput() {
                connectToSSH()
            } else {
                alertMessage = String(localized: "Hostname, Username and Password are required.")
                showAlert = true
            }
        }
        .font(.system(size: 24, weight: .bold, design: .default))
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(Color.blue)
        .cornerRadius(9)
        .foregroundColor(Color.white)
        .padding()
    }
    
    private func connectToSSH() {
        isConnecting = true
        let credentials = SSHSetupModel(hostname: hostname, port: Int(port) ?? 22, username: username, password: password)
        connection = SSHConnection(credentials: credentials)
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try self.connection?.connect()
                DispatchQueue.main.async {
                    self.isShowingTerminal = true
                    self.isConnecting = false
                }
            } catch SSHSessionError.connectFailed {
                DispatchQueue.main.async {
                    self.updateAlert(message: String(localized: "Could not connect to host."))
                    self.isConnecting = false
                }
            } catch SSHSessionError.authorizationFailed {
                DispatchQueue.main.async {
                    self.updateAlert(message: String(localized: "Authentication with host failed."))
                    self.isConnecting = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.updateAlert(message: error.localizedDescription)
                    self.isConnecting = false
                }
            }
        }
    }
    
    private func updateAlert(message: String) {
        DispatchQueue.main.async {
            self.alertMessage = message
            self.showAlert = true
        }
    }
    
    func isValidInput() -> Bool {
        !hostname.isEmpty && !username.isEmpty && !password.isEmpty
    }
}
     
#Preview {
    SSHSetupView()
}
