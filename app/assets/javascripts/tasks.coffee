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

root.onclick_edit_button = (id) ->
  console.log id
  plain_tr = document.getElementById("taskrow_plain_#{id}")
  edit_tr = document.getElementById("taskrow_edit_#{id}")
  console.log plain_tr.id
  console.log edit_tr.id
  plain_tr.style.display = 'none'
  edit_tr.style.removeProperty 'display'
  


root.onclick_save_button = ->
  console.log  "push save"
  $.ajax
    type: 'PUT'
    url: '/tasks/12'
