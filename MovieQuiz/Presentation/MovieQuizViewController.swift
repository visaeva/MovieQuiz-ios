import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - Lifecycle
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var noClickedButton: UIButton!
    
    @IBOutlet private weak var yesClickedButton: UIButton!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private let presenter = MovieQuizPresenter()
   
    private var correctAnswers = 0
 
    private var questionFactory: QuestionFactoryProtocol?
  
    private var statisticService: StatisticService = StatisticServiceImplementation()
    
    private var alertPresenter: AlertPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        
        
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        questionFactory?.loadData()
        
        statisticService = StatisticServiceImplementation()
        
        alertPresenter = ResultAlertPresenter(viewController: self)
        
        presenter.viewController = self
       
    }
    
  @IBAction private func yesButtonClicked(_ sender: UIButton) {
     
      presenter.yesButtonClicked()
    }
    
    
  @IBAction private func noButtonClicked(_ sender: UIButton) {
   
      presenter.noButtonClicked()
    }
    
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.currentQuestion = question
        guard let question = question else {
            return
        }
        
        let viewModel = presenter.convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
            self?.activityIndicator.stopAnimating()
        }
    }
    
    
    private func show (quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func showNextQuestionOrResults() {
        activityIndicator.startAnimating()
        
            if presenter.isLastQuestion() {
            statisticService.store(correct: correctAnswers, total: presenter.questionsAmount)
            
            let bestGame = statisticService.bestGame
            let date = bestGame.date.dateTimeString
            let gamesCount = statisticService.gamesCount
            
                let message = "Ваш результат: \(correctAnswers)/\(presenter.questionsAmount)\nКоличество сыгранных квизов: \(gamesCount)\nРекорд: \(bestGame.correct)/10 (\(date))\nСредняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
            
            let viewModel:AlertModel = AlertModel(title: "Этот раунд окончен!", message: message, buttonText: "Сыграть еще раз") {[weak self] in
                guard let self = self else {return}
             //   self.currentQuestionIndex = 0
                self.presenter.resetQuestionIndex()
                self.correctAnswers = 0
                
                self.questionFactory?.requestNextQuestion()
            }
            alertPresenter?.show(alertModel: viewModel)
            
        } else {
            presenter.switchToNextQuestion()
           // currentQuestionIndex += 1
            self.questionFactory?.requestNextQuestion()
            
        }
    }
    
     func showAnswerResult(isCorrect: Bool) {
        yesClickedButton.isEnabled = false
        noClickedButton.isEnabled = false
        
        if isCorrect {
            correctAnswers += 1
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                self.imageView.layer.borderWidth = 0
                self.yesClickedButton.isEnabled = true
                self.noClickedButton.isEnabled = true
                self.showNextQuestionOrResults()
            }
        } else {
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = UIColor.ypRed.cgColor
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                self.imageView.layer.borderWidth = 0
                self.yesClickedButton.isEnabled = true
                self.noClickedButton.isEnabled = true
                self.showNextQuestionOrResults()
            }
        }
    }
    
    private func showNetworkError(message: String) {
        activityIndicator.stopAnimating()
        let viewModel = AlertModel(title: "Ошибка", message: message, buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else {return}
            
            self.presenter.resetQuestionIndex()
          //  self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            self.questionFactory?.loadData()
        }
        alertPresenter?.show(alertModel: viewModel)
    }
    
    func didLoadDataFromServer() {
        activityIndicator.startAnimating()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
}




/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
