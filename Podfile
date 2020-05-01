# Uncomment the next line to define a global platform for your project
platform :ios, '11.4'

target 'Health' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Health
  #pod 'AWAREFramework', :git=>'https://github.com/tetujin/AWAREFramework-iOS.git'
  
  pod 'AWAREFramework', '~> 1.10'
  pod 'AWAREFramework/MotionActivity'
  pod 'AWAREFramework/Microphone'
  
  pod 'Charts'
  pod 'DynamicColor'
  pod 'ResearchKit', :git => 'https://github.com/ResearchKit/ResearchKit.git', :commit => '50a2b3427ac232c85f524b1ce63db8f3e1d501ef'
  target 'HealthTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'HealthUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
