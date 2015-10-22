# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

root = exports ? this
##create task

#createbuttonが押されたらtaskを作ってテーブルだけリロード
root.onclick_create_button = (id)->
  #authenticate token
  authenticate_token = document.getElementById("authenticate_token_#{id}").value
  #入力値を取得
  title_val = document.getElementById("title_#{id}").value
  content_val = document.getElementById("content_#{id}").value
  plan_at = document.getElementById("plan_at_#{id}")
  plan_at_val = get_datetime_vals(plan_at,'plan')
  actual_at = document.getElementById("actual_at_#{id}")
  actual_at_val = get_datetime_vals(actual_at,'actual')
  #createを実行
  $.ajax({
    url: "tasks/",
    type: "POST",
    data: {
          utf8: "✓",
          authenticity_token: authenticate_token, 
          task: {
                status: false,
                title: title_val,
                content: content_val,
                plan_at: plan_at_val,
                actual_at: actual_at_val,
                },
          commit: "Create"
          }
  }).done =>
      #成功したらテーブルをリロード
      $(".table.table-striped.table-bordered.table-hover").load(location.href + " .table.table-striped.table-bordered.table-hover");
    .fail (jqXHR, statusText, errorThrown) ->
      show_error(jqXHR.responseText)


##update task

#editbuttonを押したら入力フィールドを活性化
root.onclick_edit_button = (id) ->
  switch_edit_state(id,'active')

#updateボタンが押されたら今入力されている値を取得してajaxでupdate
root.onclick_update_button = (id) ->
  update_task(false,id)

#statusチェックボックス変更時
root.on_status_changed = (id) ->
  update_task(true,id)

#task update
update_task = (plain_update, id) ->
  #authenticate token
  authenticate_token = document.getElementById("authenticate_token_#{id}").value
  #入力値を取得
  if plain_update
    status_val = document.getElementById("plain_status_#{id}").checked
  else
    status_val = document.getElementById("status_#{id}").checked

  title_val = document.getElementById("title_#{id}").value
  content_val = document.getElementById("content_#{id}").value
  plan_at = document.getElementById("plan_at_#{id}")
  plan_at_val = get_datetime_vals(plan_at,'plan')
  actual_at = document.getElementById("actual_at_#{id}")
  actual_at_val = get_datetime_vals(actual_at,'actual')
  #actionを実行
  jqXHR = $.ajax({
            url: "tasks/#{id}",
            type: "PUT",
            data: {
                  utf8: "✓",
                  authenticity_token: authenticate_token,  
                  task: {
                        status: status_val,
                        title: title_val,
                        content: content_val,
                        plan_at: plan_at_val,
                        actual_at: actual_at_val,
                        },
                  commit: "Update",
                  id: id
                  }
          })

  #updateが成功したときの処理
  jqXHR.done (data, stat, xhr) ->
    #結果を画面に反映
    id_result = data["id"]
    status_result = data["status"]
    title_result = data["title"]
    content_result = data["content"]
    plan_at_result = data["plan_at"]
    actual_at_result = data["actual_at"]
    switch_edit_state(id,'unactive')
    set_result_value_to_row(id_result,status_result,title_result,content_result,plan_at_result,actual_at_result)

  jqXHR.fail (jqXHR, statusText, errorThrown) ->
    show_error(jqXHR.responseText)
    debugger

#エラー内容を受け取って表示する
show_error = (error_txt) ->
  error_obj = JSON.parse(error_txt)
  #TODO:受け取った値をflashで表示

#入力値を対象の列に代入
set_result_value_to_row = (id,status_val,title_val,content_val,plan_at_val,actual_at_val) ->
  #element取得
  plain_tr = document.getElementById("taskrow_plain_#{id}")
  edit_tr = document.getElementById("taskrow_edit_#{id}")
  plain_title = document.getElementById("plain_title_#{id}")
  plain_content = document.getElementById("plain_content_#{id}")
  plain_plan_at = document.getElementById("plain_plan_at_#{id}")
  plain_actual_at = document.getElementById("plain_actual_at_#{id}")
  #値を代入
  plain_title.innerHTML = title_val
  plain_content.innerHTML = content_val
  plain_plan_at.innerHTML = plan_at_val
  plain_actual_at.innerHTML = actual_at_val
  #checkboxで行の色を切り替え
  switch_task_state(plain_tr,edit_tr,status_val)

switch_task_state = (plain_tr,edit_tr,task_status) ->
  if task_status
    console.log "checked"
    plain_tr.style.backgroundColor = "#6E6E6E"
    edit_tr.style.backgroundColor = "#6E6E6E"
  else
    console.log "unchecked"
    plain_tr.style.backgroundColor = "#FFFFFF"
    edit_tr.style.backgroundColor = "#FFFFFF"

#datetimeselectの入力値を取得して返す
get_datetime_vals = (datetime_element,valname) ->
  year = get_selecting_val(datetime_element, "#task_#{valname}_at_1i")
  month = get_selecting_val(datetime_element, "#task_#{valname}_at_2i")
  day = get_selecting_val(datetime_element, "#task_#{valname}_at_3i")
  hour = get_selecting_val(datetime_element, "#task_#{valname}_at_4i")
  minutes = get_selecting_val(datetime_element, "#task_#{valname}_at_5i")
  return year+"-"+month+"-"+day+" "+hour+":"+minutes

#selectboxの選択値を取得
get_selecting_val = (datetime_element, id) ->
  selectbox = datetime_element.querySelector(id);
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
#deleteボタンが押されたらajaxでdeleteを実行して行を削除
root.onclick_delete_button = (id)->
  #authenticate token
  authenticate_token = document.getElementById("authenticate_token_#{id}").value
  #actionを実行
  $.ajax({
    url: "tasks/#{id}",
    type: "DELETE",
    data: {
          authenticity_token: authenticate_token, 
          id: id
          }
  }).done ->
      delete_task_row(id)
    .fail ->
      alert("task delete failed")

#列を削除
delete_task_row = (id) ->
  task_table = document.getElementById("task_table")
  #plain行を削除
  plain_tr = document.getElementById("taskrow_plain_#{id}")
  plain_row_num = plain_tr.rowIndex 
  task_table.deleteRow(plain_row_num)
  #edit行を削除
  edit_tr = document.getElementById("taskrow_edit_#{id}")
  edit_row_num = edit_tr.rowIndex
  task_table.deleteRow(edit_row_num)