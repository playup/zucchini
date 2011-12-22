class SplashScreen extends Screen
  anchor: -> view.elements()["Welcome"]
  
  constructor: ->
    super 'splash'
    
    extend @elements,
    'Go' : -> view.buttons()["Go"]