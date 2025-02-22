//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Victoria Isaeva on 19.04.2023.
//

import Foundation

protocol StatisticService {
    var correct:Int { get }
    var total: Int { get }
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    
    func store(correct count: Int, total amount: Int)
}


extension GameRecord: Comparable {
    static func <(lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct < rhs.correct
    }
}


final class StatisticServiceImplementation: StatisticService {
    
    private let userDefaults = UserDefaults.standard
    
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    func store(correct count: Int, total amount: Int) {
        
        correct += count
        gamesCount += 1
        total += amount
        let newGame = GameRecord(correct: count, total: amount, date: Date())
        if newGame.correct > bestGame.correct {
            bestGame = newGame
        }
    }
    
    var correct: Int {
        get {
            userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    var total: Int {
        get {
            userDefaults.integer(forKey: Keys.total.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
        
    }
    
    var totalAccuracy:Double {
        get {
            if userDefaults.double(forKey: Keys.total.rawValue) == 0 {
                return 0
            }
            return userDefaults.double(forKey: Keys.correct.rawValue) / userDefaults.double(forKey: Keys.total.rawValue) * 100
        }
    }
    
    var gamesCount:  Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
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
}




//MARK: - Struct


struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
}
