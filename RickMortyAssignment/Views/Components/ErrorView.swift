//
//  ErrorView.swift
//  RickMortyAssignment
//
//  Created by Mohamed Jaber on 09/09/2026.
//

import SwiftUI

struct ErrorView: View {
    let error: NetworkError
    let retryAction: @Sendable () async -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "exclamationmark.circle")
                .font(.system(size: 40))
                .foregroundColor(.red)
            Text("Error")
                .font(.headline)
            Text(error.errorDescription ?? "Unknown error")
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            Button(action: {
                Task {
                    await retryAction()
                }
            }) {
                Text("Retry")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ErrorView(error: .noInternetConnection, retryAction: {})
}

