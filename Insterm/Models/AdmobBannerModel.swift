//
//  AdmobBannerModel.swift
//  Insterm
//
//  Created by Yusuke Mori on 2024/04/16.
//

import GoogleMobileAds
import AppTrackingTransparency

class AdmobBannerModel {
    // Info.plist の GADBannerIdentifier を直接取得し、存在しない場合はデフォルト値を使用
    let adUnitID: String = Bundle.main.object(forInfoDictionaryKey: "GADBannerIdentifier") as? String ?? "ca-app-pub-3940256099942544/2934735716" // テスト用バナーID
    
    func createAdRequest() -> GADRequest {
        let request = GADRequest()
        // ユーザーがトラッキングを拒否した場合のみノンパーソナライズ広告をリクエスト
        if ATTrackingManager.trackingAuthorizationStatus != .authorized {
            let extras = GADExtras()
            extras.additionalParameters = ["npa": "1"]
            request.register(extras)
        }
        return request
    }
}
