//
//  ContentView.swift
//  Stripe-in-SwiftUI
//
//  Created by Muhammad Suleman on 4/26/23.
//

import SwiftUI
import Stripe

struct ContentView: View {
    
    @State private var cardNumber = "e"
    @State private var expMonth = "e"
    @State private var expYear = "e"
    @State private var cvc = "e"
    
    var body: some View {
        VStack {
            TextField("Card Number", text: $cardNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            HStack {
                TextField("MM", text: $expMonth)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: .infinity)
                TextField("YY", text: $expYear)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: .infinity)
                TextField("CVC", text: $cvc)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: .infinity)
            }
            Button(action: processPayment) {
                Text("Pay")
            }
        }
        .padding()
    }
    
    
    func processPayment() {
        let cardParams = STPCardParams()
        cardParams.number = self.cardNumber
        cardParams.expMonth = UInt(self.expMonth) ?? 0
        cardParams.expYear = UInt(self.expYear) ?? 0
        cardParams.cvc = self.cvc
        
        
        STPAPIClient.shared.createToken(withCard: cardParams) { token, error in
            if let error = error {
                // Handle error
                print("Error: \(error.localizedDescription)")
            } else if let token = token {
                // Use token to process payment
                
                let paymentMethodCardParams = STPPaymentMethodCardParams(cardSourceParams: cardParams)
                let paymentMethodParams = STPPaymentMethodParams(card: paymentMethodCardParams, billingDetails: nil, metadata: nil)
                
                STPAPIClient.shared.createPaymentMethod(with: paymentMethodParams) { paymentMethod, error in
                    if let error = error {
                        // Handle error
                        print("Error: \(error.localizedDescription)")
                    } else if paymentMethod != nil {
                        // Process payment using payment method
                        let paymentIntentParams = STPPaymentIntentParams(clientSecret: stripeTestSecretKey)
                        let paymentHandler = PaymentHandler()
                        STPPaymentHandler.shared().confirmPayment(paymentIntentParams, with: paymentHandler) { status, paymentIntent, error in
                            if let error = error {
                                // Handle error
                                print("Error: \(error.localizedDescription)")
                            } else {
                                // Handle payment result
                                switch status {
                                case .succeeded:
                                    // Payment succeeded
                                    print("Payment succeeded!")
                                case .failed:
                                    // Payment failed
                                    print("Payment failed")
                                case .canceled:
                                    // Payment canceled
                                    print("Payment canceled")
                                @unknown default:
                                    // Unknown status
                                    print("Unknown payment status")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class PaymentHandler: NSObject, STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        return UIApplication.shared.windows.first!.rootViewController!
    }
}
