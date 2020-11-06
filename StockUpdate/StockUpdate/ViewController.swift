//
//  ViewController.swift
//  StockUpdate
//
//  Created by Ashish Ashish on 10/1/20.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class ViewController: UIViewController {
    
    let apiKey = "6ea500b4e10d8296e43253603aa9666e"
    let apiURL = "https://financialmodelingprep.com/api/v3/profile/"

    @IBOutlet weak var companyText: UITextField!
    
    @IBOutlet weak var ceoText: UILabel!
        
    @IBOutlet weak var priceText: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reset()
    }
    
    @IBAction func getValue(_ sender: Any) {
        guard let companyText = companyText.text else { return }
        
        let url = getURL(companyText: companyText)
        
        AF.request(url).responseJSON{(response) in
            guard let stocks: [JSON] = JSON(response.data).array else { return }
            
            if stocks.count < 1 {
                self.ceoText.text = nil
                self.priceText.text = nil
            }else{
                let ceo = stocks[0]["ceo"].rawString()
                let price = stocks[0]["price"].double ?? -1
                self.ceoText.text = ceo
                self.priceText.text = String(price)
            }
        }
    }
    
    func reset() {
           self.ceoText.text = ""
           self.priceText.text = ""
       }
       
    func getURL(companyText: String) -> String {
           return "\(apiURL)\(companyText)?apikey=\(apiKey)"
       }
}

