//
//  ContentView.swift
//  Insterm
//
//  Created by Yusuke Mori on 2023/11/01.
//

import SwiftUI
import Shake

struct ContentView: View {
    let items: [ContentModel] = [
        ContentModel(title: String(localized: "SSH Setup"), iconName: "apple.terminal.fill", section: String(localized: "Remote Access")),
        ContentModel(title: String(localized: "About App"), iconName: "info.square.fill", section: String(localized: "Information")),
        ContentModel(title: String(localized: "Feedback"), iconName: "questionmark.app.fill", section: String(localized: "Information"))
    ]
    
    private var sectionOrder: [String] {
        var sections = [String]()
        items.forEach { item in
            if !sections.contains(item.section) {
                sections.append(item.section)
            }
        }
        return sections
    }
    
    private var groupedItems: [String: [ContentModel]] {
        Dictionary(grouping: items, by: { $0.section })
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                AdmobBannerView()
                List {
                    ForEach(sectionOrder, id: \.self) { section in
                        Section(header: Text(section).textCase(nil)) {
                            ForEach(groupedItems[section] ?? [], id: \.title) { item in
                                if item.title == String(localized: "Feedback") {
                                    Button(action: {
                                        Shake.show(.new)
                                    }) {
                                        Label(item.title, systemImage: item.iconName)
                                    }
                                } else {
                                    NavigationLink(destination: destinationView(for: item.title)) {
                                        Label(item.title, systemImage: item.iconName)
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationBarTitle(Text(verbatim: "Insterm"), displayMode: .inline)
                .listStyle(GroupedListStyle())
            }
        }
    }
    
    @ViewBuilder
    private func destinationView(for title: String) -> some View {
        switch title {
        case String(localized: "SSH Setup"):
            SSHSetupView()
        case String(localized: "About App"):
            AppInfoView()
        default:
            Text(String(localized: "Page not found"))
        }
    }
}

#Preview {
    ContentView()
}
