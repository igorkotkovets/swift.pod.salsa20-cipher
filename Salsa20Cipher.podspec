#
# Be sure to run `pod lib lint Salsa20Cipher.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Salsa20Cipher'
  s.version          = '0.8.0'
  s.summary          = 'Salsa20 cipher library written on Swift language.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Salsa20 is a stream cipher submitted to eSTREAM by Daniel J. Bernstein.
It is built on a pseudorandom function based on add-rotate-xor operations.
Specification is available at https://cr.yp.to/snuffle/spec.pdf

                       DESC

  s.homepage         = 'https://github.com/Igor Kotkovets/swift.pod.salsa20-cipher'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Igor Kotkovets' => 'igorkotkovets@users.noreply.github.com' }
  s.source           = { :git => 'https://github.com/Igor Kotkovets/swift.pod.salsa20-cipher.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'Salsa20Cipher/Classes/**/*.swift'
  s.preserve_paths = 'Sources/CommonCrypto/module.modulemap'
  s.xcconfig = { 'SWIFT_INCLUDE_PATHS' => '$(PODS_ROOT)/../../Salsa20Cipher/Classes/CommonCrypto' }
end
