//
//  ReciparseApp.swift
//  Reciparse
//
//  Created by Orri Arnórsson on 2.1.2024.
//

import SwiftUI

@main
struct ReciparseApp: App {
    
    @StateObject private var vm = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
                .task {
                    await vm.requestDataScannerAccessStatus()
                }
        }
    }
}
