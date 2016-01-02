window.build = (sample) ->
  fields = sample[sample.length-1]
  filters = []
  filterNames = []
  names = []
  for field,i in fields
    continue if i == 0
    if field.filter
      filters.push i
      filterNames.push field.name
    else
      names.push field

  totalName = ["date"].concat(filterNames.concat(names))
  totalName.push filters.length+1

  element = []
  data = {}
  for row in sample.slice(0,sample.length-1)
    if filters.length > 0
      key = ""
      for i in filters
        key += row[i]+"$"
      key = key.substring(0,key.length-1)
    else
      key = "undefine"
    for i in [0...row.length]
      if i not in filters
        element.push row[i]
    time = new Date(element[0])
    if data[key]
      data[key][time] = element.slice(1)
    else
      data[key] = {}
      data[key][time] = element.slice(1)
    element = []

  allDays = []
  oldestDay = new Date(sample[sample.length-2][0])
  latestDay = new Date(sample[0][0])
  diffDays = (latestDay - oldestDay)/(1000 * 3600 * 24)
  for i in [0...diffDays+1] by 1
    result = new Date(oldestDay)
    result.setDate(oldestDay.getDate() + i)
    allDays.push result

  results = {}
  for key of data
    columnList = {}
    for i in [0...names.length]
      name = names[i]
      list = []
      for day in allDays
        if data[key][day]
          list.push data[key][day][i]
        else
          list.push 0
      columnList[name]=list
    results[key]=columnList

  for ele,i in allDays
   allDays[i] = String(ele)

  window.valueDic = results
  window.columnLi = totalName
  window.dateLi = allDays

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
