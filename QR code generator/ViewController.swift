//
//  ViewController.swift
//  QR code generator
//
//  Created by Jaydeep on 23/07/20.
//  Copyright © 2020 Jaydeep. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController {

    @IBOutlet weak var txtData: UITextField!
    @IBOutlet weak var qrImage: UIImageView!
    @IBOutlet weak var btnSave: UIButton!
    var qrImg :CIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnSave.isEnabled = false
    }

    @IBAction func generateBtn(_ sender: UIButton) {
        qrImage.startAnimating()
        generateQR()
    }
    @IBAction func saveBtn(_ sender: UIButton) {
        guard let image = qrImage.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func generateQR(){
        if let str = txtData.text {
            let data = str.data(using: .ascii, allowLossyConversion: false)
            let filter = CIFilter(name: "CIQRCodeGenerator")
            filter?.setValue(data, forKey: "InputMessage")
            qrImg = filter?.outputImage
            let image = UIImage(ciImage: qrImg)
            qrImage.image = image
            UIView.animate(withDuration: 0.5, delay: 1, usingSpringWithDamping: 0.55, initialSpringVelocity: 3, options: .curveEaseOut, animations: {
                self.qrImage.transform = .identity
                self.qrImage.alpha = 1
            }, completion: nil)
            btnSave.isEnabled = true
        }
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}
