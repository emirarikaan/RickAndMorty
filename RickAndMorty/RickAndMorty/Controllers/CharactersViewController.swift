//
//  CharactersViewController.swift
//  RickAndMorty
//
//  Created by Emir Arıkan on 18.04.2023.
//

import UIKit

class CharactersViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var previousButton: UIButton?
    
    private var locationVM = [Location]()
    var scView:UIScrollView!
    var locationViewModel = [LocationViewModel]()
    let charactersListViewModel = CharacterListViewModel()
    private var viewModel: LocationListViewModel = LocationListViewModel()
    let locationListViewModel = LocationListViewModel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor.black
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)
        view.backgroundColor = UIColor(named: "Red")
        navigationController?.navigationBar.backgroundColor = .black
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = forCollectionViewLayout()
        locationListViewModel.fetchLocations { [weak self] locationViewModels in
            DispatchQueue.main.async {
                self?.createScrollView()
                self?.charactersListViewModel.fetchCharacters(for: locationViewModels[0].location.residents, completion: { character in
                    
                    self?.updateCollectionView()
                    NotificationCenter.default.addObserver(self! , selector: #selector(self!.viewWillTransition(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
                })
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func viewWillTransition(_ notification: Notification) {
        let isLandscape = UIDevice.current.orientation.isLandscape
        NSLayoutConstraint.deactivate(scView.constraints)
        scView.translatesAutoresizingMaskIntoConstraints = false
        
        let verticalConstraints = [
            scView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scView.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let horizontalConstraints = [
            scView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scView.heightAnchor.constraint(equalToConstant: 50),
            scView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ]
        
        if isLandscape {
            NSLayoutConstraint.activate(horizontalConstraints)
            
        } else {
            NSLayoutConstraint.activate(verticalConstraints)
            
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            
        }
    }
    
    
    
    func updateCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.collectionViewLayout = self.forCollectionViewLayout()
            self.collectionView.reloadData()
        }
    }
    
    private func createScrollView(){
        scView = UIScrollView()
        let buttonPadding:CGFloat = 10
        var xOffset:CGFloat = 10
        scView.isPagingEnabled = false
        scView.showsHorizontalScrollIndicator = false
        scView.isScrollEnabled = true
        view.addSubview(scView)
        scView.translatesAutoresizingMaskIntoConstraints = false
        scView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        scView.backgroundColor = UIColor(named: "Main")
        
        
        for i in 0 ... locationListViewModel.locationViewModels.count-1 {
            let button = UIButton()
            button.tag = i
            button.backgroundColor = UIColor.black
            button.layer.cornerRadius = 10
            button.setTitle(self.locationListViewModel.locationViewModels[i].name, for: .normal)
            button.addTarget(self, action: #selector(btnTouch), for: .touchUpInside)
            if i == 0 {
                button.backgroundColor = UIColor(named: "Blue")
                previousButton = button
            }
            button.frame = CGRect(x: xOffset, y: CGFloat(buttonPadding), width: 170, height: 30)
            xOffset = xOffset + CGFloat(buttonPadding) + button.frame.size.width
            scView.addSubview(button)
        }
        scView.contentSize = CGSize(width: xOffset, height: scView.frame.height)
    }
    
    
    
    
    @objc func btnTouch ( sender : UIButton){
        let selectedButton = sender
        if let prevButton = previousButton {
            UIView.animate(withDuration: 0.6) {
                prevButton.backgroundColor = UIColor.black
            }
        }
        previousButton = sender
        UIView.animate(withDuration: 0.6,
                       animations: {
            selectedButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            selectedButton.backgroundColor = UIColor(named: "Blue")
        },
                       completion: { _ in
            UIView.animate(withDuration: 0.6) {
                selectedButton.transform = CGAffineTransform.identity
                
            }
        })
        
        
        self.charactersListViewModel.characterViewModels.removeAll()
        if locationListViewModel.locationViewModels[sender.tag].location.residents.count == 0 {
            
            self.updateCollectionView()
        }
        if locationListViewModel.locationViewModels[sender.tag].location.residents.count == 1{
            self.charactersListViewModel.fetchCharacter(for: self.locationListViewModel.locationViewModels[sender.tag].location.residents) { characterVM in
                
                var characterArr = [CharacterViewModel]()
                characterArr.append(characterVM)
                self.charactersListViewModel.characterViewModels = characterArr
                self.updateCollectionView()
            }
        }
        else{
            self.charactersListViewModel.fetchCharacters(for: self.locationListViewModel.locationViewModels[sender.tag].location.residents) { characterVM in
                self.charactersListViewModel.characterViewModels = characterVM
                self.updateCollectionView()
            }
        }
        
    }
}

extension CharactersViewController : UICollectionViewDelegate,UICollectionViewDataSource,CharacterCollectionViewCellDelegate{
    func navigateToCharacterDetail(indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(identifier:"CharacterDetailViewController" ) as? CharacterDetailViewController else {return}
        
        
        vc.characterViewModel = self.charactersListViewModel.characterViewModels[indexPath.row]
        UIView.animate(withDuration: 0.6,
                       animations: {
            vc.imageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            
        },
                       completion: { _ in
            UIView.animate(withDuration: 0.6) {
                vc.imageView.transform = CGAffineTransform.identity
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
        //    navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return charactersListViewModel.characterViewModels.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let characterVM = self.charactersListViewModel.characterViewModels[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CharactersViewCell
        
        DispatchQueue.global(qos: .background).async {
            ImageSupporter.imageFromCharacter(characterVM.character) { image in
                if let image = image {
                    DispatchQueue.main.async(execute: {
                        cell.label.text = characterVM.getName()
                        cell.imageView.image = image
                        if characterVM.getGender() == "Male"{
                            cell.backgroundColor = UIColor(named: "Blue")
                        }
                        else if characterVM.getGender()  == "Female"{
                            cell.backgroundColor = UIColor(named: "Pink")
                        }
                        else if characterVM.getGender()  == "unknown"{
                            cell.backgroundColor = UIColor(named: "Brown")
                        }
                        else{
                            cell.backgroundColor = .gray
                        }
                        cell.indexPath = indexPath
                        cell.characterColl = self
                    })
                }
            }
        }
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    func forCollectionViewLayout() ->UICollectionViewFlowLayout {
        collectionView.backgroundColor = UIColor(named: "Red")
        let collectionViewWidth = self.collectionView.frame.size.width
        let collectionViewHeight = self.collectionView.frame.size.height
        let isLandscape = UIDevice.current.orientation.isLandscape
        
        let design: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        design.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        
        if isLandscape {
            // Yatay modda
            design.itemSize = CGSize(width: collectionViewHeight/5, height: 180)
            design.minimumLineSpacing = 10
        } else {
            // Dikey modda
            design.itemSize = CGSize(width: collectionViewWidth/3-10, height: 180)
            design.minimumLineSpacing = 10
        }
        return design
    }
}














