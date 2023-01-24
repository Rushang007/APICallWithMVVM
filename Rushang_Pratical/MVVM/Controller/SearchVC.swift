//
//  SearchVC.swift


import UIKit

class SearchVC: UIViewController {

    @IBOutlet weak var txtSearch: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search"
    }
    
    @IBAction func pressOnSearch(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if (self.txtSearch.text ?? "").isBlankOrEmpty() {
            showAlertMessage(titleStr: "Input Error", messageStr: ValidationMessages.ImageInput)
            return
        }
        if !InternetConnectionManager.isConnectedToNetwork()  {
            self.showAlertMessage(titleStr: "Connection Error", messageStr: ValidationMessages.NoInternetConnection)
            return
        }
        let gallaryVC = StoryboardsName.main.instantiateViewController(withIdentifier: "GallaryVC") as! GallaryVC
        gallaryVC.searchText = self.txtSearch.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.navigationController?.pushViewController(gallaryVC, animated: true)
    }
    
}


extension SearchVC:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
