//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Kirill on 06.11.2022.
//

import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    let questionsAmount: Int = 10
    var currentQuestionIndex: Int = 0
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    var correctAnswers: Int = 0
    var statisticService: StatisticService = StatisticServiceImplementation()
    var questionFactory: QuestionFactoryProtocol?
        
    init(viewController: MovieQuizViewController) {
            self.viewController = viewController

            questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
            questionFactory?.loadData()
            viewController.showLoadingIndicator()
        }
        
        // MARK: - QuestionFactoryDelegate
        
        func didLoadDataFromServer() {
            viewController?.hideLoadingIndicator()
            questionFactory?.requestNextQuestion()
        }
        
        func didFailToLoadData(with error: Error) {
            let message = error.localizedDescription
            viewController?.showNetworkError(message: message)
        }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    func noButtonClicked() {
            didAnswer(isYes: false)
        }
        
    private func didAnswer(isYes: Bool) {
            guard let currentQuestion = currentQuestion else {
                return
            }
            
            let givenAnswer = isYes
            
            viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        }
    

    
    func showNextQuestionOrResults() {
        
        if self.currentQuestionIndex == self.questionsAmount - 1 {
            
            if statisticService.gamesCount >= 0 {
                statisticService.gamesCount += 1
            }
            
            statisticService.store(correct: correctAnswers, total: self.questionsAmount)
            
            let text = "Ваш результат: \(correctAnswers) из \(self.questionsAmount)\nКоличество сыграных квизов: \(statisticService.gamesCount)\nРекорд:  \(statisticService.bestGame.correct)/\(self.questionsAmount) \(statisticService.bestGame.date)\nСредняя точность: \(String(format: "%.2f", statisticService.totalAccuracy as CVarArg))%"
            let viewModel = QuizResultsViewModel(title: "Этот раунд окончен!", text: text, buttonText: "Сыграть еще раз")
            viewController?.show(quiz: viewModel) // show result
        } else {
            self.currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
            
            
        }
        
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
   func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
}
