import UIKit

class UserTypePickerDelegate: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    private let picker1Data = ["Create Room", "Join Room"]

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
  
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return picker1Data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return picker1Data[row]
    }
}
