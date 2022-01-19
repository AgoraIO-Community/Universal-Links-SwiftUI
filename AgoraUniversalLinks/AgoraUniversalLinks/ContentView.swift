//
//  ContentView.swift
//  AgoraUniversalLinks
//
//  Created by Max Cobb on 05/01/2022.
//

import SwiftUI
import AgoraRtcKit
import AgoraUIKit_iOS

struct ContentView: View {
    @State var channelName: String?
    static var baseDomain: String = <#Base Domain#> // ie: https://example.com
    var videoCallView: some View {
        VStack {
            HStack {
                Button {
                    self.isShowingVideo = false
                } label: {
                    Text("Exit")
                        .padding().background(.gray).cornerRadius(3)
                }
                Spacer()
                Button {
                    guard let channelName = channelName,
                          let urlShare = URL(
                            string: "\(ContentView.baseDomain)/join?channel=\(channelName)"
                    ) else { return }
                    let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
                    let scenes = UIApplication.shared.connectedScenes
                    guard let windowScene = scenes.first as? UIWindowScene,
                          let window = windowScene.windows.first else { return }
                    window.rootViewController?.present(activityVC, animated: true, completion: nil)

                } label: {
                    Text("Share")
                        .padding().background(.gray).cornerRadius(3)
                }
            }

            ContentView.agview
        }
    }
    static var agview: AgoraViewer = {
        AgoraViewer(
            connectionData: AgoraConnectionData(
                appId: <#Agora App ID#>,
                rtcToken: <#Agora Token or nil#>
            ),
            style: .floating
        )
    }()

    @State var openedUrl: URL?

    @State var isShowingVideo: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(
                    destination: self.videoCallView
                        .navigationBarHidden(true)
                        .onDisappear(perform: { ContentView.agview.viewer.leaveChannel() })
                        .onAppear(perform: {
                            guard let channelName = self.channelName else {
                                self.isShowingVideo = false
                                return
                            }
                            ContentView.agview.join(
                                channel: channelName, with: nil, as: .broadcaster
                            )
                        }),
                    isActive: $isShowingVideo
                ) { EmptyView() }
                HStack {
                    Button {
                        self.channelName = self.randomString(length: 8)
                        self.isShowingVideo = true
                    } label: {
                        Text("Create Channel")
                            .padding().background(.green).cornerRadius(30)
                    }
                }
            }
        }
        .onOpenURL { url in
            openedUrl = url
            if let channel = url.queryDictionary?["channel"] {
                self.channelName = channel
                self.isShowingVideo = true
            }
        }
    }
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension URL {
    var queryDictionary: [String: String]? {
        guard let query = self.query else { return nil}

        var queryStrings = [String: String]()
        for pair in query.components(separatedBy: "&") {

            let key = pair.components(separatedBy: "=")[0]

            let value = pair
                .components(separatedBy:"=")[1]
                .replacingOccurrences(of: "+", with: " ")
                .removingPercentEncoding ?? ""

            queryStrings[key] = value
        }
        return queryStrings
    }
}
