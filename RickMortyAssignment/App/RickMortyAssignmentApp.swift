//
//  RickMortyAssignmentApp.swift
//  RickMortyAssignment
//
//  Created by Mohamed Jaber on 09/09/2026.
//

import SwiftUI

@main
struct RickMortyAssignmentApp: App {
    let appFactory = AppFactory()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                CharactersListView(viewModel: appFactory.characterListViewModel)
                    .preferredColorScheme(nil)
            }
        }
    }
}
