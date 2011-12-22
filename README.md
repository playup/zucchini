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

Add your device to features/support/config.yml.

The [udidetect](https://github.com/vaskas/udidetect) utility comes in handy if you plan to add devices from time to time: `udidetect -z`.

Start hacking by modifying features/my_feature/feature.zucchini and features/support/screens/welcome.coffee.

Alternatively, check out the [zucchini-demo](https://github.com/rajbeniwal/zucchini-demo) project featuring an easy to explore Zucchini setup around Apple's CoreDataBooks sample.

Running a feature on the device
--------------------------------
```
ZUCCHINI_DEVICE="My Device" zucchini run /path/to/my_feature 
```

See also
---------
```
zucchini --help  
zucchini run --help  
zucchini generate --help
```
