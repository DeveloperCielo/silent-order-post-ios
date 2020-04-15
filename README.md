# Silent Order Post SDK iOS

## Introdução

O SDK **Silent Order Post** é uma integração que a **Cielo** oferece aos lojistas, onde os dados de pagamentos são trafegados de forma segura, mantendo o controle total sobre a experiência de checkout.

Esse método possibilita o envio dos dados do pagamento do seu cliente de forma segura, diretamente em nosso sistema. Os dados de pagamento, tais como número do cartão e data de validade são armazenados no ambiente da **Cielo**, que conta com a certificação PCI DSS 3.2.

## Características

- Captura de dados de pagamento diretamente para os sistemas da Cielo por meio dos campos definidos no seu checkout através dop SDK.
- Compatibilidade com todos os meios de pagamentos disponibilizados no Gateway Pagador (Nacional e Internacional)
- Redução do escopo de PCI DSS
- Mantenha controle total sobre a experiência de checkout mantendo o look & feel de sua marca


## Integração

### 1. Obtendo o AccessToken

Para usar o SDK, é necessário que o estabelecimento gere o AccessToken a partir da API de autenticação da Cielo (oAuth).

Isso é feito através de uma solicitação **POST** para o seguinte *endpoint*:

```https://transactionsandbox.pagador.com.br/post/api/public/v1/accesstoken?merchantid={mid}```

No lugar do ```{mid}``` deve-se preencher o **MerchantID** de sua loja na plataforma *Pagador da Cielo*.

Exemplo:

 ```https://transactionsandbox.pagador.com.br/post/api/public/v1/accesstoken?merchantid=00000000-0000-0000-0000-000000000000```

#### Requisição

    POST /v1/accesstoken?merchantid={mid}

| Propriedade |	Descrição |	Tipo | Tamanho | Obrigatório |
|-------------|-----------|------|---------|------------|
| mid |	Identificador da loja no Pagador |	Guid |	36 	| Sim |


#### Resposta
 
Como resposta, o estabelecimento receberá um json (HTTP 201 Created) contendo, entre outras informações, o ticket (AccessToken)

 
| Propriedade |	Descrição |	Tipo | Tamanho |	Formato |
|-------------|-----------|------|---------|------------|
| MerchantId |	Identificador da loja no Pagador |	Guid |	36 	|xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx |
| AccessToken | 	Token de Acesso. Por questões de segurança, este ticket dará permissão para o estabelecimento salvar apenas 1 cartão dentro de um prazo de já estipulado na resposta, através do atributo ExpiresIn (por padrão, 20 minutos). O que acontecer primeiro invalidará esse mesmo ticket para um uso futuro. | Texto | – | 	NjBhMjY1ODktNDk3YS00NGJkLWI5YTQtYmNmNTYxYzhlNjdiLTQwMzgxMjAzMQ== |  
| Issued | Data e hora da geração | Texto | –  | AAAA-MM-DDTHH:MM:SS | 
| ExpiresIn | Data e hora da expiração	| Texto | - |AAAA-MM-DDTHH:MM:SS |


    Por questões de segurança, será requerido obrigatoriamente o cadastro de um IP válido do estabelecimento na Cielo. Caso contrário a requisição não será autorizada (HTTP 401 NotAuthorized). Por favor, identifique qual será o IP de saída que acessará a API e na sequência solicitar o cadastro do mesmo através do canal de atendimento Cielo
    
### 2. Usando o SDK e enviando dados do cartão

Uma vez que já tenha sido obtido o ***AccessToken***, é necessário instanciar o SDK e enviar os dados do cartão.

Para utilizar o SDK, é necessário incluir a biblioteca ***SilentOrderPost.framework*** no seu projeto.


#### 2.1 Instalação

[CocoaPods](https://cocoapods.org) é um gerenciador de depêndencias para projetos do Xcode. Para saber mais sobre seu uso e instalação, visite o site oficial. 

Para utilizar o Silent Order Post SDK no seu projeto usando CocoaPods, adicione no `Podfile` do seu projeto o seguinte código:

```ruby
pod 'CieloSilentOrderPost'
```

Após adicionar o Silent Order Post no `Podfile`, basta abrir o terminal na pasta do seu projeto e executar o comando: `pod install`.

Feito isso, podemos proseguir com um exemplo de utilização.

### 3. Como usar

3.1 Importação

```swift
import SilentOrderPost
```

3.2 - Instanciando o sdk

```swift
private var sdk: SilentOrderPostProtocol!

override func viewDidLoad() {
    super.viewDidLoad()
    
    sdk = SilentOrderPost.createInstance(environment: .production)
}
```

É necessário informar o ambiente que deseja utilizar - sandbox (desenvolvimento) ou produção.

| Ambiente | Enum |	
|-------------|-----------|
| Sandbox (dev) | Environment.sandbox |
| Produção | Environment.production |


2.3 - Informando o AccessToken

De posse do ***AccessToken***, é hora do envio de dados do cartão. Para enviar os dados do cartão, usa-se o método ```sendCardData```.

```
sdk.sendCardData(
    accessToken: accessToken
    cardHolderName: "Cliente Cielo",
    cardNumber: "4000000000001091",
    cardExpirationDate: "10/2029",
    cardCvv: "621",
    enableBinQuery: true
    onValidation: { (results) -> Void? in 
        // tratar o retorno da validação aqui
    },
    onSuccess: { (result) in 
        // manipular o paymentToken recebido aqui
    },
    onEror: { (error) -> Void? in
        // manipular o erro aqui
    }
)
```

> Obs.: Você pode também habilitar o binQuery (por default é ***false***).

2.4 - Envio de dados do cartão

| Propriedade | Descrição |	
|-------------|-----------|
| cardHolderName | Nome do portador do cartão de crédito |
| cardNumber | Número do cartão de crédito/débito  |
| cardExpirationDate | Data de Validade do cartão de crédito/débito (DD/YYYY) |
| cardCvv | Código de Segurança do cartão de crédito/débito |
| onError | Callback para tratamento de caso de erro. Será retornado o código e a descrição do erro |
| onSuccess | Callback utilizado em caso de sucesso. Será retornado o PaymentToken, e também os dados do cartão caso tenha solicitado realizar a verificação do cartão. Por questões de segurança esse PaymentToken poderá ser usado apenas para uma autorização. Após o processamento do mesmo, este será invalidado. |
| onValidation | Callback utilizado para validação (dados incorretos). Serão retornados detalhes de campos com erro. |

2.5 - Detalhamento dos retornos nos callbacks

```onValidation```

```
public class ValidationResults: NSObject, Codable {
    public var field, message: String
    
    @objc init(field: String, message: String) {
        self.field = field
        self.message = message
    }
}
```

Caso ocorra, neste callback será retornada uma lista com objetos do tipo ```ValidationResults```.


```onError```

```
public class ErrorResult: NSObject, Codable {
    public var errorCode, errorMessage: String
    
    init(errorCode: String, errorMessage: String) {
        self.errorCode = errorCode
        self.errorMessage = errorMessage
    }
}
```

Caso ocorra, neste callback será retornado um objeto do tipo ```ErrorResult```.

```onSuccess```

```
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
```

Caso ocorra, neste callback será retornado um objeto do tipo ```SuccessResult```.
