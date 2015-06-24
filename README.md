# SwiftViewCommand
An easy way of presenting view controllers in different storyboards

Storyboards present a convenient and easy way of designing view controllers, but they have their caveats also.
As an app grows in complexity and requires more views, it becomes increasingly difficult to hold them all in a single storyboard. Moreover, if a team is working on an app the storyboard becomes a source of problems since most will have to modify it and it's not always easy to merge changes.

You can split all views into their own Storyboard, but then you'd probably be better by using XIB files and you loose Segues.
You can also get to a compromise and split the views in several storyboards, grouped by functionality. This is probably a good approach since it will lessen the problems of team work, reduce compile time, and still be able to use Segues for simple transitions.

However, in this scenario you need to supply other means to move from a controller to another one in a different storyboard, since you can't use segues there.

There comes ViewCommand to help you. With ViewCommand you have just to define a ViewCommands.plist file in your project, which will contain a dictionary of elements with the key being a name of your choosing for the command, and the contents another dictionary with a storyboard name and view name.

Then you just instantiate the ViewCommand and push it.

This has the advantage of decoupling your code with the actual location of a concrete view in a given storyboard, as well as reduce duplicate code. It also makes it a bit easier to pass parameters to the target view controller, since it's not a decoupled action but a single one, thus grouping setting the parameters with actually showing the view controller.

An example without passing parameters:

```swift
    if let command = ViewCommand(name: "test2") {
      command.push( self )
    }
```

An example using parameters:

```swift
    if let command = ViewCommand(name: "test2"), let myController = command.viewController as? MyViewController {
      myController.parameter = "Hi!"
      command.push( self )
    }
```

ViewCommand is compatible with iOS 7 and iOS 8.0+.
