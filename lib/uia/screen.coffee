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
      throw "Element '#{element}' not defined for the screen '#{@name}'" unless @elements[element]
      @elements[element]().tap()

    'Wait for "([^"]*)" second[s]*$' : (seconds) ->
      target.delay(seconds)

    'Confirm "([^"]*)"$' : (element) ->
      @actions['Tap "([^"]*)"$'].bind(this)(element)

    'Cancel the alert' : ->
      alert = app.alert()
      throw "No alert found to dismiss on screen '#{@name}'" if isNullElement alert
      alert.cancelButton().tap()

    'Confirm the alert' : ->
      alert = app.alert()
      throw "No alert found to dismiss on screen '#{@name}'" if isNullElement alert
      alert.defaultButton().tap()