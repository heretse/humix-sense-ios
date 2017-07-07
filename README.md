# Overview
`Humix` is an open source robot connectivity and design framework that make it easy to
bridge cloud API with hardware sensors and devices. Combining with Watson APIs,
the framework help everyone to build their own cloud-brained robot with a few minimal steps.

Humix leverages NodeRed as the flow-editor for designing how the robot behaves. On top of NodeRed,
a few new nodes are added to support Humix’s module programming model, and make it relatively easy for
the cloud brain to interact with modules deployed on the robot.

Before you start configuring your Humix Sense, make sure you have a `Humix Think` instance running (local or on bluemix). Steps [Here](https://github.com/project-humix/humix-think)

This project is a standalone `Humix Sense` running on iOS platform version.

# Get Started
## Install some necessary packages by `CocoaPods`

CocoaPods is a dependency manager for Swift and Objective-C Cocoa projects. Make sure you have installed CocoaPods and how to install instruction is [Here](https://cocoapods.org/)

```
pod install
```

