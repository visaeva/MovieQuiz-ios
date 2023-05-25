//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Victoria Isaeva on 10.04.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {               
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
