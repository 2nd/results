getRowKey = (row, dataOffset) ->
  return 'undefined' if dataOffset == 1 # only a date
  key = row[1]
  key += '$' + row[i] for i in [2...dataOffset]
  return key

window.build = (rows) ->
  dataOffset = 0
  fields = rows[rows.length-1]

  # figure our where the data starts (and the filters stop)
  for field,i in fields
    continue if field.filter
    dataOffset = i
    break

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
    for i in [dataOffset...fields.length]
      name = fields[i]
      values[name] = (group[day]?[i] || 0 for day in days)

  return {
    days: days
    data: data
    fields: fields
    keys: Object.keys(data)
    filterCount: dataOffset
    dataColumns: fields.slice(dataOffset)
  }


# the modes we support, comparing a day against OFFSET days ago
offsets = [0, 1, 7]

defineStyle = (column, value) ->
  # todo: we discovered that this isn't as obvious as we thought
  'none'

# given a list of values, the % changed against the value at the specified offset
calculate = (offset, values) ->
  changes = new Array(values.length)
  for value, i in values
    if offset == 0
      changes[i] = {value: value, style: 'none'}
    else
      previous = values[i + offset] || value
      diff = (value - previous) / previous * 100
      changes[i] = {value: diff, style: 'none'}
  return changes

window.calculateTrend = (input) ->
  modes = new Array(offsets.length)
  for offset, i in offsets
    mode = modes[i] = {}
    for key, group of input.data
      keyed = mode[key] = {}
      keyed[column] = calculate(offset, group[column]) for column in input.dataColumns
  return modes
