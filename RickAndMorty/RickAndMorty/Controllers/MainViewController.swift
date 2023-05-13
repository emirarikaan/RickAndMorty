//
//  MainViewController.swift
//  RickAndMorty
//
//  Created by Emir Arıkan on 18.04.2023.
//

import UIKit

final class MainViewController: UIViewController {
    let userDefaults = UserDefaults.standard
    private let welcomeLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createLabel()
        self.createBackground()

        
    }
    private func createBackground(){
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "rickky")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    private func createLabel(){
        welcomeLabel.textAlignment = .center
        welcomeLabel.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.alpha = 0.1
        welcomeLabel.textColor = .white
        let isFirstLaunch = userDefaults.bool(forKey: "isFirstLaunch")
        UIView.animate(withDuration: 2,delay: 0,options: .curveLinear) {
            self.welcomeLabel.alpha = 1
            
            if isFirstLaunch {
                self.userDefaults.set(false, forKey: "isFirstLaunch")
                self.welcomeLabel.text = "Welcome"
            } else {
                self.welcomeLabel.text = "Hello"
            }
            
            self.view.addSubview(self.welcomeLabel)
        }
        welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: 300).isActive = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            guard let vc = self.storyboard?.instantiateViewController(identifier:"CharactersViewController" ) as? CharactersViewController else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
