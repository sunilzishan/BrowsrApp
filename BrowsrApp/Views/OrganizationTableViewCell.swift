//
//  OrganizationTableViewCell.swift
//  BrowsrApp
//
//  Created by Sunil Zishan on 24.07.23.
//

import UIKit
import BrowsrLib

class OrganizationTableViewCell: UITableViewCell {
    // UI elements for displaying the organization data
    private let nameLabel = UILabel()
    private let avatarImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil // Clear the image while waiting for the new one
    }
    
    private func setupUI() {
        // Set up the UI elements and layout constraints
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(avatarImageView)
        
        // Add constraints for nameLabel
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        // Add constraints for avatarImageView
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 40),
            avatarImageView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Customize the appearance of the cell elements
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        nameLabel.textColor = .black
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.layer.cornerRadius = 20
        avatarImageView.clipsToBounds = true
    }
    
    
    func configure(with organization: Organization, isFavorite: Bool) {
        // Configure the cell with the organization data
        nameLabel.text = organization.login
        
        if let avatarURLString = organization.avatarUrl, let _ = URL(string: avatarURLString) {
            // Fetch and cache the avatar picture using the BrowsrClient method
            BrowsrClient().fetchAndStoreAvatarPicture(for: organization) { [weak self] (data, error) in
                guard let self = self else { return }
                
                if let data = data {
                    DispatchQueue.main.async {
                        self.avatarImageView.image = UIImage(data: data)
                    }
                } else if let error = error {
                    print("Error fetching image: \(error)")
                }
            }
        }
        
        // Set the accessory view based on the favorite status
        accessoryView = isFavorite ? UIImageView(image: UIImage(systemName: "star.fill")) : nil
    }
    
}
