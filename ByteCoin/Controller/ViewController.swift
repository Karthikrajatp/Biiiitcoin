import UIKit
class ViewController: UIViewController{
    
    var coinManager = CoinManager()
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource=self
        currencyPicker.delegate=self
        coinManager.delegate=self
    }
}
//MARK: - UIPickerViewDataSource
    extension ViewController:UIPickerViewDataSource,UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let name=coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: name)
    }
    
    }
    

//MARK: - CoinManagerDelegate
extension ViewController:CoinManagerDelegate{
    func didFailWithError(error: Error) {
        print(error)
    }
    func didUpdatePrice(_ coinManger: CoinManager, currency: String, price: String) {
        DispatchQueue.main.async{
            self.bitcoinLabel.text = price
            self.currencyLabel.text  = currency
        }
    }
}
