//
//  ImagenViewController.swift
//  Snapchat
//
//  Created by Mac Tecsup on 16/05/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit
import Firebase

class ImagenViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var chooseContactButton: UIButton!
    
    var imagePicker = UIImagePickerController()
    var imagenID = NSUUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        chooseContactButton.isEnabled = false

        // Do any additional setup after loading the view.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        chooseContactButton.isEnabled = true
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        //imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func chooseContactTapped(_ sender: Any) {
        //performSegue(withIdentifier: "chooseContactSegue", sender: nil)
        chooseContactButton.isEnabled = false
        let imagenesFolder = Storage.storage().reference().child("imagenes")
        let imagenData = UIImagePNGRepresentation(imageView.image!)!
        let imagenURL = "\(imagenID).jpg"
        
        imagenesFolder.child(imagenURL).putData(imagenData, metadata: nil, completion: {(metadata, error) in
            print("Intentando subir la imagen ...")
            if error != nil {
                print("Ocurrió un error:\(String(describing: error))")
            }else{
                print("Imagen subida correctamente")
                let imagenRoute = imagenesFolder.child(imagenURL)
                imagenRoute.downloadURL(completion: {(url, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    if url != nil {
                        self.performSegue(withIdentifier: "chooseContactSegue", sender: url!.absoluteString)
                    }
                })
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! ChooseUserViewController
        siguienteVC.imagenURL = sender as! String
        siguienteVC.descrip = descriptionTextField.text!
        siguienteVC.imagenID = imagenID
    }
}









