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
  plain_tr.style.display = 'none'
  edit_tr.style.removeProperty 'display'
  
root.onclick_save_button = ->
  console.log  "push save"
  $.ajax
    type: 'PUT'
    url: '/tasks/12'

root.onclick_update_button = (id) ->
  console.log "tasks/#{id}"
  #console.log "#{title}"
  $.ajax({
    url: "tasks/#{id}",
    type: "PATCH",
    data: {
          utf8: "✓", 
          task: {
                title: "babababababa",
                content: "nannanannnannann"
                plan_at: '2011-04-02 17:15:45'
                actual_at: '2011-04-02 17:15:45'
                },
          commit: "Update"
          id: id
          }
  })
#"content"=>"f", "z"=>"2015", "plan_at(2i)"=>"12", "plan_at(3i)"=>"15", "plan_at(4i)"=>"09", "plan_at(5i)"=>"14", "actual_at(1i)"=>"2015", "actual_at(2i)"=>"10", "actual_at(3i)"=>"15", "actual_at(4i)"=>"12", "actual_at(5i)"=>"19"}, "commit"=>"Updatepage", 
