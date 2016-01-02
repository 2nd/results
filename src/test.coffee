getRowKey = (row, dataOffset) ->
  return 'undefined' if dataOffset == 1 # only a date
  key = row[1]
  key += '$' + row[i] for i in [2...dataOffset]
  return key

window.build = (rows) ->
  dataOffset = 0
  fields = rows[rows.length-1]
  columns = new Array(fields.length)

  # get a list of all column names, and figure our where the data starts (and the filters stop)
  for field,i in fields
    if field.filter
      columns[i] = field.name
    else
      dataOffset = i if dataOffset == 0
      columns[i] = field

  # group all our data by unique row keys, by date. A row key is the combination
  # of a rows filters (minus the date)
  groups = {}
  for i in [0...rows.length-1] by 1
    row = rows[i]
    time = new Date(row[0]).getTime()
    key = getRowKey(row, dataOffset)

    group = groups[key]
    group = groups[key] = {} unless group?
    group[time] = row

  # some data might have not have entries for a given day. Let's get a list of
  # all days so that we can later fill the missing ones with 0.
  newestDay = new Date(rows[0][0]).getTime()
  oldestDay = new Date(rows[rows.length-2][0]).getTime()
  numberOfDays = (newestDay - oldestDay)/(1000 * 3600 * 24)
  days = (oldestDay + i * 86400000 for i in [0..numberOfDays] by 1)

  # rotate the data so that it's organized by column (but still grouped by key)
  # so that data['errors$api']['total'] is an array where the first element
  # is the total number of api errors which happened on the latest day
  data = {}
  for key, group of groups
    data[key] = values = {}
    for i in [dataOffset...columns.length]
      name = columns[i]
      values[name] = (group[day]?[i] || 0 for day in days)

  return {days: days, data: data, columns: columns, filterCount: dataOffset}



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
