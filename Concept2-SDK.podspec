Pod::Spec.new do |s|
  s.name              = "Concept2-SDK"
  s.version           = "0.2.0"
  s.summary           = "Library for connecting to the Concept2 PM5 via Bluetooth."
  s.description       = <<-DESC
                         Library for connecting to the Concept2 PM5 via Bluetooth. The goal of this
                         library is to provide complete coverage of the bluetooth functionality.
                        DESC

  s.homepage          = "https://github.com/BoutFitness/Concept2-SDK"
  s.license           = 'MIT'
  s.author            = { "jessecurry" => "jesse@jessecurry.net" }
  s.source            = { :git => "https://github.com/BoutFitness/Concept2-SDK.git", :tag => s.version.to_s }
  s.social_media_url  = 'https://twitter.com/boutfitness'

  s.platforms         = { :ios => '10.0', :osx => '10.13', :tvos => '9.0' }
  s.requires_arc      = true

  s.source_files      = 'Pod/Classes/**/*'
  s.module_name       = 'Concept2_SDK'
  s.frameworks        = 'CoreBluetooth'
end
