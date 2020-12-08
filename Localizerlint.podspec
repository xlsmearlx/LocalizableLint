#
# Be sure to run `pod lib lint Localizerlint.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name                      = 'Localizerlint'
  s.version                   = '0.1.0'
  s.summary                   = 'Command line tool helps in the search for unused and duplicated localization strings in Xcode projects'
  s.homepage                  = 'https://github.com/xlsmearlx/LocalizableLint'
  s.license                   = { :type => 'MIT', :file => 'LICENSE' }
  s.author                    = { 'Samuel Lagunes' => 'xlsmearlx@gmail.com' }
  s.source                    = { http: "#{s.homepage}/releases/download/#{s.version}/localizerlint.zip" }
  s.preserve_paths            = '*'
  s.preserve_paths            = '*'
  s.exclude_files             = '**/file.zip'
  s.ios.deployment_target     = '9.0'
end
