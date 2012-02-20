Pre-requisites
--------------
 1. XCode 4.2
 2. A few command line tools:

```
brew update && brew install imagemagick && brew install coffee-script 
```

Start using Zucchini
----------------------
```
gem install zucchini-ios
```

Using Zucchini doesn't involve making any modifications to your application code.
You might as well keep your Zucchini tests in a separate project.

Start by creating a project scaffold:

```
zucchini generate --project /path/to/my_project
```

Create a feature scaffold for your first feature:  

```
zucchini generate --feature /path/to/my_project/features/my_feature
```

Start hacking by modifying features/my_feature/feature.zucchini and features/support/screens/welcome.coffee.

Alternatively, check out the [zucchini-demo](https://github.com/rajbeniwal/zucchini-demo) project featuring an easy to explore Zucchini setup around Apple's CoreDataBooks sample.


Xcode 4.2 and earlier
--------------------------------
With xcode 4.3 apple has moved the developer tools inside the xcode
application.

If you are using 4.2 or earlier then be sure to change the `template:` path in
`config.yml`


Running on the device
--------------------------------
Add your device to features/support/config.yml.

The [udidetect](https://github.com/vaskas/udidetect) utility comes in handy if you plan to add devices from time to time: `udidetect -z`.

```
ZUCCHINI_DEVICE="My Device" zucchini run /path/to/my_feature 
```

Running on the iOS Simulator
-------------------------------
We strongly encourage you to run your Zucchini features on real hardware. However, you can run them on the iOS Simulator if you must.

First off, modify your features/support/config.yml to include a full path to your compiled app, e.g.

```
app: /Users/vaskas/Library/Developer/Xcode/DerivedData/CoreDataBooks-ebeqiuqksrwwoscupvxuzjzrdfjz/Build/Products/Debug-iphonesimulator/CoreDataBooks.app
```

Secondly, add an 'iOS Simulator' entry to the devices section (no UDID needed) and make sure you provide the actual value for 'screen' based on your iOS Simulator settings:

```
devices:
  iOS Simulator:
    screen: low_ios5
```

Run it as usual:

```
ZUCCHINI_DEVICE="iOS Simulator" zucchini run /path/to/my_feature 
```

Using #include statements with coffescript
------------------------------------------
UIAutomation gives you the extra ability to include outside scripts in your
javascript using this syntax:

    #include 'relative/path/to/javascript.js'

The problem is that coffescript wants to turn this into a javascript comment.
The way around this is to use [embedded javascript](http://coffeescript.org/#embedded).
Just surround the statement with backticks and the coffescript compiler won't
mess with it.


    `#include "relative/path/to/javascript.js"`


See also
---------
```
zucchini --help  
zucchini run --help  
zucchini generate --help
```
