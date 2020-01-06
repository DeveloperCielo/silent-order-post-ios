//
//  SilentOrderPost.swift
//  SilentOrderPost
//
//  Created by Jeferson Nazario on 11/12/19.
//  Copyright © 2019 jnazario.com. All rights reserved.
//

public protocol SilentOrderPostProtocol: NSObject {
    func sendCardData(accessToken: String,
                      cardHolderName: String,
                      cardNumber: String,
                      cardExpirationDate: String,
                      cardCvv: String,
                      enableBinQuery: Bool,
                      onValidation: @escaping ([ValidationResults]) -> Void?,
                      onSuccess: @escaping (SuccessResult) -> Void,
                      onError: @escaping (ErrorResult) -> Void?)
}

public class SilentOrderPost: NSObject, SilentOrderPostProtocol {

    var language = "PT"
    var cvvvRequired = true
    var mod10required = true
    var provider = "cielo"

    var environment: Environment
    
    init(environment: Environment) {
        self.environment = environment
    }
    
    public static func createInstance(environment: Environment) -> SilentOrderPost {
        return SilentOrderPost(environment: environment)
    }
    
    public func sendCardData(accessToken: String,
                             cardHolderName: String,
                             cardNumber: String,
                             cardExpirationDate: String,
                             cardCvv: String,
                             enableBinQuery: Bool,
                             onValidation: @escaping ([ValidationResults]) -> Void?,
                             onSuccess: @escaping (SuccessResult) -> Void,
                             onError: @escaping (ErrorResult) -> Void?) {
        
        let validation = validate(cardHolderName: cardHolderName,
                                  cardNumber: cardNumber,
                                  cardExpirationDate: cardExpirationDate,
                                  cardCvv: cardCvv)
        
        if validation.count > 0 {
            onValidation(validation)
            return
        }
        
        RemoteDatasource.shared().silentOrder(environment: environment,
                                              accessToken: accessToken,
                                              cardHolderName: cardHolderName,
                                              cardNumber: cardNumber,
                                              cardExpiration: cardExpirationDate,
                                              cardSecurityCode: cardCvv,
                                              enableBinQuery: enableBinQuery,
                                              onValidation: onValidation,
                                              onSuccess: onSuccess,
                                              onError: onError)
    }
    
    private func validate(cardHolderName: String = "",
                          cardNumber: String = "",
                          cardExpirationDate: String = "",
                          cardCvv: String = "") -> [ValidationResults] {
        
        var validationErrors: [ValidationResults] = []
        
        if cardHolderName.isEmpty {
            validationErrors.append(ValidationResults(field: "HolderName", message: "Nome do portador é um campo obrigatório!"))
        }
        
        if cardNumber.isEmpty {
            validationErrors.append(ValidationResults(field: "RawNumber", message: "Número do cartão é um campo obrigatório!"))
        }
        
        if cardExpirationDate.isEmpty {
            validationErrors.append(ValidationResults(field: "Expiration", message: "Data de expiração do cartão é um campo obrigatório!"))
        }
        
        if cardCvv.isEmpty {
            validationErrors.append(ValidationResults(field: "SecurityCode", message: "CVV é um campo obrigatório!"))
        }
        
        return validationErrors
    }
}
