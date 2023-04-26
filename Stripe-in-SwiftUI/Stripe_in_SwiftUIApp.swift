//
//  Stripe_in_SwiftUIApp.swift
//  Stripe-in-SwiftUI
//
//  Created by Muhammad Suleman on 4/26/23.
//

import SwiftUI
import Stripe

@main
struct Stripe_in_SwiftUIApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            CheckoutView()
        }
    }
}

// MARK: AppDelegate
class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Stripe defaultPublishableKey key configure
        StripeAPI.defaultPublishableKey = stripeTestPublishableKey
    
        return true
    }
}

// Stripe keys...
let stripeTestPublishableKey: String = "pk_test_51N122FFzoU88ZKDiGOq2X2UZZdFY98YoirN1HmF7j2OBYoWm3slUtzkaTU7vI4gSIAbjnZA06EPCV68NrsOENDjo00GmtniVK9"
let stripeTestSecretKey = "sk_test_51N122FFzoU88ZKDizEvBnwxLVNn7EZ7UvU1jgxBAWaec0i7LTM8jdDAwMJxxyQNxaCwUhITHFFSKa6D9DkKDziwb007Dkt1p3M"
