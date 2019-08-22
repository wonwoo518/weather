//
//  kkhwTests.swift
//  kkhwTests
//
//  Created by wonwoo on 09/08/2019.
//  Copyright © 2019 wonwoo. All rights reserved.
//

import XCTest
import RxSwift
import MapKit
@testable import kkhw

class kkhwTests: XCTestCase {

    let bag = DisposeBag()
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRequestCurrentWeather() {

        let expect = expectation(description: "currentWeather")
        
        OpenWeatherService.shared.currentWeather(param: ["id":"524901"]).subscribe{
            XCTAssertTrue($0.element != nil)
            expect.fulfill()
            }.disposed(by: bag)
        
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("error:\(error)")
            }
        }
    }
    
    func testRequestForecast() {
        
        let expect = expectation(description: "forecast")
        
        OpenWeatherService.shared.weatherForecast(param: ["id":"524901"]).subscribe{
            XCTAssertTrue($0.element != nil)
            expect.fulfill()
            }.disposed(by: bag)
        
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("error:\(error)")
            }
        }
    }
}
