//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Kirill on 06.11.2022.
//

import Foundation
import UIKit

final class MovieQuizPresenter {
    let questionsAmount: Int = 10
    var currentQuestionIndex: Int = 0
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    
    func yesButtonClicked() {
        guard let currentQuestion = currentQuestion else {
            return
        }
        viewController?.showAnswerResult(isCorrect: currentQuestion.correctAnswer)}
    
    func noButtonClicked() {
        guard let currentQuestion = currentQuestion else {
            return
        }
        viewController?.showAnswerResult(isCorrect: !currentQuestion.correctAnswer)}
    
   func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
}
