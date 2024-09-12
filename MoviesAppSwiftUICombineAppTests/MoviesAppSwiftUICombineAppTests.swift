//
//  MoviesAppSwiftUICombineAppTests.swift
//  MoviesAppSwiftUICombineAppTests
//
//  Created by Justin Maronde on 9/12/24.
//

import Testing
import XCTest
import Combine

final class MoviesAppSwiftUICombineAppTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable> = []

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        // this seems to be the new way to write the tests, no longer requiring to name
        // it with test...something, but instead uses the @Test decorator?
    }
    
    func testFetchMovies() throws {
        
        let httpClient = HTTPClient()
        
        let expectation = XCTestExpectation(description: "Received movies")
        
        httpClient.fetchMovies(search: "Batman")
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Request Failed with error: \(error)")
                }
            } receiveValue: { movies in
                XCTAssert(movies.count > 0)
                expectation.fulfill()
            }.store(in: &cancellables)

        wait(for: [expectation], timeout: 5.0)
    }

}
