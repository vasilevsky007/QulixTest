//
//  QulixTestTests.swift
//  QulixTestTests
//
//  Created by Alex on 8.12.23.
//

import XCTest
@testable import QulixTest

final class QulixTestTests: XCTestCase {
    
    var giphySearcher: GiphyImageSearcher!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        // в данном методе, который запускается перед началом тестов, инициируем объект в виде класа, что позволит нам обращаться к его свойствам и методам
        giphySearcher = GiphyImageSearcher(step: 20)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        // убираем объект из памяти после окончания теста, освобождая память для запуска следующих тестов
        giphySearcher = nil
        try super.tearDownWithError()
    }
    
    func testExample() async throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        do {
            let data1 = try await giphySearcher.search(for: "cute cat")
            let data2 = try await giphySearcher.getNext()
            
            XCTAssertEqual(data1.count, 20)
            XCTAssertEqual(data2.count, 20)
            XCTAssertNotEqual(data1, data2)
        } catch {
            print("ERROR: ", error)
        }
        
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
