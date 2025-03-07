//
//  AppInfoView.swift
//  Insterm
//
//  Created by Yusuke Mori on 2024/03/04.
//

import SwiftUI
import WebKit
import LicenseList

struct AppInfoView: View {
    let items: [AppInfoModel] = [
        AppInfoModel(title: String(localized: "Write a Review"), iconName: "pencil.circle.fill", destinationView: nil, url: URL(string: "https://apps.apple.com/app/id6742595334?action=write-review")),
        AppInfoModel(title: String(localized: "Developer"), iconName: "person.fill", destinationView: AnyView(WebViewContainer(url: URL(string:"https://www.yumori.dev")!, title: String(localized: "Developer"))), url: nil),
        AppInfoModel(title: String(localized: "Privacy Policy"), iconName: "lock.shield.fill", destinationView: AnyView(WebViewContainer(url: URL(string: "https://www.yumori.dev/privacy/insterm/")!, title: String(localized: "Privacy Policy"))), url: nil),
        AppInfoModel(title: String(localized: "Library"), iconName: "books.vertical.fill", destinationView: AnyView(LibraryView()), url: nil)
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                AdmobBannerView()
                HStack {
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 80)
                    VStack(alignment: .leading, spacing: 10) {
                        Text(verbatim: "Insterm")
                            .font(.headline)
                        Text(verbatim: "\(getAppVersion())")
                            .font(.caption)
                        Text(verbatim: "© 2023 Yusuke Mori")
                            .font(.caption)
                    }
                }
                .padding()
                List(items) { item in
                    if let url = item.url {
                        Button(action: {
                            UIApplication.shared.open(url)
                        }) {
                            Label(item.title, systemImage: item.iconName)
                        }
                    } else if let destinationView = item.destinationView {
                        NavigationLink(destination: destinationView) {
                            Label(item.title, systemImage: item.iconName)
                        }
                    }
                }
                .navigationBackButton()
                .navigationBarTitle(String(localized: "About App"), displayMode: .inline)
                .listStyle(GroupedListStyle())
            }
        }
    }
}

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

struct WebViewContainer: View {
    var url: URL
    var title: String

    var body: some View {
        AdmobBannerView()
        WebView(url: url)
            .navigationBackButton()
            .navigationBarTitle(Text(title), displayMode: .inline)
    }
}

struct LibraryView: View {
    var body: some View {
        VStack {
            AdmobBannerView()
            List(Library.libraries, id: \.name) { library in
                NavigationLink(destination: VStack {
                    AdmobBannerView()
                    LicenseView(library: library)
                        .navigationBackButton()
                }) {
                    Text(library.name)
                }
            }
            .navigationBackButton()
            .navigationBarTitle(String(localized: "Library"), displayMode: .inline)
            .listStyle(GroupedListStyle())
        }
    }
}

private func getAppVersion() -> String {
    let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Unknown"
    return "Version \(versionNumber)"
}

#Preview {
    AppInfoView()
}
