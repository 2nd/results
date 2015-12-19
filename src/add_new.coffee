window.valueDic =
  'error$uncaught': 'total': [10,2,3,4,5], 'avg':[6, 7,8,9,10]
  'sections$carousel': 'total': [20, 12, 13, 14, 15], 'avg':[16, 17, 18, 19, 20]
  'sections$hiring' : 'total': [50, 22, 24, 24, 25], 'avg': [26, 27, 28, 29, 30]
dateLi = ['2015-12-10T16:00:00.000Z', '2015-12-09T16:00:00.000Z', '2015-12-08T16:00:00.000Z', '2015-12-07T16:00:00.000Z', '2015-12-06T16:00:00.000Z']
columnLi = ['total', 'avg']

largerBetter = ['total']
littleBetter = ['avg', 'stddev', '95', '99']
defineStyle = (column, value) ->
  if largerBetter.indexOf(column) != -1
    if value > 0
      return 'Better'
  else
    if value < 0
      return 'Better'
  return 'Worse' # ['Worse', 'Better', 'normal']

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
      todayStyle = ['normal']
      for i in [0...colArray.length-1] by 1
        tempvalue = (colArray[i] - colArray[i+1])/(colArray[i+1] + 1)  # colArray[i+1]  might be 0
        dayCompare.push(tempvalue)
        dayStyle.push(defineStyle(colKey, tempvalue))
        todayStyle.push('normal')
      dayValueDic[regKey][colKey] = dayCompare
      dayStyleDic[regKey][colKey] = dayStyle
      todayStyleDic[regKey][colKey] = todayStyle
      for i in [0...colArray.length-7] by 1
        tempvalue = (colArry[i] - colArry[i+7])/(colArry[i+7]+1)
        weekStyle.push(defineStyle(colKey, tempvalue))
        weekCompare.push(tempvalue)
      weekValueDic[regKey][colKey] = weekCompare
      weekStyleDic[regKey][colKey] = weekStyle
  M0 = {valueDic:inputValueDic, styleDic: todayStyleDic}
  M1 = {valueDic: dayValueDic, styleDic: dayStyleDic}
  M2 = {valueDic: weekValueDic, styleDic: weekStyleDic}
  return [M0, M1, M2]
