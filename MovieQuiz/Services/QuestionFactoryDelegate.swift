//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Kirill on 06.10.2022.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveNextQuestion(question: QuizQuestion?)
    
}
