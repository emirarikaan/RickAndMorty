//
//  CharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Emir Arıkan on 22.04.2023.
//

import UIKit

final class CharacterDetailViewController: UIViewController {
    
    var imageView: UIImageView = UIImageView()
    var characterViewModel : CharacterViewModel?
    var titleLabel: UILabel = UILabel()
    var statusLabel: UILabel = UILabel()
    var specyLabel: UILabel = UILabel()
    var genderLabel: UILabel = UILabel()
    var originLabel : UILabel = UILabel()
    var locationLabel: UILabel = UILabel()
    var episodesLabel: UILabel = UILabel()
    var createdAtLabel: UILabel = UILabel()
    var stackView: UIStackView = UIStackView()
    var topAnchorConstraint = NSLayoutConstraint()
    var centerXConstraint = NSLayoutConstraint()
    var leadingAnchorConstraint = NSLayoutConstraint()
    var centerYConstraint = NSLayoutConstraint()
    var stackViewTopAnchorConstraint = NSLayoutConstraint()
    var stackViewTopAnchorrConstraint = NSLayoutConstraint()
    var stackViewLeadingAnchorConstraint = NSLayoutConstraint()
    var stackViewLeadingAnchorrConstraint = NSLayoutConstraint()
    
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        NotificationCenter.default.addObserver(self, selector: #selector(CharacterDetailViewController.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor.black
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)
        
        super.viewDidLoad()
        // Resim görünümü
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "resim.png")
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        topAnchorConstraint = imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 30)
        
        centerXConstraint = imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)

        leadingAnchorConstraint = imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
        centerYConstraint = imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: 30)

        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 8.0
        
        // Başlık
        titleLabel.font = UIFont(name: "Avenir", size: 22)
        titleLabel.textAlignment = .center
        stackView.addArrangedSubview(titleLabel)
        
        // Metinler
        statusLabel.text = "Status"
        statusLabel.font = UIFont(name: "Avenir", size: 22)
        stackView.addArrangedSubview(statusLabel)
        
        specyLabel.text = "Specy"
        specyLabel.font = UIFont(name: "Avenir", size: 22)
        stackView.addArrangedSubview(specyLabel)
        
        genderLabel.text = "Gender"
        genderLabel.font = UIFont(name: "Avenir", size: 22)
        stackView.addArrangedSubview(genderLabel)
        
        originLabel.text = "Origin"
        originLabel.font = UIFont(name: "Avenir", size: 22)
        stackView.addArrangedSubview(originLabel)
        
        locationLabel.text = "Location"
        locationLabel.font = UIFont(name: "Avenir", size: 22)
        stackView.addArrangedSubview(locationLabel)
        
        episodesLabel.text = "Episodes"
        episodesLabel.font = UIFont(name: "Avenir", size: 22)
        stackView.addArrangedSubview(episodesLabel)
        
        createdAtLabel.text = "Created At(in API):"
        createdAtLabel.font = UIFont(name: "Avenir", size: 22)
        stackView.addArrangedSubview(createdAtLabel)
        view.addSubview(stackView)
        stackViewTopAnchorConstraint = stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20)
        stackViewLeadingAnchorConstraint =  stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        stackViewTopAnchorrConstraint = stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50)
        stackViewLeadingAnchorrConstraint = stackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20)
        NSLayoutConstraint.activate([
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        self.setupInitialOrientation()

        
        if let characterViewModel = characterViewModel {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                ImageSupporter.imageFromCharacter(characterViewModel.character) { image in
                    DispatchQueue.main.async {
                        self!.setupInitialOrientation()
                        self!.imageView.image = image
                        self!.titleLabel.text = characterViewModel.getName()
                        self!.statusLabel.text = "Status: \(characterViewModel.getStatus()!)"
                        self!.specyLabel.text = "Specy: \(characterViewModel.getSpecies()!)"
                        self!.genderLabel.text = "Gender: \(characterViewModel.getName()!)"
                        self!.originLabel.text = "Origin: \(characterViewModel.getOriginName()!)"
                        self!.locationLabel.text = "Location: \(characterViewModel.getLocationName()!)"
                        self!.episodesLabel.text = "Episodes: \(Constants.Urls.createEpisodes(urls: characterViewModel.getEpisodes()!))"
                        self!.createdAtLabel.text = "Created At:  \(characterViewModel.getCreatedAt()!)"
                    }
                }
            }
            
        }
        
    }
    @objc func rotated() {
        if UIDevice.current.orientation.isLandscape {
            topAnchorConstraint.isActive = false
            centerXConstraint.isActive = false
            leadingAnchorConstraint.isActive = true
            centerYConstraint.isActive = true
            stackViewTopAnchorConstraint.isActive = false
            stackViewLeadingAnchorConstraint.isActive = false
            stackViewLeadingAnchorrConstraint.isActive = true
            stackViewTopAnchorrConstraint.isActive = true
         //   stackView.axis = .horizontal
        } else {
            leadingAnchorConstraint.isActive = false
            centerYConstraint.isActive = false
            topAnchorConstraint.isActive = true
            centerXConstraint.isActive = true
            stackViewLeadingAnchorrConstraint.isActive = false
            stackViewTopAnchorrConstraint.isActive = false
            stackViewTopAnchorConstraint.isActive = true
            stackViewLeadingAnchorConstraint.isActive = true
     //       stackView.axis = .vertical
        }
        
    }
    func setupInitialOrientation() {
        
        
        if UIDevice.current.orientation.isLandscape {
            leadingAnchorConstraint.isActive = true
            centerYConstraint.isActive = true
            stackViewLeadingAnchorrConstraint.isActive = true
            stackViewTopAnchorrConstraint.isActive = true
            //            topAnchorConstraint.isActive = true
            //            centerXConstraint.isActive = true
        } else {
            topAnchorConstraint.isActive = true
            centerXConstraint.isActive = true
            stackViewTopAnchorConstraint.isActive = true
            stackViewLeadingAnchorConstraint.isActive = true
            //            leadingAnchorConstraint.isActive = true
            //            centerYConstraint.isActive = true
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
