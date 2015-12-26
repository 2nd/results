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
  console.log sample.length
  for row, rowInd in sample.slice(0,sample.length-1)
    console.log rowInd
    console.log valuePrecDayStyle[sample.length-1]
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






