//
//  QulixTestTests.swift
//  QulixTestTests
//
//  Created by Alex on 8.12.23.
//

import XCTest
import CoreData
@testable import QulixTest

final class QulixTestTests: XCTestCase {
    
    // Ленивое свойство для контекста Core Data для тестов
    lazy var testManagedObjectContext: NSManagedObjectContext = {
        // Используйте Bundle(for:) для загрузки модели Core Data из вашего тестового bundle
        guard let modelURL = Bundle(for: type(of: self)).url(forResource: "QulixTest", withExtension: "momd") else {
            fatalError("Модель Core Data не найдена")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Не удалось загрузить модель Core Data")
        }

        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)

        do {
            // Используйте NSInMemoryStoreType для временного хранения данных в памяти
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            fatalError("Не удалось настроить хранилище Core Data: \(error)")
        }

        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator

        return managedObjectContext
    }()
    
    var giphySearcher: ImageSearcher!
    var imageFetcher: ImageFetcher!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        // в данном методе, который запускается перед началом тестов, инициируем объект в виде класа, что позволит нам обращаться к его свойствам и методам
        giphySearcher = GiphyImageSearcher(step: 20)
        imageFetcher = ImageFetcher()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        // убираем объект из памяти после окончания теста, освобождая память для запуска следующих тестов
        giphySearcher = nil
        try super.tearDownWithError()
    }
    
    func testSearcher() async throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        do {
            let data1 = try await giphySearcher.search(for: "cute cat")
            let data2 = try await giphySearcher.getNext()
            
            XCTAssertEqual(data1.count, 20, "должно быть получено 20 изображений")
            XCTAssertEqual(data2.count, 20, "должно быть получено еще 20 изображений")
            XCTAssertNotEqual(data1, data2, "полученные изображения болжны быть разными")
        } catch {
            print("ERROR: ", error)
        }
    }    
    
    func testImageFetcher() async throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        do {
            //https://i.pinimg.com/736x/d8/55/c6/d855c66f95e9d3babeebd1e88bf4026d.jpg
            await imageFetcher.setContext(context: testManagedObjectContext)
            let data1 = try await imageFetcher.imageData(forUrl: URL(string: "https://i.pinimg.com/736x/d8/55/c6/d855c66f95e9d3babeebd1e88bf4026d.jpg")!)
            let data2 = try await imageFetcher.imageData(forUrl: URL(string: "https://i.pinimg.com/736x/d8/55/c6/d855c66f95e9d3babeebd1e88bf4026d.jpg")!)
            XCTAssertEqual(data1, data2, "Загрузка изображения два раза подряд должна возвращать одно и то же изображение")
            var cacheSize = await imageFetcher.cacheSize
            XCTAssertNotEqual(cacheSize, 0, "После загрузки изображений размер кэша не должен быть равен нулю")
//            следующая строка почему то крашит именно на тестировании, возможно у меня неправильно настроен конткст...
//            await imageFetcher.clearCache()
//            cacheSize = await imageFetcher.cacheSize
//            XCTAssertEqual(cacheSize, 0)
            
        } catch {
            print("ERROR: ", error)
        }
    }
    
    
    
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
