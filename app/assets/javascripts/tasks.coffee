# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#ページ読み込み時に日付でソート
$ ->
  onLoadTable()

onLoadTable = ->
  #タスクの作成
  $("#create_button").on("click", createTask)
  #タスクの編集
  $(".edit_button").on("click", editTask)
  #タスクの更新
  $(".update_button").on("click", updateTask)
  #タスクの削除
  $(".delete_button").on("click", deleteTask)
  #ステータスの変更
  $(".task_status").on("click", onStatusChanged)
  #日付順にソート
  sortByPlanDate()
  #予定日に応じて列に色付け
  colorTaskRowText()
#完了済みタスクは列に色付けしてチェック
  setTodayOnDatePicker()

##create task
#createbuttonが押されたらtaskを作ってテーブルだけリロード
createTask = ->
  #authenticate token
  authenticateToken= $("#authenticate_token_new").val()
  #入力値を取得
  titleVal = $("#title_new").val()
  contentVal= $("#content_new").val()
  planDateVal = $("#plan_date_new").val()
  actualDateVal = $("#actual_date_new").val()
  #createを実行
  $.ajax({
    url: "tasks/"
    type: "POST"
    data: {
          utf8: "✓"
          authenticity_token: authenticateToken
          task: {
                status: false
                title: titleVal
                content: contentVal
                plan_date: planDateVal
                actual_date: actualDateVal
                }
          commit: "Create"
          }
  }).done ->
      #成功したらテーブルをリロード
      #.load(url,data,callback)
      $("#panel_body").load(location.href + " .table.table-striped.table-bordered.table-hover", ->
        loadDatePickerSetting()
        colorTaskRowText()
        sortByPlanDate()
        setTodayOnDatePicker()
        onLoadTable())
      #error表示がされていたら削除
      removeErrorList()
    .fail (jqXHR, statusText, errorThrown) ->
      showErrorList(jqXHR.responseText)
      onLoadTable()



##update task

#editbuttonを押したら入力フィールドを活性化
editTask = (event) ->
  #日付の
  #checkの状態を取得
  id = $(this).val()
  taskStatus = $("#plain_status_#{id}").is(":checked")
  #actual_dateのdatepickerの使用可否
  if taskStatus
    #完了済みの場合は編集可能にする
    $("#actual_date_#{id}").removeAttr("style")
    #actual_dateの元の値を初期値に設定
    originalActualDate = $("#actual_date_hidden_#{id}").val().replace(/-/g,"/")
    $("#actual_date_#{id}").datepicker("setDate", originalActualDate)
  else
    #未完了のタスクについては空白
    $("#actual_date_#{id}").attr("style", "display:none")

  #列を編集状態にする
  switchEditState(id,true)

  #plan_dateの元の値を初期値に設定
  originalPlanDate = $("#plan_date_hidden_#{id}").val().replace(/-/g,"/")
  $("#plan_date_#{id}").datepicker("setDate", originalPlanDate)

#statusチェックボックス変更時
onStatusChanged = (event) ->
  #idを取得
  id = $(this).val()
  #authenticate token
  authenticateToken= $("#authenticate_token_#{id}").val()
  #入力値を取得
  statusVal = $("#plain_status_#{id}").is(":checked")
  actualDateVal = if statusVal then getToday(true) else null
  #actionを実行
  jqXHR = $.ajax({
            url: "tasks/#{id}"
            type: "PUT"
            data: {
                  utf8: "✓"
                  authenticity_token: authenticateToken
                  task: {
                        status: statusVal
                        actual_date: actualDateVal
                        }
                  commit: "Update"
                  id: id
                  }
          })

  #updateが成功したときの処理
  jqXHR.done (data, stat, xhr) ->
    #結果を画面に反映
    idResult = data["id"]
    statusResult = data["status"]
    actualDateResult = data["actual_date"]
    setResultOnStatusChecked(idResult,statusResult,actualDateResult)

  jqXHR.fail (jqXHR, statusText, errorThrown) ->
    showErrorList(jqXHR.responseText)

setResultOnStatusChecked = (id, statusVal, actualDateVal) ->
  if actualDateVal
    $(".plain_actual_date_#{id}").html(formatDateTimeToDisplay(actualDateVal))
    $("#actual_date_hidden_#{id}").val(actualDateVal)
  else
    $(".plain_actual_date_#{id}").html("")

  $("#status_hidden_#{id}").val(statusVal)
  colorTaskRowText()

#task update
updateTask = (event) ->
  id = $(this).val()
  #authenticate token
  authenticateToken= $("#authenticate_token_#{id}").value
  #入力値を取得
  #Editによるupdate
  #statusVal = $("status_#{id}").checked
  planDateVal = $("#plan_date_#{id}").val()
  actualDateVal = $("#actual_date_#{id}").val()

  titleVal = $("#title_#{id}").val()
  contentVal= $("#content_#{id}").val()

  #actionを実行
  jqXHR = $.ajax({
            url:"tasks/#{id}"
            type: "PUT"
            data: {
                  utf8:"✓"
                  authenticity_token: authenticateToken
                  task: {
                        title: titleVal
                        content: contentVal
                        plan_date: planDateVal
                        actual_date: actualDateVal
                        }
                  commit: "Update"
                  id: id
                  }
          })

  #updateが成功したときの処理
  jqXHR.done (data, stat, xhr) ->
    #結果を画面に反映
    idResult = data["id"]
    titleResult = data["title"]
    contentResult = data["content"]
    planDateResult = data["plan_date"]
    actualDateResult = data["actual_date"]
    setResultValueToRow(idResult,titleResult,contentResult,planDateResult,actualDateResult)
    switchEditState(id,false)
    removeErrorList()
    colorTaskRowText()
    sortByPlanDate()

  jqXHR.fail (jqXHR, statusText, errorThrown) ->
    showErrorList(jqXHR.responseText)

