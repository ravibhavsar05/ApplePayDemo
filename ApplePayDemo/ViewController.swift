
import UIKit
import PassKit
import Stripe
class ViewController: UIViewController {

    @IBOutlet weak var aca: PKAddPassButton!
    @IBOutlet weak var btnPay: PKPaymentButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        STPPaymentConfiguration.shared().appleMerchantIdentifier = "YOUR_MERCHANT_KEY_HERE"
    }
    
    @IBAction func btnPay(_ sender: Any) {
        let payRequest = Stripe.paymentRequest(withMerchantIdentifier: STPPaymentConfiguration.shared().appleMerchantIdentifier!, country: "US", currency: "USD")
        payRequest.paymentSummaryItems = [PKPaymentSummaryItem(label: "Fancy Hat", amount: NSDecimalNumber(string: "50.0"))]
        
        if Stripe.canSubmitPaymentRequest(payRequest) {
            let authVC = PKPaymentAuthorizationViewController(paymentRequest: payRequest)
            authVC?.delegate = self
            self.present(authVC!, animated: true, completion: nil)
        } else {
            print("Apple Pay is not configured")
        }
    }
    
    
}
extension ViewController:
PKPaymentAuthorizationViewControllerDelegate{
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
    
}
