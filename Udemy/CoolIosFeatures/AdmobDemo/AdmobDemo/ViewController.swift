//
//  ViewController.swift
//  AdmobDemo
//
//  Created by Aliona on 30/01/2018.
//  Copyright © 2018 Aliona. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController, GADInterstitialDelegate {

    @IBOutlet weak var banner: GADBannerView!

    var interstitial: GADInterstitial!

    override func viewDidLoad() {
        super.viewDidLoad()

        // banner ad
        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        banner.rootViewController = self
        banner.load(GADRequest())

        // interstitial pop up ad
        setIntersticial()
    }

    private func setIntersticial() {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self
        interstitial.load(GADRequest())
    }

    @IBAction func showAds(_ sender: Any) {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
            setIntersticial()
        } else {
            print("Not yet, we'll show you the add later!")
        }
    }
}

