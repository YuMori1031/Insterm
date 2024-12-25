//
//  AdmobBannerModel.swift
//  Insterm
//
//  Created by Yusuke Mori on 2024/04/16.
//

import GoogleMobileAds
import AppTrackingTransparency

class AdmobBannerModel {
    var adUnitID: String? = Bundle.main.object(forInfoDictionaryKey: "GADBannerIdentifier") as? String

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
