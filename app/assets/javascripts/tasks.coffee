# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

root = exports ? this
##create task
#createbuttonが押されたらtaskを作ってテーブルだけリロード

root.onclick_create_button = ->
  #authenticate token
  authenticate_token = document.getElementById("authenticate_token_new").value
  #入力値を取得
  title_val = document.getElementById("title_new").value
  content_val = document.getElementById("content_new").value
  plan_date = document.getElementById("plan_date_new")
  plan_date_val = $(plan_date).val()
  actual_date = document.getElementById("actual_date_new")
  actual_date_val = $(actual_date).val()
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
                plan_date: plan_date_val,
                actual_date: actual_date_val,
                },
          commit: "Create"
          }
  }).done ->
      #成功したらテーブルをリロード
      #.load(url,data,callback)
      $("#panel_body").load(location.href + " .table.table-striped.table-bordered.table-hover");
      #error表示がされていたら削除
      remove_error_list()
    .fail (jqXHR, statusText, errorThrown) ->
      show_error_list(jqXHR.responseText)


##update task

#editbuttonを押したら入力フィールドを活性化
root.onclick_edit_button = (id,plan_date) ->
  switch_edit_state(id,true)
  console.log("plandate"+plan_date)

#statusチェックボックス変更時
root.on_status_changed = (id) ->
  #authenticate token
  authenticate_token = document.getElementById("authenticate_token_#{id}").value
  #入力値を取得
  status_val = document.getElementById("plain_status_#{id}").checked
  actual_date_val = if status_val then get_today() else null
  #actionを実行
  jqXHR = $.ajax({
            url: "tasks/#{id}",
            type: "PUT",
            data: {
                  utf8: "✓",
                  authenticity_token: authenticate_token,  
                  task: {
                        status: status_val,
                        actual_date: actual_date_val,
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
    actual_date_result = data["actual_date"]
    set_result_on_status_checked(id_result,status_result,actual_date_result)

  jqXHR.fail (jqXHR, statusText, errorThrown) ->
    show_error_list(jqXHR.responseText)

set_result_on_status_checked = (id, status_val, actual_date_val) ->
  #element取得
  plain_tr = document.getElementById("taskrow_plain_#{id}")
  edit_tr = document.getElementById("taskrow_edit_#{id}")
  #plain_actual_date = document.getElementById("plain_actual_date_#{id}")

  if actual_date_val
    $(".plain_actual_date_#{id}").html(format_datetime_to_display(actual_date_val))
  else
    $(".plain_actual_date_#{id}").html("")
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

#task update
root.onclick_update_button = (id) ->
  #authenticate token
  authenticate_token = document.getElementById("authenticate_token_#{id}").value
  #入力値を取得
  #Editによるupdate
  #status_val = document.getElementById("status_#{id}").checked
  plan_date = document.getElementById("plan_date_#{id}")
  plan_date_val = $(plan_date).val()

  actual_date = document.getElementById("actual_date_#{id}")
  actual_date_val = $(actual_date).val()

  title_val = document.getElementById("title_#{id}").value
  content_val = document.getElementById("content_#{id}").value

  #actionを実行
  jqXHR = $.ajax({
            url: "tasks/#{id}",
            type: "PUT",
            data: {
                  utf8: "✓",
                  authenticity_token: authenticate_token,  
                  task: {
                        title: title_val,
                        content: content_val,
                        plan_date: plan_date_val,
                        actual_date: actual_date_val,
                        },
                  commit: "Update",
                  id: id
                  }
          })

  #updateが成功したときの処理
  jqXHR.done (data, stat, xhr) ->
    #結果を画面に反映
    id_result = data["id"]
    title_result = data["title"]
    content_result = data["content"]
    plan_date_result = data["plan_date"]
    actual_date_result = data["actual_date"]
    set_result_value_to_row(id_result,title_result,content_result,plan_date_result,actual_date_result)
    switch_edit_state(id,false)
    remove_error_list()

  jqXHR.fail (jqXHR, statusText, errorThrown) ->
    show_error_list(jqXHR.responseText)

#フォームの活性比活性を切り替え
switch_edit_state = (id,is_active)->
  plain_tr = document.getElementById("taskrow_plain_#{id}")
  edit_tr = document.getElementById("taskrow_edit_#{id}")
  #delete_button_onedit = document.getElementById("delete_button_onedit_#{id}")
  #console.log delete_button_onedit.id
  if is_active
    plain_tr.style.display = 'none'
    edit_tr.style.removeProperty 'display'
    console.log "call disabled"
    #delete_button_onedit.disabled = 'disabled'
  else
    plain_tr.style.removeProperty 'display'
    edit_tr.style.display = 'none'
    #delete_button_onedit.disabled = ''


# エラー内容を受け取って表示する
show_error_list = (error_txt) ->
  # 元々エラーが出ていればそれを一旦削除
  remove_error_list()
  # errorをJSON形式にparse
  error_obj = JSON.parse(error_txt)
  #エラーそれぞれを箇条書きにして表示
  #alert-dangerの枠を作成
  $('#alert-container').append("<div class=\"alert alert-danger\"></div>")
  #ul要素を作成
  $('.alert.alert-danger').append("<ul id=\"alert_list\"></ul>")
  #ul要素内にli要素を作ってそこに各エラーを表示
  for key, value of error_obj
    $('#alert_list').append("<li> #{key} #{value} </li>")

remove_error_list = ->
  $('.alert.alert-danger').remove()


#入力値を対象の列に代入
set_result_value_to_row = (id,title_val,content_val,plan_date_val,actual_date_val) ->
  #element取得
  plain_title = document.getElementById("plain_title_#{id}")
  plain_content = document.getElementById("plain_content_#{id}")
  plain_plan_date = document.getElementById("plain_plan_date_#{id}")
  plain_actual_date = document.getElementById("plain_actual_date_#{id}_done")
  #値を代入
  plain_title.innerHTML = title_val
  plain_content.innerHTML = content_val
  plain_actual_date.innerHTML = format_datetime_to_display(actual_date_val)
  plain_plan_date.innerHTML = format_datetime_to_display(plan_date_val)
  debugger

#datetimeを実際の表示形式に変換
format_datetime_to_display = (datetime_format) ->
  date = new Date(datetime_format)
  y = date.getFullYear()
  m = date.getMonth()+1
  d = date.getDate()
  w = date.getDay()
  #曜日を配列で登録しておく
  wNames = ['日','月','火','水','木','金','土']
  #月日の頭に0
  if(m < 10)
    m = '0' + m
  if(d < 10)
    d = '0'+ d
  formatted_date = m + '/' + d + ' ('+ wNames[w] + ')'
  return formatted_date

#今日の日付を取得
get_today = ->
  today_obj = new Date()
  d = today_obj.getDate()
  m = today_obj.getMonth() + 1
  y = today_obj.getFullYear()
  if (d<10)
    d = '0'+ d
  if (m<10)
    m = '0' + m
  today = y + '/' + m + '/' + d
  return today






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
  console.log task_table.rows.length
  #plain行を削除
  plain_tr = document.getElementById("taskrow_plain_#{id}")
  plain_row_num = plain_tr.rowIndex
  task_table.deleteRow(plain_row_num)
  #edit行を削除
  edit_tr = document.getElementById("taskrow_edit_#{id}")
  edit_row_num = edit_tr.rowIndex
  task_table.deleteRow(edit_row_num)

