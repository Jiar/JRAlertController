Pod::Spec.new do |s|

  s.name = 'JRAlertController'
  s.version = '1.1.0'
  s.summary = 'Based on Apple\'s UIAlertController control API, rebuilt it with swift, JRAlertController is more in line with mainstream style of the APP.'

  s.homepage = 'https://github.com/Jiar/JRAlertController'
  s.license = { :type => "Apache-2.0", :file => "LICENSE" }

  s.author = { "Jiar" => "jiar.world@gmail.com" }

  s.ios.deployment_target = '8.0'

  s.source = { :git => "https://github.com/Jiar/JRAlertController.git", :tag => "#{s.version}" }
  s.source_files = 'Source/*.swift'

  s.module_name = 'JRAlertController'
  s.requires_arc = true

  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
  s.static_framework = true
  
end
