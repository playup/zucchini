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

