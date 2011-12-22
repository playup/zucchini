class WelcomeScreen extends Screen
  anchor: -> view.elements()["Welcome to MyApp"]
  
  constructor: ->
    super 'welcome'
    
    extend @elements,
    'Go' : -> view.buttons()["Go"]
    
    extend @actions,
    'Type "([^"]*)" in the username field$': (text) ->
      field = view.elements()['Username']
      field.setValue text