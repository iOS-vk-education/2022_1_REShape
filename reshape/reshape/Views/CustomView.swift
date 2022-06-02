//
//  CustomView.swift
//  reshape
//
//  Created by Veronika on 27.03.2022.
//

import Foundation
import UIKit

final class CustomView: UpGradientPanel {
    var progressView: CircularProgressBarView = CircularProgressBarView()
    private(set) var progressNumberLabel: UILabel = {
        let progressNumberLabel = UILabel()
        progressNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        progressNumberLabel.font = UIFont.systemFont(ofSize: 18, weight: .thin)
        progressNumberLabel.text = "0%"
        progressNumberLabel.textAlignment = .center
        progressNumberLabel.textColor = .white
        return progressNumberLabel
    }()
    private let progressLabel: UILabel = {
        let progressLabel = UILabel()
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.font = UIFont.systemFont(ofSize: 8, weight: .ultraLight)
        progressLabel.text = "прогресс"
        progressLabel.textAlignment = .center
        progressLabel.textColor = .white
        return progressLabel
    }()
    private let progressStackView: UIStackView = {
        let progressStackView = UIStackView()
        progressStackView.translatesAutoresizingMaskIntoConstraints = false
        progressStackView.spacing = 4
        progressStackView.axis = .vertical
        return progressStackView
    }()
    private(set) var targetNumberLabel: UILabel = {
        let targetNumberLabel = UILabel()
        targetNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        targetNumberLabel.textAlignment = .center
        targetNumberLabel.text = "0"
        targetNumberLabel.font = UIFont.systemFont(ofSize: 18, weight: .thin)
        targetNumberLabel.textColor = .white
        return targetNumberLabel
    }()
    private let targetLabel: UILabel = {
        let targetLabel = UILabel()
        targetLabel.translatesAutoresizingMaskIntoConstraints = false
        targetLabel.numberOfLines = 0
        targetLabel.textColor = .white
        targetLabel.font = UIFont.systemFont(ofSize: 8, weight: .ultraLight)
        targetLabel.text = "выполненных цели"
        targetLabel.textAlignment = .center
        return targetLabel
    }()
    private let targetStackView: UIStackView = {
        let targetStackView = UIStackView()
        targetStackView.translatesAutoresizingMaskIntoConstraints = false
        targetStackView.axis = .vertical
        targetStackView.spacing = 4
        return targetStackView
    }()
    private(set) var photoProgressView: PhotoProgressView = PhotoProgressView()
    private(set) var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "..."
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        nameLabel.textAlignment = .center
        nameLabel.textColor = .white
        return nameLabel
    }()
    private let motivationLabel: UILabel = {
        let motivationLabel = UILabel()
        motivationLabel.translatesAutoresizingMaskIntoConstraints = false
        motivationLabel.text = "Ты супер, так держать!"
        motivationLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        motivationLabel.textColor = .white
        return motivationLabel
    }()
    private let personalStackView: UIStackView = {
        let personalStackView = UIStackView()
        personalStackView.translatesAutoresizingMaskIntoConstraints = false
        personalStackView.axis = .vertical
        personalStackView.spacing = 4
        return personalStackView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupConstraints()
    }
    private func setupConstraints(){
        self.addSubview(progressStackView)
        progressStackView.top(127, isIncludeSafeArea: false)
        progressStackView.trailing(-39)
        progressStackView.addArrangedSubview(progressNumberLabel)
        progressNumberLabel.leading()
        progressNumberLabel.trailing()
        progressNumberLabel.height(21)
        progressStackView.addArrangedSubview(progressLabel)
        progressLabel.leading()
        progressLabel.trailing()
        progressLabel.height(10)
        progressLabel.centerX()
        self.addSubview(targetStackView)
        NSLayoutConstraint.activate([
            targetStackView.centerYAnchor.constraint(equalTo: progressStackView.centerYAnchor)
        ])
        targetStackView.leading(39)
        targetStackView.width(55)
        targetStackView.addArrangedSubview(targetNumberLabel)
        targetStackView.addArrangedSubview(targetLabel)
        targetNumberLabel.leading()
        targetNumberLabel.trailing()
        targetLabel.leading()
        targetLabel.trailing()
        targetLabel.centerX()
        self.addSubview(photoProgressView)
        photoProgressView.translatesAutoresizingMaskIntoConstraints = false
        photoProgressView.centerX()
        photoProgressView.height(135)
        photoProgressView.width(135)
        NSLayoutConstraint.activate([
            photoProgressView.centerYAnchor.constraint(equalTo: targetStackView.centerYAnchor)
        ])
        self.addSubview(personalStackView)
        personalStackView.centerX()
        NSLayoutConstraint.activate([
            personalStackView.topAnchor.constraint(equalTo: photoProgressView.bottomAnchor, constant: 33)
        ])
        personalStackView.addArrangedSubview(nameLabel)
        personalStackView.addArrangedSubview(motivationLabel)
        nameLabel.leading()
        nameLabel.trailing()
        motivationLabel.centerX()

    }
}
