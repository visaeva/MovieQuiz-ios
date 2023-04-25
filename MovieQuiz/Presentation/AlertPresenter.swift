//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Victoria Isaeva on 11.04.2023.
//


import UIKit


final class ResultAlertPresenter: AlertPresenterProtocol {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
    
    func show(alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in alertModel.completion()}
        
        alert.addAction(action)
        self.viewController?.present(alert, animated: true)
    }
}






