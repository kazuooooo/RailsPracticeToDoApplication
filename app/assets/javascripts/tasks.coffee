# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


root = exports ? this

# test method
root.paintIt = (element, backgroundColor, textColor) ->
  element.style.backgroundColor = backgroundColor
  if textColor?
    element.style.color = textColor
  console.log "Call test method"

#
root.change_edit_button_text = (element) ->
  console.log element.value
  if element.value == "Edit"
    element.value= "Save"
    onclick_edit_button()
  else
    element.value = "Edit"
    onclick_save_button()

root.onclick_edit_button = ->
  console.log "push edit"  

root.onclick_save_button = ->
  console.log  "push save"



