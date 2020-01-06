//
//  ValidationResults.swift
//  SilentOrderPost
//
//  Created by Jeferson Nazario on 13/12/19.
//  Copyright © 2019 jnazario.com. All rights reserved.
//

public class ValidationResults: NSObject, Codable {
    public var field, message: String
    
    @objc init(field: String, message: String) {
        self.field = field
        self.message = message
    }
}
