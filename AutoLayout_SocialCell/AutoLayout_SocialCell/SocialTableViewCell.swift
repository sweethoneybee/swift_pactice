//
//  SocialTableViewCell.swift
//  AutoLayout_SocialCell
//
//  Created by 정성훈 on 2021/04/18.
//

import UIKit

class SocialTableViewCell: UITableViewCell {
    private var stackView: UIStackView!
    var profileImageView: UIImageView!
    var nameLabel: UILabel!
    var uploadTimeLabel: UILabel!
    var bodyTextLabel: UILabel!
    var bodyImageView: UIImageView!
    var likeCount: UILabel!
    private var thumbsUpImageView: UIImageView!
    private var buttonStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setUp()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func setUp() {
        // profile line
        profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
//        profileImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal) // 얘 다시 확인해보기
         
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .preferredFont(forTextStyle: .caption1)
//        nameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        uploadTimeLabel = UILabel()
        uploadTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        uploadTimeLabel.font = .preferredFont(forTextStyle: .caption2)
        uploadTimeLabel.setContentHuggingPriority(.init(1), for: .horizontal)
        uploadTimeLabel.textAlignment = .left
        
        let profileStack = UIStackView(arrangedSubviews: [profileImageView, nameLabel, uploadTimeLabel])
        profileStack.translatesAutoresizingMaskIntoConstraints = false
        profileStack.axis = .horizontal
        profileStack.distribution = .fill
        profileStack.alignment = .center
        profileStack.spacing = 5
        
        // body
        bodyTextLabel = UILabel()
        bodyTextLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyTextLabel.font = .preferredFont(forTextStyle: .body)
        bodyTextLabel.numberOfLines = 0
        bodyTextLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        bodyImageView = UIImageView()
        bodyImageView.translatesAutoresizingMaskIntoConstraints = false
        bodyImageView.clipsToBounds = true
        bodyImageView.contentMode = .scaleAspectFill
        
        // Whole Stack View
        stackView = UIStackView(arrangedSubviews: [profileStack, bodyTextLabel, bodyImageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = UIStackView.spacingUseSystem
        
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor),
            profileImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.1),
            bodyImageView.widthAnchor.constraint(equalTo: bodyImageView.heightAnchor)
        ])
        
    }
}
