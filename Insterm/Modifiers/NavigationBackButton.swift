//
//  NavigationBackButton.swift
//  Insterm
//
//  Created by Yusuke Mori on 2024/02/11.
//

import SwiftUI

// NavigationBarの戻るボタンのテキストを消してModifier化
struct NavigationBackButton: ViewModifier {
    @Environment(\.presentationMode) var presentaion
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { presentaion.wrappedValue.dismiss() }) {
                        Image(systemName: "chevron.backward")
                    }
                }
            }
    }
}

extension View {
    func navigationBackButton() -> some View {
        self.modifier(NavigationBackButton())
    }
}
