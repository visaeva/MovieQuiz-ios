//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Victoria Isaeva on 11.04.2023.
//


import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    private weak var viewController: UIViewController?
    private var presenter: MovieQuizPresenter
    init(viewController: UIViewController?, presenter: MovieQuizPresenter) {
        self.viewController = viewController
        self.presenter = presenter
    }
    
    func show(alertModel: AlertModel) {
        
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { [weak self] _ in
            guard let self = self else {return}
            alertModel.completion()
            
            self.presenter.restartGame()
        }
        
        alert.addAction(action)
        viewController?.present(alert, animated: true)
        
    }
}






