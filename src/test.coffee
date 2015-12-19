window.build = (sample) ->
  fields = sample.pop()
  date = fields[0]
  filters = []
  key = []
  day = []
  element = []
  name = []
  d = {}
  #console.log fields
  for field,i in fields 
    if field.filter
      filters.push i
    else
      name.push field
  #console.log name
  
  for row in sample
    day.push row[0]
    temp = filters.slice(1)
    if filters.length > 1
      key = ""
      for i in temp
        key += row[filters[i]]+"$"
        key2 = key.substring(0,key.length-1)
    for i in [0...row.length] 
      if i not in temp
        element.push row[i]
    if d[key2]
      d[key2][element[0]] = {}
      d[key2][element[0]] = element.slice(1)
    else
      d[key2] = {}
      d[key2][element[0]] = {}
      d[key2][element[0]] = element.slice(1)
      jcount = element.slice(1)
    element = []
  console.log d
  console.log day

  # sort by days
  Value = {}
  tmp = []
  oldestDay = day.sort()[0]
  latestDay = day.sort()[day.length-1]
  for j in [0...jcount]
    for daytime in [oldestDay...latestDay]
      for k1 in d
        Value[k1] = {}
        if daytime in d[k1].keys()
          tmp.push Value[k1][daytime][j]
        Value[k1].push tmp
  
  




  #console.log day


  # for val,i in filters
  #   if i==0
  #     day.push field[val]
  # for row in sample
  #   for val,i in filters
  #     if i == 0
  #       day.push val
  #     if i == 1
  #       temp = val

  #     key.push row[ind]
  # console.log key






  #   name = field
  #   if field.name
  #     settings[i] = field
  #     name = field.name
  #     zero.parent = i
  #   colNames.push name
  # console.log(colNames)
  # console.log(colNames[0].filter)

     