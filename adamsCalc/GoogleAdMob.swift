//
//  GoogleAdMob.swift
//  adamsCalc
//
//  Created by Adam Reed on 6/24/21.
//

import SwiftUI
import GoogleMobileAds
import UIKit

final private class BannerVC: UIViewControllerRepresentable  {
    
    
    var testBannerAdId = "ca-app-pub-3940256099942544/2934735716"
    var realBannerAdId = "ca-app-pub-4186253562269967/3971400494"

    func makeUIViewController(context: Context) -> UIViewController {
        let view = GADBannerView(adSize: kGADAdSizeBanner)

        let viewController = UIViewController()
        view.adUnitID = realBannerAdId
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: kGADAdSizeBanner.size)
        view.load(GADRequest())

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct Banner:View{
    var body: some View{
        HStack(alignment: .center) {
            Spacer()
            BannerVC().frame(width: 320, height: 100, alignment: .center)
            Spacer()
        }
    }
}

struct Banner_Previews: PreviewProvider {
    static var previews: some View {
        Banner()
    }
}
