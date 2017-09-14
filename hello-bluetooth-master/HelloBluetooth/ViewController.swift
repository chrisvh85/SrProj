import UIKit

class ViewController: UIViewController {
    var simpleBluetoothIO: SimpleBluetoothIO!

    @IBOutlet weak var ledToggleButton: UIButton!
    @IBOutlet weak var rightToggleButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        simpleBluetoothIO = SimpleBluetoothIO(serviceUUID: "19B10010-E8F2-537E-4F6C-D104768A1214", delegate: self)
    }

    @IBAction func ledToggleButtonDown(_ sender: UIButton) {
        simpleBluetoothIO.writeValue(value: 1)
    }

    @IBAction func ledToggleButtonUp(_ sender: UIButton) {
        simpleBluetoothIO.writeValue(value: 0)
    }
    @IBAction func rightToggleButtonDown(_ sender: UIButton) {
        simpleBluetoothIO.writeValue(value: 2)
        
    }
    
    @IBAction func leftToggleButtonUp(_ sender: UIButton) {
        simpleBluetoothIO.writeValue(value: 0)
    }

    func createAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: SimpleBluetoothIODelegate {
    func simpleBluetoothIO(simpleBluetoothIO: SimpleBluetoothIO, didReceiveValue value: Int8) {
        if value > 0 {
            view.backgroundColor = UIColor.red
            createAlert(title: "Shock Detected", message: "Send for Help?")
        } else {
            view.backgroundColor = UIColor.black
        }
    }
}
