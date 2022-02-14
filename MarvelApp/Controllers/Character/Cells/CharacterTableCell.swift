//
//  CharacterTableCell.swift
//  MarvelApp
//
//  Created by andrey rulev on 13.02.2022.
//

import UIKit
import SDWebImage

class CharacterTableCell: BaseTableViewCell {
    
    // MARK: - Private properties
    
    @IBOutlet private var avatarImage: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        descriptionLabel.text = nil
        avatarImage.sd_cancelCurrentImageLoad()
        avatarImage.layer.removeAllAnimations()
        avatarImage.image = nil
    }
    
    // MARK: - Configure
    
    func configure(_ character: Character?) {
        nameLabel.text = character?.name
        descriptionLabel.text = character?.description
        
        if let path = character?.avatar?.path,
           let ext = character?.avatar?.ext {
            let urlLink = "\(path).\(ext)"
            let avatarUrl = URL(string: urlLink)
            avatarImage.sd_setImage(with: avatarUrl)
        }
    }
    
    func configure(_ comics: Comics?) {
        nameLabel.text = comics?.title
        descriptionLabel.text = comics?.description
        
        if let path = comics?.avatar?.path,
           let ext = comics?.avatar?.ext {
            let urlLink = "\(path).\(ext)"
            let avatarUrl = URL(string: urlLink)
            avatarImage.sd_setImage(with: avatarUrl)
        }
    }
}
