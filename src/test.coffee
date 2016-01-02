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

  window.valueDic = results
  window.columnLi = totalName
  window.dateLi = allDays