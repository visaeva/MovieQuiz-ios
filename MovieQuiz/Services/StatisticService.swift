//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Victoria Isaeva on 19.04.2023.
//

import Foundation

protocol StatisticService {
    
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
    private var accuracyTotal:Double = 0
    private var countGame:Int = 0
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    func store(correct count: Int, total amount: Int) {
        
        let accuracyGame = Double(count) / Double(amount) * 100
        
        totalAccuracy = (Double(gamesCount) * totalAccuracy + accuracyGame) / Double(gamesCount + 1)
        
        gamesCount += 1
        
        let newRecord = GameRecord(correct: count, total: amount, date: Date())
        
        if bestGame < newRecord {
            bestGame = newRecord
        }
    }
    
    var totalAccuracy: Double {
        get {
            return self.accuracyTotal
        }
        set {
            self.accuracyTotal = newValue
        }
    }
    
    var gamesCount: Int {
        get {
            return self.countGame
        }
        set {
            self.countGame = newValue
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
