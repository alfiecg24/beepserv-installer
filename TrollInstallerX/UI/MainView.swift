//
//  LaunchView.swift
//  TrollInstallerX
//
//  Created by Alfie on 22/03/2024.
//

import SwiftUI

struct MainView: View {
    
    @State private var isInstalling = false
    @State private var logs = [LogItem(message: "Starting installation", type: .info), LogItem(message: "Performing installation", type: .info)]
    
    @State private var device: Device?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(colors: [Color(hex: 0x00A8FF), Color(hex: 0x0C6BFF)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                VStack {
                    Image("Icon")
                        .resizable()
                        .cornerRadius(10)
                        .frame(maxWidth: 100, maxHeight: 100)
                        .shadow(radius: 10)
                    Text("TrollInstallerX")
                        .font(.system(size: 35, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                    Text("By Alfie CG")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.5))
                    
                    if !isInstalling {
                        MenuView()
                            .frame(maxWidth: geometry.size.width / 1.5, maxHeight: geometry.size.height / 4)
                            .transition(.scale)
                            .padding()
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.white.opacity(0.15))
                            .frame(maxWidth: isInstalling ? geometry.size.width / 1.2 : geometry.size.width / 2)
                            .frame(maxHeight: isInstalling ? geometry.size.height / 1.75 : 60)
                            .transition(.scale)
                        if isInstalling {
                            LogView()
                                .padding()
                                .frame(maxWidth: isInstalling ? geometry.size.width / 1.2 : geometry.size.width / 2)
                                .frame(maxHeight: isInstalling ? geometry.size.height / 1.75 : 60)
                                .contextMenu {
                                    Button {
                                        UIPasteboard.general.string = Logger.shared.logString
                                    } label: {
                                        Label("Copy to clipboard", systemImage: "doc.on.doc")
                                    }
                                }
                        }
                        else {
                            Button(action: {
                                UIImpactFeedbackGenerator().impactOccurred()
                                withAnimation {
                                    isInstalling.toggle()
                                }
                            }, label: {
                                    Text("Install")
                                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                                        .foregroundColor(.white)
                                        .padding()
                            })
                        }
                    }.padding()
                }
            }
            .onChange(of: isInstalling) { _ in
                Task {
                    await doInstall(device!)
                }
            }
            .onAppear {
                device = initDevice()
            }
        }
    }
}

#Preview {
    MainView()
}
