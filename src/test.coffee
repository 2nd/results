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
      data[key][time] = {}
      data[key][time] = element.slice(1)
    else
      data[key] = {}
      data[key][time] = {}
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

  window.valueDic = results
  window.columnLi = totalName
  window.dateLi = allDays









window.calcPrectage = (valueDic) ->
  valuePrecDay = JSON.parse(JSON.stringify(valueDic))
  valuePrecWeek = JSON.parse(JSON.stringify(valueDic))
  for key of valueDic
    for column of valueDic[key]
      for i in [0...valueDic[key][column].length].reverse()
        today = valuePrecDay[key][column][i]
        yersterday = valuePrecDay[key][column][i-1]
        lastWeek = valuePrecDay[key][column][i-7]
        if yersterday
          valuePrecDay[key][column][i] = (today - yersterday) / yersterday
        else
          valuePrecDay[key][column][i] = "na"
        if lastWeek
          valuePrecWeek[key][column][i] = (today - lastWeek) / lastWeek
        else
          valuePrecWeek[key][column][i] = "na"
  window.valuePrecDay = valuePrecDay
  window.valuePrecWeek = valuePrecWeek


window.assignStyle = (sample, valuePrecDay, valuePrecWeek, columnLi, dateLi) ->
  largerBetter = ["total", "users", "sessions", "avg sec¹", "avg ms","95 ms","99 ms", "avg sec", "new"]
  smallerBetter = ["bounce", "stddev", "95 sec", "99 sec","stddev¹", "avg", "95", "99" ]
  valuePrecDayStyle = JSON.parse(JSON.stringify(sample))
  valuePrecWeekStyle = JSON.parse(JSON.stringify(sample))
  for ele,i in dateLi
    dateLi[i] = String(ele)
  filters = columnLi.pop()
  for row, rowInd in sample.slice(0,sample.length-1)
    day = String(new Date(row[0]))
    key = ''
    if filters == 1
      key = "undefine"
    else
      for i in [1...filters]
        key += row[i]+"$"
      key = key.substring(0,key.length-1)

    for ind in [filters...row.length]
      valuePrecDayStyle[rowInd][ind] = [valuePrecDay[key][columnLi[ind]][dateLi.indexOf(day)]]
      if (columnLi[ind] in largerBetter and valuePrecDay[key][columnLi[ind]][dateLi.indexOf(day)] > 0) or (columnLi[ind] in smallerBetter and valuePrecDay[key][columnLi[ind]][dateLi.indexOf(day)] < 0)
        valuePrecDayStyle[rowInd][ind].push "better"
      else if (columnLi[ind] in largerBetter and valuePrecDay[key][columnLi[ind]][dateLi.indexOf(day)] < 0) or (columnLi[ind] in smallerBetter and valuePrecDay[key][columnLi[ind]][dateLi.indexOf(day)] > 0)
        valuePrecDayStyle[rowInd][ind].push "worse"
      else
        valuePrecDayStyle[rowInd][ind].push "none"

      valuePrecWeekStyle[rowInd][ind] = [valuePrecWeek[key][columnLi[ind]][dateLi.indexOf(day)]]
      if (columnLi[ind] in largerBetter and valuePrecWeek[key][columnLi[ind]][dateLi.indexOf(day)] > 0) or (columnLi[ind] in smallerBetter and valuePrecWeek[key][columnLi[ind]][dateLi.indexOf(day)] < 0)
        valuePrecWeekStyle[rowInd][ind].push "better"
      else if (columnLi[ind] in largerBetter and valuePrecWeek[key][columnLi[ind]][dateLi.indexOf(day)] < 0) or (columnLi[ind] in smallerBetter and valuePrecWeek[key][columnLi[ind]][dateLi.indexOf(day)] > 0)
        valuePrecWeekStyle[rowInd][ind].push "worse"
      else
        valuePrecWeekStyle[rowInd][ind].push "none"

  window.valuePrecDayStyle = valuePrecDayStyle
  window.valuePrecWeekStyle = valuePrecWeekStyle
  window.filters = filters



