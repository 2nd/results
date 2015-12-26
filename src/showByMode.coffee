'use strict'

locale =
  months: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
  weekdays: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']



dateFilter = 'day'
M0 =
  valueDic: 
    'error$uncaught': 'total': [1,2,3,4,5], 'age':[6, 7,8,9,10]
    'sections$carousel': 'total': [11, 12, 13, 14, 15], 'age':[16, 17, 18, 19, 20]
    'sections$hiring' : 'total': [21, 22, 24, 24, 25], 'age': [26, 27, 28, 29, 30]
  
  styleDic: 
    'error$uncaught': 'total': ['Better1','Worse2','Worse3','Better4','Worse5'], 'age':['Worse6', 'Worse7','Better8','Worse9','Better10']
    'sections$carousel': 'total': ['Better11', 'Worse12', 'Better13', 'Worse14', 'Worse15'], 'age':['Better16', 'Worse17', 'Better18', 'Worse19', 'Worse20']
    'sections$hiring' : 'total': ['Better21', 'Worse22', 'Worse23', 'Worse24', 'Better25'], 'age': ['Worse26', 'Better27', 'Worse28', 'Worse29', 'Worse30']
  
M1 =
  valueDic: 
    'error$uncaught': 'total': [1,2,3,4,5], 'age':[6, 7,8,9,10]
    'sections$carousel': 'total': [11, 12, 13, 14, 15], 'age':[16, 17, 18, 19, 20]
    'sections$hiring' : 'total': [21, 22, 24, 24, 25], 'age': [26, 27, 28, 29, 30]
  
  styleDic: 
    'error$uncaught': 'total': ['Better','Worse','Worse','Better','Worse'], 'age':['Worse', 'Worse','Better','Worse','Better']
    'sections$carousel': 'total': ['Better', 'Worse', 'Better', 'Worse', 'Worse'], 'age':['Better', 'Worse', 'Better', 'Worse', 'Worse']
    'sections$hiring' : 'total': ['Better', 'Worse', 'Worse', 'Worse', 'Better'], 'age': ['Worse', 'Better', 'Worse', 'Worse', 'Worse']
  
M2 =
  valueDic: 
    'error$uncaught': 'total': [1,2,3,4,5], 'age':[6, 7,8,9,10]
    'sections$carousel': 'total': [11, 12, 13, 14, 15], 'age':[16, 17, 18, 19, 20]
    'sections$hiring' : 'total': [21, 22, 24, 24, 25], 'age': [26, 27, 28, 29, 30]
  
  styleDic: 
    'error$uncaught': 'total': ['Better','Worse','Worse','Better','Worse'], 'age':['Worse', 'Worse','Better','Worse','Better']
    'sections$carousel': 'total': ['Better', 'Worse', 'Better', 'Worse', 'Worse'], 'age':['Better', 'Worse', 'Better', 'Worse', 'Worse']
    'sections$hiring' : 'total': ['Better', 'Worse', 'Worse', 'Worse', 'Better'], 'age': ['Worse', 'Better', 'Worse', 'Worse', 'Worse']
data = [M0,M1,M2] 
dateLi = ['2015-12-10T16:00:00.000Z', '2015-12-09T16:00:00.000Z', '2015-12-08T16:00:00.000Z', '2015-12-07T16:00:00.000Z','2015-12-06T16:00:00.000Z']
columnLi = ['date', 'type','name','total','avg','stddev','95','99',3]


