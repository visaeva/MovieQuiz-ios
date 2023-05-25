//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Victoria Isaeva on 11.04.2023.
//


import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    private weak var viewController: UIViewController?
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func show(alertModel: AlertModel) {
        
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { [ weak self ] _ in
            guard let self else { return }
            
            alertModel.completion?()
        }
        
        alert.addAction(action)
        viewController?.present(alert, animated: true)
        alert.view.accessibilityIdentifier = "Game results"
    }
}






