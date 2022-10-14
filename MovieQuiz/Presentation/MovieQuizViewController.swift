import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers = 0
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService = StatisticServiceImplementation()
    
    
    struct Actor {
        let id: String
        let image: String
        let name: String
        let asCharacter: String
    }
    
    struct Movie {
        let id: String
        let title: String
        let year: Int
        let image: String
        let releaseDate: String
        let runtimeMins: Int
        let directors: String
        let actorList: [Actor]
    }
    
    
    
    override func viewDidLoad() {
            super.viewDidLoad()

        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        alertPresenter = AlertPresenter(deligate: self)
        
        }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }

    @IBAction private func yesButtonClicked(_ sender: UIButton) {
    guard let currentQuestion = currentQuestion else {
        return
    }
    showAnswerResult(isCorrect: currentQuestion.correctAnswer)}

    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: !currentQuestion.correctAnswer)}


    private func show(quiz result: QuizResultsViewModel) {
    let alertModel = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText) {
        self.currentQuestionIndex = 0
        self.correctAnswers = 0
        self.questionFactory?.requestNextQuestion()
    }
    alertPresenter?.showAlert(model: alertModel)

    }

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
    return QuizStepViewModel(
        image: UIImage(named: model.image) ?? UIImage(),
        question: model.text,
        questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
}

    private func showAnswerResult(isCorrect: Bool) {
    if isCorrect {
        correctAnswers += 1
    }
    
    imageView.layer.masksToBounds = true
    imageView.layer.borderWidth = 8
    imageView.layer.borderColor = isCorrect ? UIColor.ypGreen?.cgColor : UIColor.ypRed?.cgColor
    yesButton.isEnabled = false
    noButton.isEnabled = false
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in
        guard let self = self else { return }
        
        self.showNextQuestionOrResults()
        self.imageView.layer.borderWidth = 0
        self.yesButton.isEnabled = true
        self.noButton.isEnabled = true
    }
}

    private func showNextQuestionOrResults() {
        
        if currentQuestionIndex == questionsAmount - 1 {
            
            if statisticService.gamesCount >= 0 {
                statisticService.gamesCount += 1
            }
            
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            
            let text = "Ваш результат: \(correctAnswers) из \(questionsAmount)\nКоличество сыграных квизов: \(statisticService.gamesCount)\nРекорд:  \(statisticService.bestGame.correct)/\(questionsAmount) \(statisticService.bestGame.date)\nСредняя точность: \(String(format: "%.2f", statisticService.totalAccuracy as CVarArg))%"
            let viewModel = QuizResultsViewModel(title: "Этот раунд окончен!", text: text, buttonText: "Сыграть еще раз")
            show(quiz: viewModel) // show result
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
        
    }
    
    func didAlert(alert: UIAlertController?) {
        guard let alert = alert else {
            return
        }
        present(alert, animated: true, completion: nil)
    }
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
}

