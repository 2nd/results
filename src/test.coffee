getRowKey = (row, dataOffset) ->
  return '*' if dataOffset == 1 # only a date
  key = row[1]
  key += '$' + row[i] for i in [2...dataOffset]
  return key

window.build = (rows) ->
  fields = rows[rows.length-1]
  dataOffset = fields.findIndex (f) -> !f.filter

  columns = fields.slice(dataOffset)
  firstDay = new Date(rows[0][0]).getTime()
  lastDay = new Date(rows[rows.length-2][0]).getTime()
  numberOfDays = (firstDay - lastDay)/(1000 * 3600 * 24) + 1

  # group all our data by unique row keys. A row key is the combination
  # of a rows filters (minus the date).
  groups = {}
  for i in [0...rows.length-1] by 1
    row = rows[i]
    key = getRowKey(row, dataOffset)

    group = groups[key]
    unless group?
      group = groups[key] = {}
      group[column] = new Array(numberOfDays).fill(0) for column in columns

    index = (firstDay - new Date(row[0]).getTime()) / 86400000
    group[column][index] = row[j + dataOffset] for column, j in columns

  return {fields: fields, groups: groups, firstDay: firstDay, lastDay: lastDay, dataOffset: dataOffset, numberOfDays: numberOfDays}


# the modes we support, comparing a day against OFFSET days ago
offsets = [0, 1, 7]
getStyle = (column, value) ->
  # todo this depends on the report
  return 'better' if value > 0
  return 'worse' if value < 0
  return 'none'

# given a list of values, the % changed against the value at the specified offset
calculate = (offset, values) ->
  changes = new Array(values.length)
  for value, i in values
    if offset == 0
      changes[i] = {value: value, style: 'none'}
    else
      previous = values[i + offset] || value
      diff = (value - previous) / previous * 100
      changes[i] = {value: diff.toFixed(2), style: getStyle(null, diff)}
  return changes

window.calculateTrend = (data) ->
  modes = new Array(offsets.length)
  for offset, i in offsets
    mode = modes[i] = {}
    for key, group of data.groups
      keyed = mode[key] = {}
      keyed[column] = calculate(offset, values) for column, values of group
  return modes


