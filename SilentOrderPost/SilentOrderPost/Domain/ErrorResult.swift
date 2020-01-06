//
//  ErrorResult.swift
//  SilentOrderPost
//
//  Created by Jeferson Nazario on 13/12/19.
//  Copyright © 2019 jnazario.com. All rights reserved.
//

public class ErrorResult: NSObject, Codable {
    public var errorCode, errorMessage: String
    
    init(errorCode: String, errorMessage: String) {
        self.errorCode = errorCode
        self.errorMessage = errorMessage
    }
}
