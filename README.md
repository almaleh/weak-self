# weak-self
This app demonstrates when [weak self] is needed in Swift to avoid strong reference cycles, and when it is not needed. 

The app accompanies an article on this topic that is [available here](https://medium.com/@almalehdev/you-dont-always-need-weak-self-a778bec505ef). 

## Using the app

Once you clone the app from Github and open it in Xcode, navigate to PresentedController.swift to find a list of leak scenarios. 

In viewDidLoad, there is a call to `setup(scenario: .leakyButton)`. Try calling different scenarios by changing the enum case, then run the app with each scenario to observe the memory situation. 

Once you run the app (on the simulator or a real device), try presenting a controller then dismissing it. You will get an alert after the dismissal telling you whether the controller has leaked (depending on the scenario you chose). 

Each scenario is preceded by comments that explain what's happening and why it may or may not cause a memory leak. 

The presented controller generates expensive images with Core Image filters. During leak scenarios, notice how presenting the controller multiple times in succession will keep incrementing your app memory usage. 
