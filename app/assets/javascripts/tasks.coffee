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

root.change_edit_button_text = (element) ->
  console.log element.value
  if element.value == "Edit"
    element.value = "Save"
  else
    element.value = "Edit" 

root.onclick_edit_button = (element) ->
  console.log element.id
  parent_tr = element.parentNode.parentNode
  console.log parent_tr.id
  


root.onclick_save_button = ->
  console.log  "push save"
  $.ajax
    type: 'PUT'
    url: '/tasks/12'
