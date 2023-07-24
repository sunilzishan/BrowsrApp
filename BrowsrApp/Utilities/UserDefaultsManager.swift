//
//  UserDefaultsManager.swift
//  BrowsrApp
//
//  Created by Sunil Zishan on 24.07.23.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager() // Singleton instance
    
    private let favoritesKey = "Favorites"
    
    // MARK: - Favorite Organizations
    
    func saveFavoriteOrganizations(_ organizations: [FavoriteOrganization]) {
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(organizations)
            UserDefaults.standard.set(encodedData, forKey: favoritesKey)
        } catch {
            print("Failed to encode favorite organizations: \(error)")
        }
    }
    
    func loadFavoriteOrganizations() -> [FavoriteOrganization] {
        guard let encodedData = UserDefaults.standard.data(forKey: favoritesKey) else {
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            let organizations = try decoder.decode([FavoriteOrganization].self, from: encodedData)
            return organizations
        } catch {
            print("Failed to decode favorite organizations: \(error)")
            return []
        }
    }
    
    func clearFavoriteOrganizations() {
        UserDefaults.standard.removeObject(forKey: favoritesKey)
    }
    
    // Add a new favorite organization to UserDefaults
    func addFavoriteOrganization(_ organization: FavoriteOrganization) {
        var favorites = loadFavoriteOrganizations()
        favorites.append(organization)
        saveFavoriteOrganizations(favorites)
    }
    
    // Remove a favorite organization from UserDefaults
    func removeFavoriteOrganization(_ organization: FavoriteOrganization) {
        var favorites = loadFavoriteOrganizations()
        favorites.removeAll { $0.organizationId == organization.organizationId }
        saveFavoriteOrganizations(favorites)
    }
}
