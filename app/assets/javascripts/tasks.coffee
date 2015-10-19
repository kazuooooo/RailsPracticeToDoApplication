# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


root = exports ? this
##create task
root.onclick_create_button = (id)->
  #入力値を取得
  title_val = document.getElementById("title_#{id}").value
  content_val = document.getElementById("content_#{id}").value
  plan_at = document.getElementById("plan_at_#{id}")
  plan_at_val = get_datetime_vals(plan_at,'plan')
  actual_at = document.getElementById("actual_at_#{id}")
  actual_at_val = get_datetime_vals(actual_at,'actual')

  debugger
  #createを実行
  $.ajax({
    url: "tasks/",
    type: "POST",
    data: {
          utf8: "✓", 
          task: {
                title: title_val,
                content: content_val,
                plan_at: plan_at_val,
                actual_at: actual_at_val,
                },
          commit: "Create"
          }
  })

##update task
#editbuttonを押したら入力フィールドを活性化
root.onclick_edit_button = (id) ->
  switch_edit_state(id,'active')

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
  #フィールドを非活性化
  switch_edit_state(id,'unactive')
  set_input_value_to_unactive_forms(id,title_val,content_val,plan_at_val,actual_at_val)

#入力値を非活性状態のフォームに突っ込む
set_input_value_to_unactive_forms = (id,title_val,content_val,plan_at_val,actual_at_val) ->
  console.log "set"+actual_at_val
  #element取得
  plain_title = document.getElementById("plain_title_#{id}")
  plain_content = document.getElementById("plain_content_#{id}")
  plain_plan_at = document.getElementById("plain_plan_at_#{id}")
  plain_actual_at = document.getElementById("plain_actual_at_#{id}")
  #値を代入
  plain_title.innerHTML = title_val
  plain_content.innerHTML = content_val
  plain_plan_at.innerHTML = plan_at_val
  plain_actual_at.innerHTML = actual_at_val

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
  debugger
  selecting_val = selectbox.options[selectbox.selectedIndex].text;
  return selecting_val

#フォームの活性比活性を切り替え
switch_edit_state = (id,state)->
  plain_tr = document.getElementById("taskrow_plain_#{id}")
  edit_tr = document.getElementById("taskrow_edit_#{id}")
  #delete_button_onedit = document.getElementById("delete_button_onedit_#{id}")
  #console.log delete_button_onedit.id
  if state == 'active'
    plain_tr.style.display = 'none'
    edit_tr.style.removeProperty 'display'
    console.log "call disabled"
    #delete_button_onedit.disabled = 'disabled'
  else
    plain_tr.style.removeProperty 'display'
    edit_tr.style.display = 'none'
    #delete_button_onedit.disabled = ''


##delete task
root.onclick_delete_button = (id)->
  task_table = document.getElementById("task_table")
  #trを削除(solid)
  plain_tr = document.getElementById("taskrow_plain_#{id}")
  edit_tr = document.getElementById("taskrow_edit_#{id}")
  #plain行
  plain_row_num = plain_tr.rowIndex 
  task_table.deleteRow(plain_row_num);
  #
  edit_row_num = edit_tr.rowIndex
  task_table.deleteRow(edit_row_num)
  #actionを実行
  $.ajax({
    url: "tasks/#{id}",
    type: "DELETE",
    data: {
          id: id
          }
  })
  



















