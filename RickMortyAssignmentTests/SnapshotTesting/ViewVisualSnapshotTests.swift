//
//  ViewVisualSnapshotTests.swift
//  RickMortyAssignmentTests
//
//  Created by Mohamed Jaber on 09/09/2026.
//

import Testing
import SnapshotTesting
import SwiftUI
import Foundation
@testable import RickMortyAssignment

// MARK: - Helper for Main Thread Snapshot Testing
private func snapshotOnMainThread<Value, Format>(
    value: Value,
    as format: Snapshotting<Value, Format>,
    named name: String? = nil,
    file: StaticString = #file,
    line: UInt = #line
) {
    DispatchQueue.main.sync {
        assertSnapshot(
            of: value,
            as: format,
            named: name,
            file: file,
            testName: "",
            line: line,
            column: 0
        )
    }
}

// MARK: - Character Row View Snapshot Tests

struct CharacterRowViewVisualTests {
    
    @Test
    func testCharacterRowViewDefault() {
        let character = Character(
            id: 1,
            name: "Rick Sanchez",
            status: "Alive",
            species: "Human",
            type: "",
            gender: "Male",
            origin: Character.Location(name: "Earth (C-137)", url: ""),
            location: Character.Location(name: "Earth (Replacement Dimension)", url: ""),
            image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            episode: [],
            url: "",
            created: ""
        )
        
        let view = CharacterRowView(character: character)
        let hosting = UIHostingController(rootView: view)
        
        snapshotOnMainThread(
            value: hosting,
            as: .image(on: .iPhone13)
        )
    }
    
    @Test
    func testCharacterRowViewDeadStatus() {
        let character = Character(
            id: 2,
            name: "Morty Smith",
            status: "Dead",
            species: "Human",
            type: "",
            gender: "Male",
            origin: Character.Location(name: "Earth (C-137)", url: ""),
            location: Character.Location(name: "Earth (Replacement Dimension)", url: ""),
            image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg",
            episode: [],
            url: "",
            created: ""
        )
        
        let view = CharacterRowView(character: character)
        let hosting = UIHostingController(rootView: view)
        
        snapshotOnMainThread(
            value: hosting,
            as: .image(on: .iPhone13),
            named: "dead-status"
        )
    }
    
    @Test
    func testCharacterRowViewAlienSpecies() {
        let character = Character(
            id: 4,
            name: "Mr. Poopybutthole",
            status: "Alive",
            species: "Alien",
            type: "Poopybutthole",
            gender: "Male",
            origin: Character.Location(name: "Alien Planet", url: ""),
            location: Character.Location(name: "Smith Residence", url: ""),
            image: "https://rickandmortyapi.com/api/character/avatar/4.jpeg",
            episode: [],
            url: "",
            created: ""
        )
        
        let view = CharacterRowView(character: character)
        let hosting = UIHostingController(rootView: view)
        
        snapshotOnMainThread(
            value: hosting,
            as: .image(on: .iPhone13),
            named: "alien-species"
        )
    }
}

// MARK: - Character List Empty State Snapshot Tests

struct CharacterListEmptyStateVisualTests {
    
    @Test
    func testEmptyStateDefault() {
        let view = CharacterListEmptyState()
        let hosting = UIHostingController(rootView: view)
        
        snapshotOnMainThread(
            value: hosting,
            as: .image(on: .iPhone13)
        )
    }
    
    @Test
    func testEmptyStateCompact() {
        let view = CharacterListEmptyState()
        let hosting = UIHostingController(rootView: view)
        
        snapshotOnMainThread(
            value: hosting,
            as: .image(on: .iPhone12Pro),
            named: "compact"
        )
    }
}

// MARK: - Loading View Snapshot Tests

struct LoadingViewVisualTests {
    
    @Test
    func testLoadingViewDefault() {
        let view = LoadingView()
        let hosting = UIHostingController(rootView: view)
        
        snapshotOnMainThread(
            value: hosting,
            as: .image(on: .iPhone13)
        )
    }
    
    @Test
    func testLoadingViewLarge() {
        let view = LoadingView()
        let hosting = UIHostingController(rootView: view)
        
        snapshotOnMainThread(
            value: hosting,
            as: .image(on: .iPhoneXsMax),
            named: "large"
        )
    }
}

// MARK: - Error View Snapshot Tests

struct ErrorViewVisualTests {
    
    @Test
    func testErrorViewNetworkError() {
        let view = ErrorView(
            error: .noInternetConnection,
            retryAction: {}
        )
        let hosting = UIHostingController(rootView: view)
        
        snapshotOnMainThread(
            value: hosting,
            as: .image(on: .iPhone13)
        )
    }
    
    @Test
    func testErrorViewDecodingError() {
        let view = ErrorView(
            error: .decodingError,
            retryAction: {}
        )
        let hosting = UIHostingController(rootView: view)
        
        snapshotOnMainThread(
            value: hosting,
            as: .image(on: .iPhone13),
            named: "decoding-error"
        )
    }
    
    @Test
    func testErrorViewServerError() {
        let view = ErrorView(
            error: .serverError(500),
            retryAction: {}
        )
        let hosting = UIHostingController(rootView: view)
        
        snapshotOnMainThread(
            value: hosting,
            as: .image(on: .iPhone13),
            named: "server-error"
        )
    }
    
