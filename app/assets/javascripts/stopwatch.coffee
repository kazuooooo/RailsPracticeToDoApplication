
time = 0
timer_process = 0

window.start_timer = ->
  timer_process = setInterval("count_up()",1000)

window.count_up = ->
  timer = document.getElementById("timertext")
  time++
  timer.innerHTML = format_time(time)

window.stop_timer = ->
  clearInterval(timer_process) 

format_time = (time) ->
  hours = Math.floor(time/3600)
  minutes = Math.floor((time-hours*3600)/60)
  seconds = (time-hours*3600-minutes*60)
  if hours < 10
    hours = "0"+hours
  if minutes < 10
    minutes = "0"+minutes
  if seconds < 10
    seconds = "0"+seconds
  return hours+":"+minutes+":"+seconds

window.reset_timer = ->
  timer = document.getElementById("timertext")
  clearInterval(timer_process)
  time = 0
  timer.innerHTML = "00:00:00"




