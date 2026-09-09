//
//  SearchAndFilterView.swift
//  RickMortyAssignment
//
//  Created by Mohamed Jaber on 09/09/2026.
//

import SwiftUI

struct SearchAndFilterView: View {
    @Binding var searchText: String
    @Binding var selectedStatus: String?
    @Binding var selectedSort: SortOption
    var onSearchChange: (String) -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            SearchFieldView(searchText: $searchText, onSearchChange: onSearchChange)
            FilterControlsView(selectedStatus: $selectedStatus, selectedSort: $selectedSort)
        }
        .padding(.vertical, 8)
    }
}

struct SearchFieldView: View {
    @Binding var searchText: String
    var onSearchChange: (String) -> Void
    
    var body: some View {
        HStack {
            searchIcon
            searchField
            clearButton
        }
        .padding(.horizontal)
    }
    
    // MARK: - View Sections
    
    private var searchIcon: some View {
        Image(systemName: "magnifyingglass")
            .foregroundColor(.gray)
    }
    
    private var searchField: some View {
        TextField("Search characters", text: $searchText)
            .textFieldStyle(.roundedBorder)
            .accessibilityIdentifier("searchTextField")
            .onChange(of: searchText) { _, newValue in
                onSearchChange(newValue)
            }
    }
    
    @ViewBuilder
    private var clearButton: some View {
        if !searchText.isEmpty {
            Button(action: {
                searchText = ""
                onSearchChange("")
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
            }
            .accessibilityIdentifier("clearSearchButton")
        }
    }
}

struct FilterControlsView: View {
    @Binding var selectedStatus: String?
    @Binding var selectedSort: SortOption
    
    var body: some View {
        VStack(spacing: 12) {
            statusFilterSection
            sortSection
        }
        .padding(.horizontal)
    }
    
    // MARK: - View Sections
    
    private var statusFilterSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            statusLabel
            statusPicker
        }
    }
    
    private var statusLabel: some View {
        Text("Status")
            .font(.caption)
            .foregroundColor(.gray)
    }
    
    private var statusPicker: some View {
        Picker("Filter by status", selection: $selectedStatus) {
            Text("All").tag(Optional<String>.none)
            ForEach(StatusService.allStatusOptions, id: \.self) { status in
                Text(status).tag(Optional(status))
            }
        }
        .pickerStyle(.segmented)
        .accessibilityIdentifier("statusFilter")
    }
    
    private var sortSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sortLabel
            sortPicker
        }
    }
    
    private var sortLabel: some View {
        Text("Sort")
            .font(.caption)
            .foregroundColor(.gray)
    }

    private var sortPicker: some View {
        Picker("Sort", selection: $selectedSort) {
            ForEach(SortOption.allCases, id: \.self) { sort in
                Text(sort.rawValue).tag(sort)
            }
        }
        .pickerStyle(.segmented)
        .accessibilityIdentifier("sortPicker")
    }
}

#Preview {
    @Previewable @State var searchText = ""
    @Previewable @State var selectedStatus: String? = nil
    @Previewable @State var selectedSort = SortOption.nameAsc
    
    SearchAndFilterView(
        searchText: $searchText,
        selectedStatus: $selectedStatus,
        selectedSort: $selectedSort,
        onSearchChange: { _ in }
    )
}

