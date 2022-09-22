import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
            super.viewDidLoad()
            show(quiz: convert(model: questions[currentQuestionIndex]))
        }
        
        private func show(quiz step: QuizStepViewModel) {
            imageView.image = convert(model: questions[currentQuestionIndex]).image
            textLabel.text = convert(model: questions[currentQuestionIndex]).question
            counterLabel.text = convert(model: questions[currentQuestionIndex]).questionNumber
        }
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
    }
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        showAnswerResult(isCorrect: questions[currentQuestionIndex].correctAnswer)
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        showAnswerResult(isCorrect: questions[currentQuestionIndex].correctAnswer)
    }

    private var currentQuestionIndex: Int = 0
    private var correctAnswers = 0
    private func show(quiz result: QuizResultsViewModel) {
            let alert = UIAlertController(title: result.title, message: result.text, preferredStyle: .alert)
            let action = UIAlertAction(title: result.buttonText, style: .default, handler: { _ in
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                let firstQuestion = self.questions[self.currentQuestionIndex]
                let viewModel = self.convert(model: firstQuestion)
                self.show(quiz: viewModel)
            })
            
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(), // распаковываем картинку
            question: model.text, // берём текст вопроса
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)") // высчитываем номер вопроса
    }

    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen?.cgColor : UIColor.ypRed?.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }

    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            let text = "Ваш результат: \(correctAnswers) из 10"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            
            show(quiz: viewModel)
        }
    }
    
    private let questions: [QuizQuestion] = [
        QuizQuestion (
            image:"The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion (
            image:"The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion (
            image:"Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion (
            image:"The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion (
            image:"Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion (
            image:"The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion (
            image:"Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion (
            image:"The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion (
            image:"Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion (
            image:"Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        
    ]
}


// для состояния "Вопрос задан"
struct QuizStepViewModel {
  let image: UIImage
  let question: String
  let questionNumber: String
}

// для состояния "Результат квиза"
struct QuizResultsViewModel {
  let title: String
  let text: String
  let buttonText: String
}

// для состояния "Ответ квиза"
struct QuizResultsQuestionViewModel {
    let answer: Bool
}

struct QuizQuestion {
  let image: String
  let text: String
  let correctAnswer: Bool
}
