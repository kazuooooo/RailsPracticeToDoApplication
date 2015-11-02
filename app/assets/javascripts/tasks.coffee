# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#ページ読み込み時に日付でソート
$ ->
  on_load_table()

on_load_table = ->
  #タスクの作成
  $("#create_button").on('click', create_task)
  #タスクの編集
  $(".edit_button").on('click', edit_task)
  #タスクの更新
  $(".update_button").on('click', update_task)
  #タスクの削除
  $(".delete_button").on('click', delete_task)
  #ステータスの変更
  $(".task_status").on('click', on_status_changed)
  #日付順にソート
  sort_by_plan_date()
  #予定日に応じて列に色付け
  color_task_row_text()
#完了済みタスクは列に色付けしてチェック
  set_today_on_create_date_picker()

##create task
#createbuttonが押されたらtaskを作ってテーブルだけリロード
create_task = ->
  #authenticate token
  authenticate_token = $("#authenticate_token_new").val()
  #入力値を取得
  title_val = $("#title_new").val()
  content_val = $("#content_new").val()
  plan_date = $("#plan_date_new")
  plan_date_val = $(plan_date).val()
  actual_date = $("#actual_date_new")
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
      $("#panel_body").load(location.href + " .table.table-striped.table-bordered.table-hover",->
        load_date_picker_setting()
        color_task_row_text()
        sort_by_plan_date()
        set_today_on_create_date_picker()
        on_load_table())
      #error表示がされていたら削除
      remove_error_list()
    .fail (jqXHR, statusText, errorThrown) ->
      show_error_list(jqXHR.responseText)
      on_load_table



##update task

#editbuttonを押したら入力フィールドを活性化
edit_task = (elem) ->
  #日付の
  #checkの状態を取得
  id = $(elem.toElement).val()
  task_status = $("#plain_status_#{id}").is(":checked")
  #actual_dateのdatepickerの使用可否
  if task_status
    #完了済みの場合は編集可能にする
    $("#actual_date_#{id}").removeAttr("style")
    #actual_dateの元の値を初期値に設定
    original_actual_date = $("#actual_date_hidden_#{id}").val().replace(/-/g,"/")
    $("#actual_date_#{id}").datepicker("setDate", original_actual_date)
  else
    #未完了のタスクについては空白
    $("#actual_date_#{id}").attr("style", "display:none")

  #列を編集状態にする
  switch_edit_state(id,true)

  #plan_dateの元の値を初期値に設定
  original_plan_date = $("#plan_date_hidden_#{id}").val().replace(/-/g,"/")
  $("#plan_date_#{id}").datepicker("setDate", original_plan_date)

#statusチェックボックス変更時
on_status_changed = (elem) ->
  #idを取得
  id = $(elem.toElement).val()
  #authenticate token
  authenticate_token = $("#authenticate_token_#{id}").val()
  #入力値を取得
  status_val = $("#plain_status_#{id}").is(":checked")
  actual_date_val = if status_val then get_today(true) else null
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
  plain_tr = $("#taskrow_plain_#{id}")
  edit_tr = $("#taskrow_edit_#{id}")

  if actual_date_val
    $(".plain_actual_date_#{id}").html(format_datetime_to_display(actual_date_val))
    $("#actual_date_hidden_#{id}").val(actual_date_val)
  else
    $(".plain_actual_date_#{id}").html("")

  $("#status_hidden_#{id}").val(status_val)
  color_task_row_text()

