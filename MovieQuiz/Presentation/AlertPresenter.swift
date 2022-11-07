//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Kirill on 06.10.2022.
//

import Foundation
import UIKit

class AlertPresenter: AlertPresenterProtocol {
   
    weak var delegate: AlertPresenterDelegate?
    init (delegate: AlertPresenterDelegate?) {
        self.delegate = delegate
    }
    func showAlert(model: AlertModel) {
        let alert = UIAlertController (title:model.title, message: model.message, preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "Game_results"
        let action = UIAlertAction (title:model.buttonText , style: .default) { _ in
            model.completion()
        }
        alert.addAction(action)
        
        delegate?.didAlert(alert: alert)
    }
    
    
}
