//
//  HTTPClient.swift
//  MoviesAppSwiftUICombineApp
//
//  Created by Justin Maronde on 9/10/24.
//

import Foundation
import Combine

enum NetworkError: Error {
    case badURL
}

class HTTPClient {
    
    func fetchMovies(search: String) -> AnyPublisher<[Movie], Error> {
        
        guard let encodedSearch = search.urlEncoded, let url = URL(string: "https://www.omdbapi.com/?s=\(encodedSearch)&page=2&apiKey=xxxxxx") else {
            return Fail(error: NetworkError.badURL).eraseToAnyPublisher()
        }
                
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .map(\.search)
            .breakpoint(receiveOutput: { movies in
                movies.isEmpty
            })
            .receive(on: DispatchQueue.main)
            .catch { error -> AnyPublisher<[Movie], Error> in
                return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        
    }
    
}
