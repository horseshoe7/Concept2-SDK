Pod::Spec.new do |s|
  s.name              = "Concept2-PM5"
  s.version           = "0.3.0"
  s.summary           = "Library for connecting to the Concept2 PM5 via Bluetooth."
  s.description       = <<-DESC
                         Library for connecting to the Concept2 PM5 via Bluetooth. The goal of this
                         library is to provide complete coverage of the bluetooth functionality.
                        DESC

  s.homepage          = "https://github.com/horseshoe7/Concept2-SDK"
  s.license           = 'MIT'
  s.author            = { "jessecurry" => "jesse@jessecurry.net" }
  s.source            = { :git => "https://github.com/horseshoe7/Concept2-SDK.git", :tag => s.version.to_s }
  s.social_media_url  = 'https://twitter.com/horseshoe7'

  s.platforms         = { :ios => '11.0', :osx => '10.13', :tvos => '9.0' }
  s.requires_arc      = true

  s.source_files      = 'Concept2-PM5/Concept2-PM5/Source/**/*'
  s.module_name       = 'Concept2_PM5'
  s.frameworks        = 'CoreBluetooth'
  s.dependency 'XCGLogger', '~> 7.0.0'
end
