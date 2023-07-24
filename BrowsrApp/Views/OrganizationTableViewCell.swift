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
        fatalError("init(coder:) has not been implemented")
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
        
        if let avatarURLString = organization.avatarUrl, let avatarURL = URL(string: avatarURLString) {
            NetworkManager.shared.fetchImage(from: avatarURL) { (image) in
                DispatchQueue.main.async {
                    self.avatarImageView.image = image
                    self.setNeedsLayout()
                }
            }
        }
        
        // Set the accessory view based on the favorite status
        accessoryView = isFavorite ? UIImageView(image: UIImage(systemName: "star.fill")) : nil
    }
}
