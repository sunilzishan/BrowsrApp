//
//  OrganizationsViewModel.swift
//  BrowsrApp
//
//  Created by Sunil Zishan on 24.07.23.
//

import BrowsrLib
import Foundation

// Protocol for the OrganizationsViewModelDelegate
protocol OrganizationsViewModelDelegate: AnyObject {
    func organizationsFetched()
    func organizationsFetchFailed(with error: Error)
    init(client: BrowsrClient)
}

// Protocol for the OrganizationsViewModel
protocol OrganizationsViewModelProtocol: AnyObject {
    var delegate: OrganizationsViewModelDelegate? { get set }
    func fetchOrganizations()
    func getOrganizations() -> [Organization]
    func numberOfOrganizations() -> Int
    func organization(at index: Int) -> Organization?
    func isFavorite(_ organizationId:  Int) -> Bool
    func addOrganizationToFavorites(_ organization: Organization)
    func removeOrganizationFromFavorites(_ organization: Organization)
}


class OrganizationsViewModel: OrganizationsViewModelProtocol {
    weak var delegate: OrganizationsViewModelDelegate?
    private let client: BrowsrClient
    private var organizations: [Organization] = []
    private var favoriteOrganizations: [FavoriteOrganization] = []
    
    init(client: BrowsrClient = BrowsrClient()) {
        self.client = client
    }
    
    func getOrganizations() -> [Organization] {
        return organizations
    }
    
    func fetchOrganizations() {
        client.fetchOrganizations { [weak self] (organizations: [Organization]?, error: BrowsrError?) in
            guard let self = self else { return }
            
            if let organizations = organizations {
                self.organizations = organizations
                self.delegate?.organizationsFetched()
            } else if let error = error {
                self.delegate?.organizationsFetchFailed(with: error)
            }
        }
    }
    
    func numberOfOrganizations() -> Int {
        return organizations.count
    }
    
    func organization(at index: Int) -> Organization? {
        guard index >= 0 && index < organizations.count else {
            return nil
        }
        
        return organizations[index]
    }
    
    func isFavorite(_ organizationId:  Int = 0) -> Bool {
        return favoriteOrganizations.contains { $0.organizationId == organizationId }
    }
    
    func addOrganizationToFavorites(_ organization: Organization) {
        if !isFavorite(organization.id) {
            let favorite = FavoriteOrganization(organizationId: organization.id, name: organization.login, avatarUrl: organization.avatarUrl ?? "")
            favoriteOrganizations.append(favorite)
        }
    }
    
    func removeOrganizationFromFavorites(_ organization: Organization) {
        favoriteOrganizations.removeAll { $0.organizationId == organization.id }
    }
    
    // Method to toggle the favorite status of an organization
    func toggleOrganizationFavoriteStatus(_ organization: Organization) {
        if isFavorite(organization.id) {
            removeOrganizationFromFavorites(organization)
        } else {
            addOrganizationToFavorites(organization)
        }
    }
}
