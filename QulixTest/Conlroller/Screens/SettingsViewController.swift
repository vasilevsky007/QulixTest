//
//  SettingsViewController.swift
//  QulixTest
//
//  Created by Alex on 10.12.23.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var imageFetcher: ImageFetcher?
    
    private func formatBytes(_ bytes: Int?) -> String? {
        if let bytes = bytes {
            let byteFormatter = ByteCountFormatter()
            byteFormatter.allowedUnits = [.useBytes, .useKB, .useMB, .useGB]
            byteFormatter.countStyle = .memory
            return byteFormatter.string(fromByteCount: Int64(bytes))
        } else {
            return nil
        }
    }
    
    @IBOutlet weak var cacheSize: UILabel!
    
    private func updateCacheSize() async {
        cacheSize.text = await formatBytes(imageFetcher?.cacheSize)
    }
    
    @IBAction func tappedClearCache(_ sender: UIButton) {
        Task.detached { [weak self] in
            await self?.imageFetcher?.clearCache()
            await self?.updateCacheSize()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Task {
            await updateCacheSize()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
