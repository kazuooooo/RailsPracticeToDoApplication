# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


root = exports ? this

root.change_edit_button_text = (element) ->
  console.log element.value
  if element.value == "Edit"
    element.value = "Save"
  else
    element.value = "Edit" 

#editbuttonを押したら入力フィールドを活性化
root.onclick_edit_button = (id) ->
  plain_tr = document.getElementById("taskrow_plain_#{id}")
  edit_tr = document.getElementById("taskrow_edit_#{id}")
  plain_tr.style.display = 'none'
  edit_tr.style.removeProperty 'display'

#updateボタンが押されたら今入力されている値を取得してajaxでupdateを走らせる
root.onclick_update_button = (id) ->
  #入力値を取得
  title_val = document.getElementById("title_#{id}").value
  content_val = document.getElementById("content_#{id}").value
  plan_at = document.getElementById("plan_at_#{id}")
  plan_at_val = get_datetime_vals(plan_at,'plan')
  actual_at = document.getElementById("actual_at_#{id}")
  actual_at_val = get_datetime_vals(actual_at,'actual')

  #actionを実行
  $.ajax({
    url: "tasks/#{id}",
    type: "PUT",
    data: {
          utf8: "✓", 
          task: {
                title: title_val,
                content: content_val,
                plan_at: plan_at_val,
                actual_at: actual_at_val,
                },
          commit: "Update"
          id: id
          }
  })

#datetimeselectの入力値を取得して返す
get_datetime_vals = (datetime_element,valname) ->
  year = get_selecting_val(datetime_element, "#task_#{valname}_at_1i")
  month = get_selecting_val(datetime_element, "#task_#{valname}_at_2i")
  day = get_selecting_val(datetime_element, "#task_#{valname}_at_3i")
  hour = get_selecting_val(datetime_element, "#task_#{valname}_at_4i")
  minutes = get_selecting_val(datetime_element, "#task_#{valname}_at_5i")
  return year+"-"+month+"-"+day+" "+hour+":"+minutes+":"+"00"

#selectboxの選択値を取得
get_selecting_val = (datetime_element, id) ->
  selectbox = datetime_element.querySelector(id);
  selecting_val = selectbox.options[selectbox.selectedIndex].text;
  return selecting_val




















