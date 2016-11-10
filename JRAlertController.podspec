Pod::Spec.new do |s|
  s.name = 'JRAlertController'
  s.version = '1.0.0'
  s.summary = '基于apple的UIAlertController控件api，用swift重新打造的UI控件，更符合主流app的风格。'
  s.homepage = 'https://github.com/Jiar/JRAlertController'
  s.license = { :type => "Apache-2.0", :file => "LICENSE" }
  s.author = { "Jiar" => "jiar.world@gmail.com" }
  s.ios.deployment_target = '8.0'
  s.source = { :git => "https://github.com/Jiar/JRAlertController.git", :tag => "#{s.version}" }
  s.source_files = 'Source/*.swift'
  s.module_name = 'JRAlertController'
end
