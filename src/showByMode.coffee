'use strict'

locale =
  months: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
  weekdays: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
dateFilter = 'day'


class ResultShow
  constructor: (@ele) ->

  showByMode: (rows) ->
    list = ['M0','M1','M2']
    modeIndex = 0
    @showTable(rows,modeIndex)

    document.onkeydown = (e) =>
      return unless e.keyCode == 77
      modeIndex++
      modeIndex = 0 if modeIndex == list.length
      @showTable(rows,modeIndex)

  showTable: (rows,modeIndex)->

    fields = rows[rows.length - 1]
    #console.log 'fields:   '+ fields
    html = ''
    #console.log index
    valuesAfterCal = data[modeIndex].valueDic

    #console.log 'valuesAfterCal:  '+ valuesAfterCal
    stylesAfterCal = data[modeIndex].styleDic
    #console.log 'stylesAfterCal:  '+ stylesAfterCal
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
      break unless i < rows.length - 1
      d = new Date(row[0])
      dayIndex = dateLi.indexOf(String(d))
      console.log 'dayIndex:     '+dayIndex
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
        console.log 'i:   '+i

        value = row[i]
        console.log 'value:   '+value
        columnIndex = i
        console.log 'columnIndex:   '+columnIndex
        columnKey = columnLi[columnIndex]
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
            html += value
            # for keyAfterCal , valueAfterCal of valuesAfterCal
            #   #console.log "keyAfterCal:" + keyAfterCal + "currentKeys: " + currentKeys
            #   if keyAfterCal == currentKeys
            #     console.log 'columnKey:' + columnKey

            #     #console.log 'valueAfterCal.columnKey.length:' + valueAfterCal.columnKey.length
            #     for element in valueAfterCal
            #       console.log 'element in valueAfterCal:' + element
            #     html += '<td class='+stylesAfterCal.keyAfterCal[dayIndex]+'>' + valueAfterCal.columnKey[dayIndex]
            #     break;
        else
            #console.log 'now is the else settings case:' + value
            for keyAfterCal , valueAfterCal of valuesAfterCal
              #console.log "keyAfterCal:" + keyAfterCal + "currentKeys: " + currentKeys
              if keyAfterCal == currentKeys
                # console.log 'keyAfterCal:' + keyAfterCal
                # console.log 'columnKey:' + columnKey
                # console.log 'stylesAfterCal:' + stylesAfterCal
                # console.log 'stylesAfterCal.keyAfterCal:' + stylesAfterCal[keyAfterCal]

                # console.log 'stylesAfterCal.keyAfterCal[columnKey]  '+stylesAfterCal[keyAfterCal][columnKey]
                if modeIndex == 0
                  valueToShow = valueAfterCal[columnKey][dayIndex]
                else
                    console.log "valueAfterCal[columnKey][dayIndex]: "+valueAfterCal[columnKey][dayIndex]
                    if valueAfterCal[columnKey][dayIndex].toString() != 'na'
                      valueToShow = valueAfterCal[columnKey][dayIndex] * 100
                      if valueAfterCal[columnKey][dayIndex] <= 0
                        if valueToShow > -10
                          valueToShow = valueToShow.toString()[0..3] + "%"
                        else
                          valueToShow = valueToShow.toString()[0..4] + "%"
                      else
                        if valueToShow < 10
                          valueToShow = valueToShow.toString()[0..2] + "%"
                        else
                          valueToShow = valueToShow.toString()[0..3] + "%"
                    else
                      valueToShow = NaN
                if stylesAfterCal[keyAfterCal][columnKey][dayIndex] == 'better'
                  html += '<td class='+stylesAfterCal[keyAfterCal][columnKey][dayIndex]+'>' + valueToShow;
                else if stylesAfterCal[keyAfterCal][columnKey][dayIndex] == 'worse'
                  html += '<td class='+stylesAfterCal[keyAfterCal][columnKey][dayIndex]+'>' + valueToShow;
                else
                  html += '<td class='+stylesAfterCal[keyAfterCal][columnKey][dayIndex]+'>' + valueToShow
                #   if valueKeyAfterCal == columnKey
                #     html += '<td class='+stylesAfterCal.keyAfterCal[dayIndex]+'>' + valueAfterCal[columnKey][dayIndex]
                #     break
                break

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
