//
//  LaunchView.swift
//  beepserv-installer
//
//  Created by Alfie on 22/03/2024.
//

import SwiftUI

struct MainView: View {
    
    @State private var isInstalling = false
    
    @State private var device: Device = Device()
    
    @State private var isShowingMDCAlert = false
    @State private var isShowingHelperAlert = false
    
    @State private var isShowingSettings = false
    @State private var isShowingCredits = false
    
    @State private var installedSuccessfully = false
    @State private var installationFinished = false
    
    // Best way to show the alert midway through doInstall()
    @ObservedObject var helperView = HelperAlert.shared
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ZStack {
                    LinearGradient(colors: [Color(hex: 0x1452f8), Color(hex: 0x6353f3)], startPoint: .bottomLeading, endPoint: .topTrailing)
                        .ignoresSafeArea()
                    VStack {
                        VStack {
                            Image("BeeperLogo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 250, maxHeight: 100)
                                .shadow(radius: 10)
                            Text("BeepServ installer")
                                .font(.system(size: 30, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        .padding(.vertical)
                        
                        if !isInstalling {
                            MenuView(isShowingSettings: $isShowingSettings, isShowingCredits: $isShowingCredits, isShowingMDCAlert: $isShowingMDCAlert, device: device)
                                .frame(maxWidth: geometry.size.width / 1.2, maxHeight: geometry.size.height / 7)
                                .transition(.scale)
                                .padding()
                                .shadow(radius: 10)
                                .disabled(!device.isSupported)
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.white.opacity(0.15))
                                .frame(maxWidth: geometry.size.width / 1.2)
                                .frame(maxHeight: isInstalling ? geometry.size.height / 1.75 : 60)
                                .transition(.scale)
                                .shadow(radius: 10)
                            if isInstalling {
                                LogView(installationFinished: $installationFinished)
                                    .padding()
                                    .frame(maxWidth: geometry.size.width / 1.2)
                                    .frame(maxHeight: geometry.size.height / 1.75)
                            }
                            else {
                                Button(action: {
                                    if !isShowingCredits && !isShowingSettings && !isShowingMDCAlert {
                                        UIImpactFeedbackGenerator().impactOccurred()
                                        withAnimation {
                                            isInstalling.toggle()
                                        }
                                    }
                                }, label: {
                                    Text(device.isSupported ? "Install" : "Unsupported")
                                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                                            .foregroundColor(device.isSupported ? .white : .secondary)
                                            .padding()
                                            .frame(maxWidth: geometry.size.width / 1.2)
                                            .frame(maxHeight: 60)
                                })
                                .frame(maxWidth: geometry.size.width / 1.2)
                                .frame(maxHeight: 60)
                            }
                        }
                        .padding()
                        .disabled(!device.isSupported)
                        
                        
                        }
                        .blur(radius: (isShowingMDCAlert || isShowingSettings || isShowingCredits || helperView.showAlert) ? 10 : 0)
                    }
                }
                if isShowingMDCAlert {
                    PopupView(isShowingAlert: $isShowingMDCAlert, shouldAllowDismiss: false, content: {
                        UnsandboxView(isShowingMDCAlert: $isShowingMDCAlert)
                    })
                }
                if isShowingSettings {
                    PopupView(isShowingAlert: $isShowingSettings, content: {
                        SettingsView(device: device)
                    })
                }
                
                if isShowingCredits {
                    PopupView(isShowingAlert: $isShowingCredits, content: {
                        CreditsView()
                    })
                }
            
            if helperView.showAlert {
                PopupView(isShowingAlert: $isShowingHelperAlert, shouldAllowDismiss: false, content: {
                    PersistenceHelperView(isShowingHelperAlert: $isShowingHelperAlert, allowNoPersistenceHelper: device.supportsDirectInstall)
                    })
                }
            }
            // Hacky, but it works (can't pass helperView.showAlert as a binding variable)
            .onChange(of: helperView.showAlert) { new in
                if new {
                    withAnimation {
                        isShowingHelperAlert = true
                    }
                }
            }
            .onChange(of: isShowingHelperAlert) { new in
                if !new {
                    helperView.showAlert = false
                }
            }
            .onChange(of: isInstalling) { _ in
                Task {
                    if device.supportsDirectInstall {
                        installedSuccessfully = await doDirectInstall(device)
                    } else {
                        installedSuccessfully = await doIndirectInstall(device)
                    }
                    installationFinished = true
                    UINotificationFeedbackGenerator().notificationOccurred(installedSuccessfully ? .success : .error)
                }
            }
            .onAppear {
                if device.isSupported {
                    withAnimation {
                        isShowingMDCAlert = !checkForMDCUnsandbox() && MacDirtyCow.supports(device)
                    }
                }
                Task {
                    await getUpdatedTrollStore()
                }
            }
        }
    }


#Preview {
    MainView()
}
