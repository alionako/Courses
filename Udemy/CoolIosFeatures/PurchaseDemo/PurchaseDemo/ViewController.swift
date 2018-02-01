//
//  ViewController.swift
//  PurchaseDemo
//
//  Created by Aliona on 01/02/2018.
//  Copyright © 2018 Aliona. All rights reserved.
//

import UIKit
import StoreKit

class ViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {

    var product: SKProduct?

    override func viewDidLoad() {
        super.viewDidLoad()

        SKPaymentQueue.default().add(self)
        let productIds: Set<String> = ["Gold"]
        let request = SKProductsRequest(productIdentifiers: productIds)
        request.delegate = self
        request.start()
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print(response.products)
        product = response.products.last
    }

    func buy() {
        guard let product = product else {
            return
        }
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach {
            switch $0.transactionState {
            case .purchased:
                SKPaymentQueue.default().finishTransaction($0)
                print("Purchased")
            case .failed:
                SKPaymentQueue.default().finishTransaction($0)
                print("Something went wrong")
            default:
                break
            }
        }

    }
}

