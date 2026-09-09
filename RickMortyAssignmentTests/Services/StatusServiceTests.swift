//
//  StatusServiceTests.swift
//  RickMortyAssignmentTests
//
//  Created by Mohamed Jaber on 09/09/2026.
//

import Testing
import SwiftUI
@testable import RickMortyAssignment

// MARK: - StatusService Tests
struct StatusServiceTests {
    @Test
    func testColorMappingForAliveStatus() {
        let color = StatusService.color(for: "Alive")
        #expect(color == Color.green)
    }
    
    @Test
    func testColorMappingForDeadStatus() {
        let color = StatusService.color(for: "Dead")
        #expect(color == Color.red)
    }
    
    @Test
    func testColorMappingForUnknownStatus() {
        let color = StatusService.color(for: "unknown")
        #expect(color == Color.gray)
    }
    
    @Test
    func testColorMappingCaseInsensitive() {
        #expect(StatusService.color(for: "ALIVE") == Color.green)
        #expect(StatusService.color(for: "dead") == Color.red)
        #expect(StatusService.color(for: "UnKnOwN") == Color.gray)
    }
    
    @Test
    func testIconMappingForAliveStatus() {
        let icon = StatusService.icon(for: "Alive")
        #expect(icon == "✓")
    }
    
    @Test
    func testIconMappingForDeadStatus() {
        let icon = StatusService.icon(for: "Dead")
        #expect(icon == "✕")
    }
    
    @Test
    func testIconMappingForUnknownStatus() {
        let icon = StatusService.icon(for: "unknown")
        #expect(icon == "?")
    }
    
    @Test
    func testIconMappingCaseInsensitive() {
        #expect(StatusService.icon(for: "ALIVE") == "✓")
        #expect(StatusService.icon(for: "dead") == "✕")
        #expect(StatusService.icon(for: "UnKnOwN") == "?")
    }
}
