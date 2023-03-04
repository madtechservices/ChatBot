//
//  ChatBotApp.swift
//  ChatBot
//
//  Created by LiYanan2004 on 2023/3/2.
//

import SwiftUI

@main
struct ChatBotApp: App {
    @AppStorage("conversations") private var conversations = [Conversation]()
    @AppStorage("firstOpen") private var firstOpen = true
    @State private var showAPIKeyConfigurator = false
    @ObservedObject private var chatBot = ChatBot()
    @Environment(\.dismiss) private var dismiss
    
    var body: some Scene {
        WindowGroup {
            Group {
                if #available(macOS 13.0, *) {
                    NavigationSplitView {
                        SideBar()
                    } detail: {
                        ContentView()
                            .navigationTitle(chatBot.conversation?.title ?? "New Chat")
                    }
                } else {
                    NavigationView {
                        SideBar()
                        ContentView()
                            .navigationTitle(chatBot.conversation?.title ?? "New Chat")
                    }
                }
            }
            .background()
            .environmentObject(chatBot)
            .onChange(of: chatBot.conversation) { conv in
                guard let conv else { return }
                if let index = conversations.firstIndex(where: { $0.id == conv.id }) {
                    conversations[index] = conv
                } else if !conv.dialogs.isEmpty {
                    conversations.append(conv)
                }
            }
            .onAppear {
                if firstOpen {
                    showAPIKeyConfigurator = true
                    firstOpen = false
                }
            }
            .sheet(isPresented: $showAPIKeyConfigurator) {
                VStack(alignment: .trailing) {
                    APIKeyConfigurator()
                    Button("OK", action: { showAPIKeyConfigurator = false })
                }
                .frame(minWidth: 300)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            .frame(idealWidth: 1000, idealHeight: 800)
        }
    }
}
