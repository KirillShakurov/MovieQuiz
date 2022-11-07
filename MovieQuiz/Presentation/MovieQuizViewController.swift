import UIKit

final class MovieQuizViewController: UIViewController, AlertPresenterDelegate {
    
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!  
    
    private var alertPresenter: AlertPresenterProtocol?
    private var presenter: MovieQuizPresenter!
    var statisticService: StatisticService = StatisticServiceImplementation()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        imageView.layer.cornerRadius = 20
        alertPresenter = AlertPresenter(delegate: self)
        presenter.questionFactory?.loadData()
        showLoadingIndicator()
        presenter.viewController = self
        

    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
    }

    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            self.showLoadingIndicator()
            self.presenter.restartGame()
        }
        DispatchQueue.main.async { [weak self] in
            self?.alertPresenter?.showAlert(model: model)
                }
        
    }
    
    func show (quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText) {
            self.presenter.restartGame()
        }
        alertPresenter?.showAlert(model: alertModel)
        
    }
    
     func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            presenter.correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen?.cgColor : UIColor.ypRed?.cgColor
        yesButton.isEnabled = false
        noButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in
            guard let self = self else { return }
            
            self.presenter.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
        }
    }
    
    private func showNextQuestionOrResults() {
        
        if presenter.currentQuestionIndex == presenter.questionsAmount - 1 {
            
            if statisticService.gamesCount >= 0 {
                statisticService.gamesCount += 1
            }
            
            statisticService.store(correct: presenter.correctAnswers, total: presenter.questionsAmount)
            
            let text = "Ваш результат: \(presenter.correctAnswers) из \(presenter.questionsAmount)\nКоличество сыграных квизов: \(statisticService.gamesCount)\nРекорд:  \(statisticService.bestGame.correct)/\(presenter.questionsAmount) \(statisticService.bestGame.date)\nСредняя точность: \(String(format: "%.2f", statisticService.totalAccuracy as CVarArg))%"
            let viewModel = QuizResultsViewModel(title: "Этот раунд окончен!", text: text, buttonText: "Сыграть еще раз")
            show(quiz: viewModel) // show result
        } else {
            presenter.currentQuestionIndex += 1
            presenter.questionFactory?.requestNextQuestion()
            
            
        }
        
    }
    
    func didAlert(alert: UIAlertController?) {
        guard let alert = alert else {
            return
        }
        present(alert, animated: true, completion: nil)
    }
    
    
}