    @Test
    func testErrorViewUnknownError() {
        let view = ErrorView(
            error: .unknown,
            retryAction: {}
        )
        let hosting = UIHostingController(rootView: view)
        
        snapshotOnMainThread(
            value: hosting,
            as: .image(on: .iPhone13),
            named: "unknown-error"
        )
    }
}

// MARK: - Async Image View Snapshot Tests

struct AsyncImageViewVisualTests {
    
    @Test
    func testAsyncImageViewWithURL() {
        let view = AsyncImageView(
            url: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"
        )
        let hosting = UIHostingController(rootView: view)
        
        snapshotOnMainThread(
            value: hosting,
            as: .image(on: .iPhone13)
        )
    }
    
    @Test
    func testAsyncImageViewEmpty() {
        let view = AsyncImageView(url: nil)
        let hosting = UIHostingController(rootView: view)
        
        snapshotOnMainThread(
            value: hosting,
            as: .image(on: .iPhone13),
            named: "empty"
        )
    }
}

// MARK: - Search and Filter View Snapshot Tests

struct SearchAndFilterViewVisualTests {
    
    @Test
    func testSearchAndFilterViewDefault() {
        @State var searchText = ""
        @State var selectedStatus: String? = nil
        @State var selectedSort = SortOption.nameAsc
        
        let view = SearchAndFilterView(
            searchText: $searchText,
            selectedStatus: $selectedStatus,
            selectedSort: $selectedSort,
            onSearchChange: { _ in }
        )
        let hosting = UIHostingController(rootView: view)
        
        snapshotOnMainThread(
            value: hosting,
            as: .image(on: .iPhone13)
        )
    }
}

// MARK: - Character Row View Dark Mode Tests

struct CharacterRowViewDarkModeTests {
    
    @Test
    func testCharacterRowViewDarkMode() {
        let character = Character(
            id: 1,
            name: "Rick Sanchez",
            status: "Alive",
            species: "Human",
            type: "",
            gender: "Male",
            origin: Character.Location(name: "Earth (C-137)", url: ""),
            location: Character.Location(name: "Earth (Replacement Dimension)", url: ""),
            image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            episode: [],
            url: "",
            created: ""
        )
        
        let view = CharacterRowView(character: character)
            .preferredColorScheme(.dark)
        
        let hosting = UIHostingController(rootView: view)
        
        snapshotOnMainThread(
            value: hosting,
            as: .image(on: .iPhone13),
            named: "dark-mode"
        )
    }
    
    @Test
    func testCharacterRowViewLightMode() {
        let character = Character(
            id: 1,
            name: "Rick Sanchez",
            status: "Alive",
            species: "Human",
            type: "",
            gender: "Male",
            origin: Character.Location(name: "Earth (C-137)", url: ""),
            location: Character.Location(name: "Earth (Replacement Dimension)", url: ""),
            image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            episode: [],
            url: "",
            created: ""
        )
        
        let view = CharacterRowView(character: character)
            .preferredColorScheme(.light)
        
        let hosting = UIHostingController(rootView: view)
        
        snapshotOnMainThread(
            value: hosting,
            as: .image(on: .iPhone13),
            named: "light-mode"
        )
    }
}

// MARK: - Multiple Device Sizes

struct MultiDeviceSnapshotTests {
    
    @Test
    func testCharacterRowViewMultipleDevices() {
        let character = Character(
            id: 1,
            name: "Rick Sanchez",
            status: "Alive",
            species: "Human",
            type: "",
            gender: "Male",
            origin: Character.Location(name: "Earth (C-137)", url: ""),
            location: Character.Location(name: "Earth (Replacement Dimension)", url: ""),
            image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            episode: [],
            url: "",
            created: ""
        )
        
        let view = CharacterRowView(character: character)
        let hosting = UIHostingController(rootView: view)
        
        // Test across standard device sizes
        snapshotOnMainThread(value: hosting, as: .image(on: .iPhone8), named: "compact")
        snapshotOnMainThread(value: hosting, as: .image(on: .iPhone13), named: "standard")
        snapshotOnMainThread(value: hosting, as: .image(on: .iPhoneXsMax), named: "large")
    }
}

// MARK: - Error View All States

struct ErrorViewAllStatesTests {
    
    let errors: [(String, NetworkError)] = [
        ("invalidURL", .invalidURL),
        ("noInternetConnection", .noInternetConnection),
        ("requestTimeout", .requestTimeout),
        ("invalidResponse", .invalidResponse),
        ("decodingError", .decodingError),
        ("serverError500", .serverError(500)),
        ("notFound", .notFound),
        ("unauthorized", .unauthorized),
        ("forbidden", .forbidden),
        ("badRequest", .badRequest),
        ("unknown", .unknown),
    ]
    
    @Test
    func testErrorViewAllStates() {
        for (name, error) in errors {
            let view = ErrorView(
                error: error,
                retryAction: {}
            )
            let hosting = UIHostingController(rootView: view)
            
            snapshotOnMainThread(
                value: hosting,
                as: .image(on: .iPhone13),
                named: "error-\(name)"
            )
        }
    }
}