#フォームの活性比活性を切り替え
switchEditState = (id,isActive) ->
  $plainTr = $("#taskrow_plain_#{id}")
  $editTr = $("#taskrow_edit_#{id}")

  if isActive
    $plainTr.hide()
    $editTr.show()
  else
    $plainTr.show()
    $editTr.hide()

# エラー内容を受け取って表示する
showErrorList = (errorTxt) ->
  # 元々エラーが出ていればそれを一旦削除
  removeErrorList()
  # errorをJSON形式にparse
  errorObj = JSON.parse(errorTxt)
  #エラーそれぞれを箇条書きにして表示
  #alert-dangerの枠を作成
  $("#alert-container").append("<div class = 'alert alert-danger'></div>")
  #ul要素を作成
  $(".alert.alert-danger").append("<ul id = 'alert_list'></ul>")
  #ul要素内にli要素を作ってそこに各エラーを表示
  for key, value of errorObj
    $("#alert_list").append("<li> #{key} #{value} </li>")

removeErrorList = ->
  $(".alert.alert-danger").remove()


#入力値を対象の列に代入
setResultValueToRow = (id,titleVal,contentVal,planDateVal,actualDateVal)->
  #各値を代入
  $("#plain_title_#{id}").html(titleVal)
  $("#plain_content_#{id}").html(contentVal)
  $("#plain_plan_date_#{id}").html(formatDateTimeToDisplay(planDateVal))
  if actualDateVal
    $(".plain_actual_date_#{id}").html(formatDateTimeToDisplay(actualDateVal))
  #隠し項目で使っているものにも代入
  $("#plan_date_hidden_#{id}").val(planDateVal)
  $("#actual_date_hidden_#{id}").val(actualDateVal)
  

#datetimeを実際の表示形式に変換
formatDateTimeToDisplay = (dateTimeFormat) ->
  date = new Date(dateTimeFormat)
  y = date.getFullYear()
  m = date.getMonth() + 1
  d = date.getDate()
  w = date.getDay()
  #曜日を配列で登録しておく
  wNames = ["日","月","火","水","木","金","土"]
  #月日の頭に0
  if(m < 10)
    m = "0" + m
  if(d < 10)
    d = "0"+ d
  formattedDate = m + "/" + d + " ("+ wNames[w] + ")"
  return formattedDate

#今日の日付を取得
getToday = (isSlush) ->
  todayObj = new Date()
  d = todayObj.getDate()
  m = todayObj.getMonth() + 1
  y = todayObj.getFullYear()
  if (d < 10)
    d = "0"+ d
  if (m < 10)
    m = "0" + m
  if isSlush
    today = y + "/" + m + "/" + d
  else
    today = y + "-" + m + "-" + d
  return today

##delete task
#deleteボタンが押されたらajaxでdeleteを実行して行を削除
deleteTask = (event) ->
  id = $(this).val()
  #authenticate token
  authenticateToken= $("#authenticate_token_#{id}").value
  #actionを実行
  $.ajax({
    url: "tasks/#{id}"
    type: "DELETE"
    data: {
          authenticity_token: authenticateToken
          id: id
          }
  }).done ->
      deleteTaskRow(id)
    .fail ->
      alert("task delete failed")


#testmethod 予定日で降順にソート
sortByPlanDate = ->
  $("table#task_table").tablesorter({
    headers:{
      0: {sorter: false}
      1: {sorter: false}
      2: {sorter: false}
    }
    sortList: [[3,0]]
  })

#予定日の近いものは列を色付け
colorTaskRowText = () ->
  #今日のDateを取得
  todayObj = new Date(getToday(false))
  tommorowObj = new Date(getToday(false))
  tommorowObj.setDate(tommorowObj.getDate() + 1)

  #plan_dateを配列で取得
  plan_dates_vals = $(".plan_date_value")
  #plan_dateそれぞれに対して期日に応じて色付け
  for plan_date in plan_dates_vals
    dateObj =  new Date(plan_date.value)
    id = getIdNum(plan_date.id)
    #完了済みタスクの場合は灰色にして終了
    finishTaskRow(id)
    status = $("#status_hidden_#{id}").val()
    if status == "true"
      $("#plain_status_#{id}").prop("checked", true)
    else
      if dateObj.getTime() < todayObj.getTime()
        alertDelayTaskRow(id)
      else if dateObj.getTime() == todayObj.getTime()
        alertTodayTaskRow(id)
      else
        resetTaskRow(id)

setTodayOnDatePicker = () ->
   $("#plan_date_new").one("focus", ->
    $("#plan_date_new").datepicker("setDate", getToday(true))
    )

getIdNum = (originalId) ->
  splitId = originalId.split("_")
  id = splitId.pop()
  return id

alertDelayTaskRow = (id) ->
  refrectTaskRowStatus(id,"#e20b0b",true)

alertTodayTaskRow = (id) ->
  refrectTaskRowStatus(id,"#e20b0b",false)

resetTaskRow = (id) ->
  refrectTaskRowStatus(id,"",false)

finishTaskRow = (id) ->
  refrectTaskRowStatus(id,"#CFCFCF",false)

refrectTaskRowStatus = (id,color,isBold) ->
  fontWeight = if isBold then "bold" else ""
  $(".task_values_#{id}").each ->
    $(this).css("font-weight",fontWeight).css("color", color)


#列を削除
deleteTaskRow = (id) ->
  $("#taskrow_plain_#{id}").remove()
  $("#taskrow_edit_#{id}").remove()

loadDatePickerSetting = ->
  $(".datepicker").datepicker({
      format:"yyyy/mm/dd"
      language:"ja"
      })
