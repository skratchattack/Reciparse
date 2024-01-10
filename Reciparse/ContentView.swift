//
//  ContentView.swift
//  Reciparse
//
//  Created by Orri Arnórsson on 2.1.2024.
//

import SwiftUI
import VisionKit

struct ContentView: View {
    
    @EnvironmentObject var vm: AppViewModel
    
    private let textContentTypes: [(title: String, textContentType: DataScannerViewController.TextContentType?)] = [
        ("All", .none),
        ("URL", .URL),
        ("Phone", .telephoneNumber),
        ("Email", .emailAddress),
        ("Address", .fullStreetAddress)
    ]

    var body: some View {
        switch vm.dataScannerAccessStatus {
        case .notDetermined:
            Text("Requesting camera access")
        case .cameraAccessNotGranted:
            Text("Please provide access to the camera in settings")
        case .cameraNotAvailable:
            Text("Your device doesn't have a camera")
        case .scannerAvailable:
            mainView
        case .scannerNotAvailable:
            Text("Your device doesn't have support for scanning")
        }
    }
    
    private var mainView: some View {
        DataScannerView(
            shouldCapturePhoto: $vm.shouldCapturePhoto,
            capturedPhoto: $vm.capturedPhoto,
            recognizedItems: $vm.recognizedItems,
            recognizedDataType: vm.recognizedDataType,
            recognizesMultipleItems: vm.recognizesMultipleItems)
        .background { Color.gray.opacity(0.3) }
        .ignoresSafeArea()
        .id(vm.dataScannerViewId)
        .sheet(isPresented: .constant(true)) {
            bottomContainerView
                .background(.ultraThinMaterial)
                .presentationDetents([.medium, .fraction(0.25)])
                .presentationDragIndicator(.visible)
                .interactiveDismissDisabled()
                .onAppear {
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                          let controller = windowScene.windows.first?.rootViewController?.presentedViewController else {
                        return
                    }
                    controller.view.backgroundColor = .clear
                }
                .sheet(item: $vm.capturedPhoto) { photo in
                    ZStack(alignment: .topTrailing) {
                        
                    }
                }
        }
        
//        .onChange(of: vm.recognizesMultipleItems) { _ in vm.recognizedItems = [] }
//        .onChange(of: vm.textContentType) { _ in vm.recognizedItems = [] }
//        .onChange(of: vm.recognizesMultipleItems) { _ in vm.recognizedItems = [] }

        
        }
    
    private var headerView: some View {
        VStack {
            HStack {
                Picker("Scan Type", selection: $vm.scanType) {
                    Text("Barcode").tag(ScanType.barcode)
                    Text("Text").tag(ScanType.text)
                }.pickerStyle(.segmented)
                
                Toggle("Scan Multiple", isOn: $vm.recognizesMultipleItems)
            }.padding(.top)
            
            if vm.scanType == .text {
                Picker("Text content type", selection: $vm.textContentType) { 
                    ForEach(textContentTypes, id: \.self.textContentType) { option in
                        Text(option.title).tag(option.textContentType)
                    }
                }.pickerStyle(.segmented)
            }
            HStack {
                Text(vm.headerText)
                Spacer()
                Button {
                    vm.shouldCapturePhoto = true
                } label: {
                    Image(systemName: "camera.circle")
                        .imageScale(.large)
                        .font(.system(size: 32))
                }

            }
            
        }.padding(.horizontal)
    }
    
    private var bottomContainerView: some View {
        VStack {
            headerView
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(vm.recognizedItems) { item in
                        switch item {
                        case .barcode(let barcode):
                            Text(barcode.payloadStringValue ?? "Unknown Barcode")
                            
                        case .text(let text):
                            Text(text.transcript)
                            
                        @unknown default:
                            Text("Unknown")
                        }
                    }
                }
                .padding()
            }
        }
    }
}
