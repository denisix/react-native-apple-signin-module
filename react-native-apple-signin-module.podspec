require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-apple-signin-module"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  react-native-apple-signin-module
                   DESC
  s.homepage     = "https://github.com/denisix/react-native-apple-signin-module"
  s.license      = "MIT"
  # s.license    = { :type => "MIT", :file => "FILE_LICENSE" }
  s.authors      = { "Den" => "denisix@gmail.com" }
  s.platforms    = { :ios => "13.0" }
  s.source       = { :git => "https://github.com/denisix/react-native-apple-signin-module.git", :tag => "#{s.version}" }
  s.swift_version = '4.2'

  s.source_files = "ios/**/*.{h,m,swift}"
  s.requires_arc = true

  s.dependency "React"
end
