//
//  ImageSearcher.swift
//  QulixTest
//
//  Created by Alex on 8.12.23.
//

import Foundation

protocol ImageSearcher {
    func search(for query: String) async throws -> [ImageData]
    func getNext() async throws -> [ImageData]
    var isEnded: Bool? {get}
    init(step: Int)
}
