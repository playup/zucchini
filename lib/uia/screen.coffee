class Screen
  constructor: (@name) ->
    if @anchor then target.waitForElement @anchor()

  elements: {}
  actions :
    'Take a screenshot$' : ->
      target.captureScreenWithName(@name)

    'Take a screenshot named "([^"]*)"$' : (name) ->
      target.captureScreenWithName(name)

    'Tap "([^"]*)"$' : (element) ->
      raise "Element '#{element}' not defined for the screen '#{@name}'" unless @elements[element]
      @elements[element]().tap()

    'Confirm "([^"]*)"$' : (element) ->
      @actions['Tap "([^"]*)"$'].bind(this)(element)

    'Wait for "([^"]*)" second[s]*$' : (seconds) ->
      target.delay(seconds)

    'Type "([^"]*)" in the "([^"]*)" field$': (text,element) ->
      raise "Element '#{element}' not defined for the screen '#{@name}'" unless @elements[element]
      @elements[element]().tap()
      app.keyboard().typeString text

    'Clear the "([^"]*)" field$': (element) ->
      raise "Element '#{element}' not defined for the screen '#{@name}'" unless @elements[element]
      @elements[element]().setValue ""

    'Cancel the alert' : ->
      alert = app.alert()
      raise "No alert found to dismiss on screen '#{@name}'" if isNullElement alert
      alert.cancelButton().tap()

    'Confirm the alert' : ->
      alert = app.alert()
      raise "No alert found to dismiss on screen '#{@name}'" if isNullElement alert
      alert.defaultButton().tap()

    'Select the date "([^"]*)"$' : (dateString) ->
      datePicker = view.pickers()[0]
      raise "No date picker available to enter the date #{dateString}" unless (not isNullElement datePicker) and datePicker.isVisible()
      dateParts = dateString.match(/^(\d{2}) (\D*) (\d{4})$/)
      raise "Date is in the wrong format. Need DD Month YYYY. Got #{dateString}" unless dateParts?
      # Set Day
      view.pickers()[0].wheels()[0].selectValue(dateParts[1])
      # Set Month
      counter = 0
      monthWheel = view.pickers()[0].wheels()[1]
      while monthWheel.value() != dateParts[2] and counter<12
          counter++
          monthWheel.tapWithOptions({tapOffset:{x:0.5, y:0.33}})
          target.delay(0.4)
      raise "Counldn't find the month #{dateParts[2]}" unless counter <12
      # Set Year
      view.pickers()[0].wheels()[2].selectValue(dateParts[3])
