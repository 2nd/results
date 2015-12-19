'use strict'

locale =
  months: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
  weekdays: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']



dateFilter = 'day'
M0 =
  valueDic: [
    'error$uncaught': 'total': [1,2,3,4,5], 'age':[6, 7,8,9,10]
    'sections$carousel': 'total': [11, 12, 13, 14, 15], 'age':[16, 17, 18, 19, 20]
    'sections$hiring' : 'total': [21, 22, 24, 24, 25], 'age': [26, 27, 28, 29, 30]
  ]
  styleDic: [
    'error$uncaught': 'total': ['Better','Worse','Worse','Better','Worse'], 'age':['Worse', 'Worse','Better','Worse','Better']
    'sections$carousel': 'total': ['Better', 'Worse', 'Better', 'Worse', 'Worse'], 'age':['Better', 'Worse', 'Better', 'Worse', 'Worse']
    'sections$hiring' : 'total': ['Better', 'Worse', 'Worse', 'Worse', 'Better'], 'age': ['Worse', 'Better', 'Worse', 'Worse', 'Worse']
  ]
M1 =
  valueDic: [
    'error$uncaught': 'total': [1,2,3,4,5], 'age':[6, 7,8,9,10]
    'sections$carousel': 'total': [11, 12, 13, 14, 15], 'age':[16, 17, 18, 19, 20]
    'sections$hiring' : 'total': [21, 22, 24, 24, 25], 'age': [26, 27, 28, 29, 30]
  ]
  styleDic: [
    'error$uncaught': 'total': ['Better','Worse','Worse','Better','Worse'], 'age':['Worse', 'Worse','Better','Worse','Better']
    'sections$carousel': 'total': ['Better', 'Worse', 'Better', 'Worse', 'Worse'], 'age':['Better', 'Worse', 'Better', 'Worse', 'Worse']
    'sections$hiring' : 'total': ['Better', 'Worse', 'Worse', 'Worse', 'Better'], 'age': ['Worse', 'Better', 'Worse', 'Worse', 'Worse']
  ]
M2 =
  valueDic: [
    'error$uncaught': 'total': [1,2,3,4,5], 'age':[6, 7,8,9,10]
    'sections$carousel': 'total': [11, 12, 13, 14, 15], 'age':[16, 17, 18, 19, 20]
    'sections$hiring' : 'total': [21, 22, 24, 24, 25], 'age': [26, 27, 28, 29, 30]
  ]
  styleDic: [
    'error$uncaught': 'total': ['Better','Worse','Worse','Better','Worse'], 'age':['Worse', 'Worse','Better','Worse','Better']
    'sections$carousel': 'total': ['Better', 'Worse', 'Better', 'Worse', 'Worse'], 'age':['Better', 'Worse', 'Better', 'Worse', 'Worse']
    'sections$hiring' : 'total': ['Better', 'Worse', 'Worse', 'Worse', 'Better'], 'age': ['Worse', 'Better', 'Worse', 'Worse', 'Worse']
  ]

dateLi = ['2015-12-10T16:00:00.000Z', '2015-12-09T16:00:00.000Z', '2015-12-08T16:00:00.000Z', '2015-12-07T16:00:00.000Z','2015-12-06T16:00:00.000Z']
columnLi = ['total', 'age']

class ResultShow
  constructor: (@ele) ->

  showByMode: () ->
    modeList = ['M0','M1','M2']
    tempIndex = 0
    document.onkeydown = (e) =>
      if e.keyCode == 77
        if(tempIndex == 2)
          tempIndex = 0
        else 
          tempIndex++
        @showTable(modeList,tempIndex) 

  showTable: (modeList,tempIndex)->
    console.log modeList[tempIndex]
    if(modeList[tempIndex] == 'M0')
      valueDic = M0.valueDic
      styleDic = M0.styleDic

      header = ''
      html = ''

      for columnEle,i in columnLi
        header += "<th>" + columnEle

      for dateEle in dateLi
        d = new Date(dateEle)
        day = d.getDay()
        if day > last || i == 0
          html +=
          switch dateFilter
            when 'day'
              '<tr class=header><th>' + locale.months[d.getMonth()] + ' ' + d.getFullYear()  + header
            when 'hour'
              '<tr class=header><th>' + d.getDate() + ' ' + locale.months[d.getMonth()] + ' ' + d.getFullYear()  + header
          index = 0
        last = day
        html += '<tr' + (if index % 2 == 1 then ' class=o' else '') + '><td class=filter>'
        html +=
        switch dateFilter
            when 'day'
              "<span>" + locale.weekdays[day] + ' ' + d.getDate() + '</span>'
            when 'hour'
              "<span>" + d.getHours() + ':00</span>'

        for tempValue,i in valueDic
          for key1 , value1 of tempValue
            keySplit = key1.split("$")
            for keySplitEle in keySplit
              html += '<td>' + keySplitEle
            for keyName,p in columnLi
              valueArray = tempValue[key1].keyname
              for cellValue in valueArray
                html += '<td>' + cellValue
      @ele.innerHTML = html


window.ResultShow = ResultShow