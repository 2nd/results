window.build = (sample) ->

  fields = sample[sample.length-1]
  filters = []
  key = []
  day = []
  element = []
  name = []
  d = {}
  for field,i in fields
    if field.filter
      filters.push i
    else
      name.push field

  for row in sample.slice(0,sample.length-1)
    day.push row[0]
    temp = filters.slice(1)
    if filters.length > 1
      key = ""
      for i in temp
        key += row[filters[i]]+"$"
        key2 = key.substring(0,key.length-1)
    else
        key2 = "undefine"
    for i in [0...row.length]
      if i not in temp
        element.push row[i]
    estTime = new Date(element[0])
    if d[key2]
      d[key2][estTime] = {}
      d[key2][estTime] = element.slice(1)
    else
      d[key2] = {}
      d[key2][estTime] = {}
      d[key2][estTime] = element.slice(1)
      jcount = element.slice(1).length
    element = []

  # sort by days
  Value = {}
  tmp = []
  oldestDay = new Date(day.sort()[0])
  latestDay = new Date(day.sort()[day.length-1])
  diffDays = (latestDay - oldestDay)/(1000 * 3600 * 24)

  #find consensus day
  concensusDay = []
  for i in [0...diffDays+1] by 1
    result = new Date(oldestDay)
    result.setDate(oldestDay.getDate() + i)
    concensusDay.push result


  # rebuild data structure
  for key of d
    ary = {}
    for i in [0...name.length]
      nm = name[i]
      tmp = []
      for consDay in concensusDay
        tmp.push d[key][consDay][i]
      ary[nm]=tmp
    Value[key]=ary

    totalName = []
    for field,i in fields
      if field.filter
        totalName.push field.name
      else
        totalName.push field
    totalName.push filters.length

  window.valueDic = Value
  window.columnLi = totalName
  window.dateLi = concensusDay

largerBetter = ['total']
littleBetter = ['avg', 'stddev', '95', '99']
defineStyle = (column, value) ->
  if largerBetter.indexOf(column) != -1
    value = - value
  if value > 0
    return 'better'
  else if value <0
    return 'worse'
  return 'none' # ['Worse', 'Better', 'normal']

calculatePercent = (colKey, colArray,compareIndex) ->
  dayCompare = []
  dayStyle = []
  colArray = colArray.reverse()
  for i in [0...colArray.length-compareIndex] by 1
    tempvalue = (colArray[i] - colArray[i+compareIndex])/(colArray[i+compareIndex] + 1)  # colArray[i+1]  might be 0
    dayCompare.push(tempvalue)
    dayStyle.push(defineStyle(colKey, tempvalue))
  for i in [0...compareIndex] by 1
      dayStyle.push('none')
      dayCompare.push('na')
  return [dayCompare.reverse(), dayStyle.reverse()]

window.calculateTrend = (inputValueDic) ->
  dayValueDic = {}
  weekValueDic = {}
  dayStyleDic = {}
  weekStyleDic = {}
  todayStyleDic = {}
  for regKey, value of inputValueDic
    dayValueDic[regKey] = {}
    weekValueDic[regKey] = {}
    dayStyleDic[regKey] = {}
    weekStyleDic[regKey] = {}
    todayStyleDic[regKey] = {}
    for colKey, colArray of value  # column key , column array
      todayStyleDic[regKey][colKey] = []
      for i in [0...colArray.length] by 1
        todayStyleDic[regKey][colKey].push('none')
      [dayValueDic[regKey][colKey], dayStyleDic[regKey][colKey]] = calculatePercent(colKey, colArray, 1)
      [weekValueDic[regKey][colKey], weekStyleDic[regKey][colKey]] = calculatePercent(colKey, colArray, 7)
  M0 = {valueDic: inputValueDic, styleDic: todayStyleDic}
  M1 = {valueDic: dayValueDic, styleDic: dayStyleDic}
  M2 = {valueDic: weekValueDic, styleDic: weekStyleDic}
  return [M0, M1, M2]
