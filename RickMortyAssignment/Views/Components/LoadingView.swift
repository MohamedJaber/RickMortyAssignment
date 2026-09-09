//
//  LoadingView.swift
//  RickMortyAssignment
//
//  Created by Mohamed Jaber on 09/09/2026.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading characters...")
                .font(.headline)
            Spacer()
        }
    }
}

#Preview {
    LoadingView()
}

