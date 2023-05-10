//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Victoria Isaeva on 05.05.2023.
//

import XCTest


final class MovieQuizUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        
        app.launch()
        
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app?.terminate()
        app = nil
    }
    
    /*
    func testExample() throws {
        
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }*/
  /*  func testScreenCast() throws {
        
    }*/
    func testYesButton() {
        sleep(3)
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
       app.buttons["Yes"].tap()
        
        sleep(3)
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
       
        
        let indexLabel = app.staticTexts["Index"]
      //  indexLabel.label
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testNoButton() {
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["No"].tap()
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
        
    }
    func testGameFinish() {
        sleep(3)
        
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(3)
        }
        let alert = app.alerts["Game results"]
        
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть еще раз")
    }
    func testAlertDismiss() {
        sleep(3)
        for _ in 1...10 {
            app.buttons["No"].tap()
            
            sleep(3)
        }
        let alert = app.alerts["Game results"]
        alert.buttons.firstMatch.tap()
            let indexLabel = app.staticTexts["Index"]
            
            XCTAssertFalse(alert.exists)
            
            XCTAssertTrue(indexLabel.label == "1/10")
        
    }
}
