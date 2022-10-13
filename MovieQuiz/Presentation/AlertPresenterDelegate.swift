//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Kirill on 06.10.2022.
//

import Foundation
import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func didAlert(alert: UIAlertController?)
    
}
