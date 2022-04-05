//
//  RegisterScreenViewController.swift
//  reshape
//
//  Created by Veronika on 04.04.2022.
//  
//

import UIKit

final class RegisterScreenViewController: UIViewController {
    private let output: RegisterScreenViewOutput
    private let customNavigationBarView: NavigationBarView = {
        let navBar = NavigationBarView()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        return navBar
    }()
    private var addPhoto: UIImageView = {
        var photo = UIImageView()
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.image = UIImage(named: "Add")
        return photo
    }()
    private var imagePicker: ImagePicker!
    init(output: RegisterScreenViewOutput) {
        self.output = output
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setupUI()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addPhoto.layer.cornerRadius = addPhoto.frame.size.height / 2
//        addPhoto.contentMode = .center
        addPhoto.layer.masksToBounds = true
    }
}

extension RegisterScreenViewController {
    private func setupConstraints(){
        view.addSubview(customNavigationBarView)
        customNavigationBarView.top(isIncludeSafeArea: false)
        customNavigationBarView.leading()
        customNavigationBarView.trailing()
        customNavigationBarView.height(80)
        
        addPhoto.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addPhoto)
        addPhoto.centerX()
        addPhoto.top(104, isIncludeSafeArea: false)
        addPhoto.height(130)
        addPhoto.width(130)
        
    }
    private func setupUI(){
        view.backgroundColor = .white
        customNavigationBarView.delegate = self
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        addPhoto.isUserInteractionEnabled = true
        addPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectPhoto)))

    }
    
    @objc
    func selectPhoto(){
        imagePicker.present(from: addPhoto)
    }
}


extension RegisterScreenViewController: NavigationBarDelegate{
    func backButtonAction() {
        output.backButtonPressed()
    }
}

extension RegisterScreenViewController: ImagePickerDelegate{
    func didSelect(image: UIImage?) {
        self.addPhoto.image = image
    }
}

extension RegisterScreenViewController: RegisterScreenViewInput {
}
