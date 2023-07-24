//
//  OrganizationsViewController.swift
//  BrowsrApp
//
//  Created by Sunil Zishan on 24.07.23.
//

import UIKit
import BrowsrLib

class OrganizationsViewController: UIViewController {
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private var viewModel: OrganizationsViewModel
    private var filteredOrganizations: [Organization] = []
    private var loadingIndicator: LoadingIndicatorView!
    
    init(viewModel: OrganizationsViewModel = OrganizationsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(client: BrowsrClient) {
        self.viewModel = OrganizationsViewModel(client: client)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = OrganizationsViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        setupUI()
        setupViewModel()
        // Initialize the loading indicator
        loadingIndicator = LoadingIndicatorView()
        view.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        // Position the loading indicator at the center of the view
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Start the loading indicator
        loadingIndicator.startAnimating()
        viewModel.fetchOrganizations()
    }
    
    private func setupUI() {
        title = "Organizations"
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(OrganizationTableViewCell.self, forCellReuseIdentifier: "CellIdentifier")
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Organizations"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
    }
    
}

// MARK: - UITableViewDataSource

extension OrganizationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchActive {
            return filteredOrganizations.count
        } else {
            return viewModel.numberOfOrganizations()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue the custom cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as! OrganizationTableViewCell
        
        let organization: Organization
        if isSearchActive {
            organization = filteredOrganizations[indexPath.row]
        } else {
            guard let org = viewModel.organization(at: indexPath.row) else {
                return cell
            }
            organization = org
        }
        
        // Configure the cell using the data from the view model
        cell.configure(with: organization, isFavorite: viewModel.isFavorite(organization.id))
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension OrganizationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedOrganization: Organization
        if isSearchActive {
            selectedOrganization = filteredOrganizations[indexPath.row]
        } else {
            guard let org = viewModel.organization(at: indexPath.row) else {
                return
            }
            selectedOrganization = org
        }
        // Toggle the favorite status using the method from the view model
        viewModel.toggleOrganizationFavoriteStatus(selectedOrganization)
        tableView.reloadData()
        
        // Deselect the row after the user taps on it
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - OrganizationsViewModelDelegate

extension OrganizationsViewController: OrganizationsViewModelDelegate {
    
    func organizationsFetched() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            // Hide the loading indicator once data is fetched
            self.hideLoadingIndicator()
        }
    }
    
    func organizationsFetchFailed(with error: BrowsrLib.BrowsrError) {
        // Hide the loading indicator
        hideLoadingIndicator()
    }
    
    func showLoadingIndicator() {
        // Start animating the loading indicator
        loadingIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        // Stop animating the loading indicator
        loadingIndicator.stopAnimating()
    }
}

// MARK: - UISearchResultsUpdating

extension OrganizationsViewController: UISearchResultsUpdating {
    var isSearchActive: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        filterContentForSearchText(searchText)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        let allOrganizations = viewModel.getOrganizations()
        filteredOrganizations = allOrganizations.filter { organization in
            return organization.login.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
}
