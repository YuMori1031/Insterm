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
    let adModel = AdmobBannerModel()  // Use the model to handle ad-related functionality
    
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
}
