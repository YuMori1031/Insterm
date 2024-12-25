//
//  AppInfoModel.swift
//  Insterm
//
//  Created by Yusuke Mori on 2024/03/04.
//

import SwiftUI

struct AppInfoModel: Identifiable {
    let id = UUID()
    let title: String
    let iconName: String
    let destinationView: AnyView?
    let url: URL?
}
