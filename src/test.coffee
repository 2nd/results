window.build = (sample) ->

  fields = sample.pop()
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

  for row in sample
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




