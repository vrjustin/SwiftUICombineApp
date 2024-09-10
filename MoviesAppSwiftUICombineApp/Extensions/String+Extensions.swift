//
//  String+Extensions.swift
//  MoviesAppSwiftUICombineApp
//
//  Created by Justin Maronde on 9/10/24.
//

import Foundation

extension String {
    
    var urlEncoded: String? {
        return addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
}
