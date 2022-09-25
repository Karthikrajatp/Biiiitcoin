import Foundation
protocol CoinManagerDelegate{
    func didUpdatePrice(_ coinManger:CoinManager,currency:String,price:String)
    func didFailWithError(error:Error)
}
struct CoinManager {
    var delegate:CoinManagerDelegate?
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "5efba0a2-17e9-4fd4-85c9-3bdb43a937f3"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency:String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url){ (data, response, error) in
                if error != nil{
                    print(error!)
                    return
                }
                if let safeData = data{
                    if let bitcoinPrice = self.parseJSON(safeData){
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        self.delegate?.didUpdatePrice(self, currency: currency, price: priceString)
                        
                    }
                }
            }
            task.resume()
        }
    }
    func parseJSON(_ data: Data)->Double?{
        let decoder = JSONDecoder()
        do{
        let decodedData = try decoder.decode(CoinModel.self, from: data)
            let lastPrice = decodedData.rate
            return lastPrice
            
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
        }

    
    }

