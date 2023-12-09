//
//  ImageFetcher.swift
//  QulixTest
//
//  Created by Alex on 9.12.23.
//

import Foundation
import CoreData

actor ImageFetcher {
    
    private var imageCache: [URL:Data]
    private var context: NSManagedObjectContext!
    private let session: URLSession
    
    func setContext(context: NSManagedObjectContext) {
        self.context = context
        self.loadCacheFromCoreData()
    }
    
    init() {
        let config = URLSessionConfiguration.default
        self.session = URLSession(configuration: config)
        self.imageCache = [:]
        self.context = nil
    }
    
    func imageData(forUrl imageURL: URL) async throws -> Data {
        if let cachedData = imageCache[imageURL] {
            print("using cached image")
            return cachedData
        }
        let (data, _) = try await session.data(for: request(url: imageURL))
        imageCache.updateValue(data, forKey: imageURL)
        Task.detached {
            await self.saveImageToCoreData(data: data, url: imageURL)
        }
        return data
    }
    
    private func saveImageToCoreData(data: Data, url: URL) {
        let pictureCacheEntity = NSEntityDescription.entity(forEntityName: "PictureCacheEntity", in: context)!
        let userManagedObject = NSManagedObject(entity: pictureCacheEntity, insertInto: context)
        userManagedObject.setValue(url.absoluteString, forKey: "url")
        userManagedObject.setValue(data, forKey: "data")
        do {
            try context.save()
        } catch {
            print("Error while saving imageCache to Core Data:\n\(error)")
        }
    }
    
    private func clearCoreData() throws {
        let fetchRequest: NSFetchRequest<PictureCacheEntity> = PictureCacheEntity.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        try context.execute(batchDeleteRequest)
        try context.save()
    }
    
    private func loadCacheFromCoreData() {
        do {
            let fetchRequest = NSFetchRequest<PictureCacheEntity>(entityName: "PictureCacheEntity")
            
            let pictureCacheEntities = try context.fetch(fetchRequest)
            _ = pictureCacheEntities.map { pictureCacheEntity in
                let url = URL(string: pictureCacheEntity.value(forKey: "url") as! String)!
                let data = pictureCacheEntity.value(forKey: "data") as! Data
                imageCache.updateValue(data, forKey: url)
            }
        } catch {
            print("error loading cache from core data:\n\(error)")
        }
    }
    
    private func request(url: URL) -> URLRequest {
        let request = URLRequest(url: url)
        //MARK: customize http requust here
        //f e request.addValue("someValue", forHTTPHeaderField: "Authorization")
        return request
    }
}