class ResultShow
  constructor: (@ele) ->

  showByMode: (rows) ->
    list = ['M0','M1','M2']
    index = 0
    document.onkeydown = (e) =>
      return unless e.keyCode == 77
      index++
      index = 0 if index == list.length
      @showTable(rows,index)

  showTable: (rows,index)->

    fields = rows[rows.length - 1]
    console.log 'fields:   '+ fields
    html = ''
    console.log index
    valuesAfterCal = data[index].valueDic
    #console.log values
    stylesAfterCal = data[index].styleDic
    #console.log fields
    zero = fields[0]

    header = ''
    settings = {0: zero}
    for i in [1...fields.length] by 1
      field = fields[i]
      name = field
      if field.name
        settings[i] = field
        name = field.name
        zero.parent = i
      header += "<th>" + name

    html = ''
    last = 0
    index = 0
    for row, i in rows
      d = new Date(row[0])
      dayIndex = dateLi.indexOf(row[0])
      day = d.getDay()
      if day > last ||  i == 0
        html +=
        switch zero.filter
          when 'day'
            '<tr class=header><th>' + locale.months[d.getMonth()] + ' ' + d.getFullYear()  + header
          when 'hour'
            '<tr class=header><th>' + d.getDate() + ' ' + locale.months[d.getMonth()] + ' ' + d.getFullYear()  + header

        index = 0
      last = day

      html += '<tr' + (if index % 2 == 1 then ' class=o' else '') + '><td class=filter>'
      html +=
      switch zero.filter
        when 'day'
          "<span>" + locale.weekdays[day] + ' ' + d.getDate() + '</span>'
        when 'hour'
          "<span>" + d.getHours() + ':00</span>'


      for i in [1...row.length]
        value = row[i]
        columnKey = columnLi[i-1]
        console.log 'columnKey:' + columnKey

        if i == 1
          currentKeys = ''
        if s = settings[i]
          html += "<td#{@seal(s, true)}>"
          if s.filter

            #console.log 'now is the if s.filter case:' + value
            if currentKeys == ''
              currentKeys += value
            else
              currentKeys += '$'+value
            #console.log "currentKeys: " + currentKeys
            html += '<span>' + value + '</span>'
          else
            for keyAfterCal , valueAfterCal of valuesAfterCal
              #console.log "keyAfterCal:" + keyAfterCal + "currentKeys: " + currentKeys
              if keyAfterCal == currentKeys
                console.log 'valueAfterCal.columnKey:' + valueAfterCal.columnKey
                html += '<td class='+stylesAfterCal.keyAfterCal[dayIndex]+'>' + valueAfterCal.columnKey[dayIndex]
                break;
        else
            #console.log 'now is the else settings case:' + value
            for keyAfterCal , valueAfterCal of valuesAfterCal
              #console.log "keyAfterCal:" + keyAfterCal + "currentKeys: " + currentKeys
              if keyAfterCal == currentKeys
                console.log 'columnKey:' + columnKey
                console.log 'valueAfterCal.columnKey:' + valueAfterCal.columnKey
                html += '<td class='+stylesAfterCal.keyAfterCal[dayIndex]+'>' + valueAfterCal.columnKey[dayIndex]
                break;

      index++

    @settings = settings
    @ele.classes('-focus')
    @ele.innerHTML = html
    @cells = $(@ele, 'td')
    @fields = fields.length
    null

  seal: (settings, data) ->
    return '' unless settings?
    cls = ''
    attributes = ''

    cls += 'left' if settings.align == 'left'
    cls += ' filter' if data && settings.filter
    attributes += ' class="' + cls + '"' if cls.length != 0
    attributes








    # resultsList = new Array()
    # console.log resultsList
    # if(modeList[tempIndex] == 'M0')
      
    #   for dateEle in dateLi
    #     resultsListRow = new Array()
    #     resultsListRow.push(dateEle)
    #     for key1,value1 of valueDic

    #       keySplit = key1.split("$")
    #       for keySplitEle in keySplit
    #         html += keySplitEle + "   "
    #         resultsListRow.push(keySplitEle)
    #         #console.log 'html:'+html
    #       for key2 ,value2 of value1
    #         #console.log 'key2:'+key2
    #         for colELe,p in columnLi
    #           #console.log 'colELe:'+colELe
    #           if colELe == key2
    #             for cellValue,i in value2
    #               tempStyle = styleDic[key1][key2][i]
    #               tempCellList = new Array()
    #               tempCellList.push(cellValue)
    #               tempCellList.push(tempStyle)
    #               resultsListRow.push(tempCellList)
    #               html += "   "+cellValue + "style: " + tempStyle + "   "
    #               #console.log 'colELe:'+colELe



    #     resultsList.push(resultsListRow)
    #   resultsList.push(fields)
    #   console.log 'resultsList:   '+resultsList
    #   newResults = new window.Results(document.getElementById('results'));
    #   newResults.show(resultsList)
            #console.log 'rsultsList:   '+resultsList

    #@ele.innerHTML = resultsList


window.ResultShow = ResultShow