#task update
update_task = (elem) ->
  id = $(elem.toElement).val()
  #authenticate token
  authenticate_token = $("#authenticate_token_#{id}").value
  #入力値を取得
  #Editによるupdate
  #status_val = $("status_#{id}").checked
  plan_date = $("#plan_date_#{id}")
  plan_date_val = $(plan_date).val()

  actual_date = $("#actual_date_#{id}")
  actual_date_val = $(actual_date).val()

  title_val = $("#title_#{id}").val()
  content_val = $("#content_#{id}").val()

  #actionを実行
  jqXHR = $.ajax({
            url:"tasks/#{id}",
            type: "PUT",
            data: {
                  utf8:"✓",
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
    color_task_row_text()
    sort_by_plan_date()

  jqXHR.fail (jqXHR, statusText, errorThrown) ->
    show_error_list(jqXHR.responseText)

#フォームの活性比活性を切り替え
switch_edit_state = (id,is_active)->
  plain_tr = $("#taskrow_plain_#{id}")
  edit_tr = $("#taskrow_edit_#{id}")

  if is_active
    plain_tr.hide()
    edit_tr.show()
  else
    plain_tr.show()
    edit_tr.hide()

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
set_result_value_to_row = (id,title_val,content_val,plan_date_val,actual_date_val)->
  #各値を代入
  $("#plain_title_#{id}").html(title_val)
  $("#plain_content_#{id}").html(content_val)
  $("#plain_plan_date_#{id}").html(format_datetime_to_display(plan_date_val))
  if actual_date_val
    $(".plain_actual_date_#{id}").html(format_datetime_to_display(actual_date_val))
  #隠し項目で使っているものにも代入
  $("#plan_date_hidden_#{id}").val(plan_date_val)
  $("#actual_date_hidden_#{id}").val(actual_date_val)
  

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
get_today = (is_slush)->
  today_obj = new Date()
  d = today_obj.getDate()
  m = today_obj.getMonth() + 1
  y = today_obj.getFullYear()
  if (d<10)
    d = '0'+ d
  if (m<10)
    m = '0' + m
  if is_slush
    today = y + '/' + m + '/' + d
  else
    today = y + "-" + m + "-" + d
  return today

##delete task
#deleteボタンが押されたらajaxでdeleteを実行して行を削除
delete_task = (elem)->
  id = $(elem.toElement).val()
  #authenticate token
  authenticate_token = $("#authenticate_token_#{id}").value
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


#testmethod 予定日で降順にソート
sort_by_plan_date = ->
  $("table#task_table").tablesorter({
    headers:{
      0: {sorter: false}
      1: {sorter: false}
      2: {sorter: false}
    }
    sortList: [[3,0]]
  })

#予定日の近いものは列を色付け
color_task_row_text = ()->
  #今日のDateを取得
  today_obj = new Date(get_today(false))
  tommorow_obj = new Date(get_today(false))
  tommorow_obj.setDate(tommorow_obj.getDate()+1)

  #plan_dateを配列で取得
  plan_dates_vals = $(".plan_date_value")
  #plan_dateそれぞれに対して期日に応じて色付け
  for plan_date in plan_dates_vals
    date_obj =  new Date(plan_date.value)
    id = get_id_num(plan_date.id)
    #完了済みタスクの場合は灰色にして終了
    finish_task_row(id)
    status = $("#status_hidden_#{id}").val()
    if status == "true"
      $("#plain_status_#{id}").prop("checked",true)
    else
      if date_obj.getTime() < today_obj.getTime()
        alert_delay_task_row(id)
      else if date_obj.getTime() == today_obj.getTime()
        alert_today_task_row(id)
      else
        reset_task_row(id)

set_today_on_create_date_picker = () ->
   $("#plan_date_new").one('focus',->
    $("#plan_date_new").datepicker("setDate", get_today(true))
    )

get_id_num = (original_id) ->
  split_id = original_id.split("_")
  id = split_id.pop()
  return id

alert_delay_task_row = (id) ->
  RefrectTaskRowStatus(id,'#e20b0b',true)

alert_today_task_row = (id) ->
  RefrectTaskRowStatus(id,"#e20b0b",false)

reset_task_row = (id) ->
  RefrectTaskRowStatus(id,"",false)

finish_task_row = (id) ->
  RefrectTaskRowStatus(id,"#CFCFCF",false)

RefrectTaskRowStatus = (id,color,isBold) ->
  fontWeight = if isBold then "bold" else ""
  $(".task_values_#{id}").each ->
    $(this).css('font-weight',fontWeight).css('color',color)


#列を削除
delete_task_row = (id) ->
  $("#taskrow_plain_#{id}").remove()
  $("#taskrow_edit_#{id}").remove()

load_date_picker_setting = ->
  $('.datepicker').datepicker({
      format:'yyyy/mm/dd'
      language:'ja'
      })
