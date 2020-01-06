//
//  SuccessResult.swift
//  SilentOrderPost
//
//  Created by Jeferson Nazario on 13/12/19.
//  Copyright © 2019 jnazario.com. All rights reserved.
//

public class SuccessResult: NSObject, Codable {
    public var paymentToken,
                brand,
                foreignCard,
                binQueryReturnCode,
                binQueryReturnMessage: String?
    
    init(paymentToken: String,
         brand: String,
         foreignCard: String,
         binQueryReturnCode: String,
         binQueryReturnMessage: String) {
        
        self.paymentToken = paymentToken
        self.brand = brand
        self.foreignCard = foreignCard
        self.binQueryReturnCode = binQueryReturnCode
        self.binQueryReturnMessage = binQueryReturnMessage
    }
}
