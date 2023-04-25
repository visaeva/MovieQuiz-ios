//
//  Movie.swift
//  MovieQuiz
//
//  Created by Victoria Isaeva on 17.04.2023.
//

import Foundation
struct Actor: Codable {
    let id: String
    let image: String
    let name: String
    let asCharacter: String
}

struct Movie: Codable {
  let id: String
  let rank: String
  let title: String
  let fullTitle: String
  let year: String
  let image: String
  let crew: String
  let imDbRating: String
  let imDbRatingCount: String
}

struct Top: Decodable {
    let items: [Movie]
}

let result = try? JSONDecoder().decode(Top.self, from: data)


func getMovie(from jsonString: String) -> Movie? {
    var movie: Movie? = nil
    do {
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

        guard let json = json,
              let id = json["id"] as? String,
              let title = json["title"] as? String,
              let jsonYear = json["year"] as? String,
              let year = Int(jsonYear),
              let image = json["image"] as? String,
              let releaseDate = json["releaseDate"] as? String,
              let jsonRuntimeMins = json["runtimeMins"] as? String,
              let runtimeMins = Int(jsonRuntimeMins),
              let directors = json["directors"] as? String,
              let actorList = json["actorList"] as? [Any] else {
            return nil
        }

        var actors: [Actor] = []

        for actor in actorList {
            guard let actor = actor as? [String: Any],
                  let id = actor["id"] as? String,
                  let image = actor["image"] as? String,
                  let name = actor["name"] as? String,
                  let asCharacter = actor["asCharacter"] as? String else {
                return nil
            }
            let mainActor = Actor(id: id,
                                  image: image,
                                  name: name,
                                  asCharacter: asCharacter)
            actors.append(mainActor)
        }
        movie = Movie(id: id,
                      title: title,
                      year: year,
                      image: image,
                      releaseDate: releaseDate,
                      runtimeMins: runtimeMins,
                      directors: directors,
                      actorList: actors)
    } catch {
        print("Failed to parse: \(jsonString)")
    }

    return movie
}

