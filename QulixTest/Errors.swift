//
//  Errors.swift
//  QulixTest
//
//  Created by Alex on 8.12.23.
//

import Foundation

enum QulixTestError: Error {
    case badUrlComponents
    case noTotalCountOnInitialRequest
    case noIsEndedFlagOnPagination
    case noImageFetcherToFetchImage
}

extension QulixTestError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .badUrlComponents:
            return NSLocalizedString("There is a problem with a URL components, such as an invalid characters.", comment: "Bad URL Components")
        case .noTotalCountOnInitialRequest:
            return NSLocalizedString("There is a problem with first server response, it didn't included total count of resullts", comment: "No total count of results on initial request")
        case .noIsEndedFlagOnPagination:
            return NSLocalizedString("nil isEnded flag on pagination. looks like you're trying to use pagination before initial request.", comment: "nil isEnded flag on pagination")
        case .noImageFetcherToFetchImage:
            return NSLocalizedString("no image fetcher to fetch image, so we can't fetch images", comment: "no image fetcher to fetch image")
        }
    }
}
