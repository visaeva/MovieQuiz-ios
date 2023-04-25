//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Victoria Isaeva on 10.04.2023.
//


import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)
}


