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
}
