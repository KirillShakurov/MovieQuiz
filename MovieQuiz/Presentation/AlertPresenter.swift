//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Kirill on 06.10.2022.
//

import Foundation
import UIKit

class AlertPresenter: AlertPresenterProtocol {
   
    weak var deligate: AlertPresenterDelegate?
    init (deligate: AlertPresenterDelegate?) {
        self.deligate = deligate
    }
    func showAlert(model: AlertModel) {
        let alert = UIAlertController (title:model.title, message: model.message, preferredStyle: .alert)
        let action = UIAlertAction (title:model.buttonText , style: .default) { _ in
            model.completion()
        }
        alert.addAction(action)
        
        deligate?.didAlert(alert: alert)
    }
    
    
}
