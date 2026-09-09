//
//  CharacterListEmptyState.swift
//  RickMortyAssignment
//
//  Created by Mohamed Jaber on 09/09/2026.
//

import SwiftUI

struct CharacterListEmptyState: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "person.slash")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            Text("No characters found")
                .font(.headline)
            Text("Try a different search or filter")
                .font(.caption)
                .foregroundColor(.gray)
            Spacer()
        }
    }
}

#Preview {
    CharacterListEmptyState()
}

