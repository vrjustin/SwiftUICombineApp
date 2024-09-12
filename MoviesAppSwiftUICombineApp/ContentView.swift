//
//  ContentView.swift
//  MoviesAppSwiftUICombineApp
//
//  Created by Justin Maronde on 9/10/24.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @State private var movies: [Movie] = []
    @State private var search: String = ""
    
    private let httpClient: HTTPClient
    
    @State private var cancellables: Set<AnyCancellable> = []
    private var searchSubject = CurrentValueSubject<String, Never>("")
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    private func setupSearchPublisher() {
        searchSubject
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { searchText in
                loadMovies(search: searchText)
            }.store(in: &cancellables)
    }
    
    private func loadMovies(search: String) {
        httpClient.fetchMovies(search: search)
            .sink { _ in
                
            } receiveValue: { movies in
                self.movies = movies
            }.store(in: &cancellables)

    }
    
    var body: some View {
        NavigationStack {
            List(movies) { movie in
                HStack {
                    AsyncImage(url: movie.poster) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 75, height: 75)
                    } placeholder: {
                        ProgressView()
                    }
                    Text(movie.title)
                }
            }
            .onAppear {
                print("hello onAppear")
                setupSearchPublisher()
            }
            .searchable(text: $search)
            .onChange(of: search) {
                searchSubject.send(search)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ContentView(httpClient: HTTPClient())
    }
}
