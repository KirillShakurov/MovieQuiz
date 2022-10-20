//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Kirill on 11.10.2022.
//

import Foundation

protocol StatisticService {
    var totalAccuracy: Double {get}
    var gamesCount: Int {get set}
    var bestGame: GameRecord {get set}
    func store(correct count: Int, total amount: Int)
}

struct GameRecord: Codable {
    let correct: Int
    var total: Int
    let date: String
    
    static func bestResult(current: GameRecord, previous: GameRecord) -> Bool {
            return current.correct > previous.correct
        }
     }

final class StatisticServiceImplementation: StatisticService {
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    private let userDefaults = UserDefaults.standard
    
    var totalAccuracy: Double {
        get {
            let correct = userDefaults.integer(forKey: Keys.correct.rawValue)
            let total = userDefaults.integer(forKey: Keys.total.rawValue)
            return (Double(correct) / Double(total)) * 100
        }
    }
    
    var gamesCount: Int {
        get {
            return userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                      return .init(correct: 0, total: 0, date: Date().dateTimeString)
                  }
            return record
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        let gameRecord = GameRecord(correct: count, total: amount, date: Date().dateTimeString)
        let BestRecord = GameRecord.bestResult(current: gameRecord, previous: bestGame)
        
        if BestRecord {
            bestGame = gameRecord
        } else {
            print("Невозможно сохранить результат")
        }
        
        let correct = userDefaults.integer(forKey: Keys.correct.rawValue)
        let total = userDefaults.integer(forKey: Keys.total.rawValue)
        
        let newCorrect = correct + count
        let newTotal = total + amount
        
        userDefaults.set(newCorrect, forKey: Keys.correct.rawValue)
        userDefaults.set(newTotal, forKey: Keys.total.rawValue)
        
    }
}
