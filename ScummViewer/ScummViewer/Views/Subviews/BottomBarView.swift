//
//  BottomBarView.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 21.10.21.
//

import SwiftUI

struct BottomBarView: View {
    
    @EnvironmentObject var scummStore: ScummStore
    
    @State private var showAlert = false
    @State private var result: Result<ScummVersion, Error>? = nil
    
    var body: some View {
        
        HStack {
            
            if let result = result {
                handleResult(result)
            }
            
        }.onChange(of: try? scummStore.filesInDirectory) { _ in
            result = Result { try scummStore.scummVersion }
        }
    }

    private func handleResult(_ result: Result<ScummVersion, Error>) -> some View {
        
        switch result {
            
        case .success(let version):
            return AnyView(VersionInfoView(version: .constant(version)))
            
        case .failure(let error):
            scummStore.error = error as? RuntimeError
            return AnyView(Text("")
                .padding(.horizontal))
        }
    }
}

struct BottomBarView_Previews: PreviewProvider {
    static var previews: some View {
        BottomBarView()
            .environmentObject(ScummStore.create)
            .previewLayout(.sizeThatFits)
    }
}

