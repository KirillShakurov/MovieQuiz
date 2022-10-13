//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Kirill on 07.10.2022.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
