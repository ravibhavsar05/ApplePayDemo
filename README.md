# ApplePayDemo

 ## Requirements

- iOS 11.0+
- Xcode 10.1+
- Swift 4.2+

## Installation

### CocoaPods

Install Stripe in your project's `Podfile`:

```ruby
pod 'Stripe'
```

Certificates
----------------------------------------------------
- Manage the publishable key & certificate from [stripe account](https://dashboard.stripe.com/account/apple_pay)

- Add `merchant Id` in [Apple Developer account](https://developer.apple.com/)

Usage
----------------------------------------------------
  1. You can add your publishable key of stripe in `AppDelegate.swift` like below :

    STPPaymentConfiguration.shared().publishableKey = "YOUR_PUBLISHABLE_KEY_OF_STRIPE"
    
  2. Make sure you have enabled the `Apple Pay` option in `Capabilities` :

  3. Add the delegate methods of `PKPaymentAuthorizationViewControllerDelegate`


    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
         controller.dismiss(animated: true, completion: nil)
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        STPAPIClient.shared().createToken(with: payment) { (token, error) in
            if error == nil {
                print("Stripe Token Here => =>",token?.tokenId as Any)
                completion(PKPaymentAuthorizationResult.init(status: .success, errors: nil))
            } else {
                print("Error Here => => ",error?.localizedDescription as Any)
                completion(PKPaymentAuthorizationResult.init(status: .failure, errors: [error!]))
            }
        }
    }
    
  4. And add the code for `paymentRequest`

    let payRequest = Stripe.paymentRequest(withMerchantIdentifier: STPPaymentConfiguration.shared().appleMerchantIdentifier!, country: "US", currency: "USD")
        payRequest.paymentSummaryItems = [PKPaymentSummaryItem(label: "Fancy Hat", amount: NSDecimalNumber(string: "50.0"))]
        
        if Stripe.canSubmitPaymentRequest(payRequest) {
            let authVC = PKPaymentAuthorizationViewController(paymentRequest: payRequest)
            authVC?.delegate = self
            self.present(authVC!, animated: true, completion: nil)
        } else {
            print("Apple Pay is not configured")
        }

Output
----------------------------------------------------

![ApplePayDemo - Animated gif demo](ApplePayDemo/ApplePay.gif)

