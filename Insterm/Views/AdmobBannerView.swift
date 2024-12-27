//
//  AdmobBannerView.swift
//  Insterm
//
//  Created by Yusuke Mori on 2024/04/16.
//

import SwiftUI
import UIKit
import GoogleMobileAds

struct AdmobBannerView: View {
    var body: some View {
        VStack {
            BannerView()
                .frame(height: 50)
                .padding(.horizontal)
        }
    }
}

struct BannerView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return GADBannerViewController()
    }

    func updateUIViewController(_: UIViewController, context _: Context) {}
}

class GADBannerViewController: UIViewController, GADBannerViewDelegate {
    var bannerView: GADBannerView!
    let adModel = AdmobBannerModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBannerView()
    }

    private func setupBannerView() {
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = adModel.adUnitID
        bannerView.delegate = self
        bannerView.rootViewController = self
        bannerView.load(adModel.createAdRequest())
        setAdView(bannerView)
    }

    private func setAdView(_ view: GADBannerView) {
        self.view.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            view.topAnchor.constraint(equalTo: self.view.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    // MARK: - GADBannerViewDelegate Methods
    
    /// 広告が正常にロードされたとき
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("AdMob: Ad successfully received.")
    }
    
    /// 広告のロードが失敗したとき
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("AdMob Error: \(error.localizedDescription)")
    }
    
    /// 広告がクリックされたとき
    func bannerViewDidRecordClick(_ bannerView: GADBannerView) {
        print("AdMob: Ad clicked.")
    }
    
    /// ユーザーが広告を閉じたとき
    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("AdMob: Ad dismissed.")
    }
}

#Preview {
    AdmobBannerView()
        .frame(height: 50)
        .background(Color.gray.opacity(0.1))
}
