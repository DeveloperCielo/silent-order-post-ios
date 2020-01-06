#
#  Be sure to run `pod spec lint CieloSilentOrderPost.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.name         = "CieloSilentOrderPost"
  spec.version      = "1.0.0"
  spec.summary      = "Cielo silent order post it's an easy way to validate credit card and get a valid token."

  spec.description  = <<-DESC
  O SDK Silent Order Post é uma integração que a Cielo oferece aos lojistas, onde os dados de pagamentos são trafegados de forma segura, mantendo o controle total sobre a experiência de checkout.
                   DESC

  spec.homepage     = "https://github.com/DeveloperCielo/silent-order-post-ios"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.license      = "MIT"

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.author       = { "Jeferson F. Nazario" => "jefnazario@gmail.com" }
  spec.social_media_url   = "http://twitter.com/jefnazario"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.source       = { :git => "https://github.com/DeveloperCielo/silent-order-post-ios.git", :tag => "#{spec.version}" }
  spec.ios.deployment_target = '10.0'


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.source_files  = "SilentOrderPost/*.swift"

end
