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


window.valueDicTest =
  'error$uncaught': 'total': [10,2,3,4,5], 'avg':[6, 7,8,9,10]
  'sections$carousel': 'total': [20, 12, 13, 14, 15], 'avg':[16, 17, 18, 19, 20]
  'sections$hiring' : 'total': [50, 22, 24, 24, 25], 'avg': [26, 27, 28, 29, 30]

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
      dayCompare = []
      weekCompare = []
      dayStyle = []
      weekStyle =[]
      todayStyle = ['none']
      for i in [0...colArray.length-1] by 1
        tempvalue = (colArray[i] - colArray[i+1])/(colArray[i+1] + 1)  # colArray[i+1]  might be 0
        dayCompare.push(tempvalue)
        dayStyle.push(defineStyle(colKey, tempvalue))
        todayStyle.push('none')
      dayValueDic[regKey][colKey] = dayCompare
      dayStyleDic[regKey][colKey] = dayStyle
      todayStyleDic[regKey][colKey] = todayStyle
      for i in [0...colArray.length-7] by 1
        tempvalue = (colArray[i] - colArray[i+7])/(colArray[i+7]+1)
        weekStyle.push(defineStyle(colKey, tempvalue))
        weekCompare.push(tempvalue)
      weekValueDic[regKey][colKey] = weekCompare
      weekStyleDic[regKey][colKey] = weekStyle
  M0 = {valueDic: inputValueDic, styleDic: todayStyleDic}
  M1 = {valueDic: dayValueDic, styleDic: dayStyleDic}
  M2 = {valueDic: weekValueDic, styleDic: weekStyleDic}
  return [M0, M1, M2]
