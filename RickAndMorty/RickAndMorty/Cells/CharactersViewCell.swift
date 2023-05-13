//
//  CharactersViewCell.swift
//  RickAndMorty
//
//  Created by Emir Arıkan on 21.04.2023.
//

import UIKit
protocol CharacterCollectionViewCellDelegate:AnyObject{
    func navigateToCharacterDetail(indexPath:IndexPath)
}

final class CharactersViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    var characterColl:CharacterCollectionViewCellDelegate?
    var indexPath:IndexPath?
    @IBOutlet weak var imageView: UIImageView!
    override func layoutSubviews() {
        super.layoutSubviews()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
        
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        _ = tapGestureRecognizer.view as! UIImageView
        guard let indexPath = indexPath else { return }
        characterColl?.navigateToCharacterDetail(indexPath: indexPath)
        
        
    }
    
    
    
}
