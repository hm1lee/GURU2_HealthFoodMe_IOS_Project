import UIKit
import NaturalLanguage

class FoodViewController: UIViewController {

    @IBOutlet weak var mesageTextView: UITextView?
    @IBOutlet weak var spamLabel: UILabel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swipeRecongnizer()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }

    func swipeRecongnizer() {
        let swipRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
        swipRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipRight)
    }
    
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer){
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                self.dismiss(animated: true, completion: nil)
            default:
                break
            }
        }
    }
    
    @IBAction func sendMessage(sender: UIButton) {
        guard let message = self.mesageTextView?.text else {
            return
        }
        
        detectSpam(message: message)

    }

    private func detectSpam(message: String) {
        do {
            let spamDetector = try NLModel(mlModel: SPAMClassifier().model)
            guard let prediction = spamDetector.predictedLabel(for: message) else {
                print("Failed to predict result")
                return
            }
            
            spamLabel?.text = "\(prediction)"
            spamLabel!.numberOfLines = 0
            
        } catch {
            fatalError("Failed to load Natural Language Model: \(error)")
        }
    }
    
  
}
