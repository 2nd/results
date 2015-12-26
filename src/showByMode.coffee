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
    'error$uncaught': 'total': ['Better1','Worse2','Worse3','Better4','Worse5'], 'age':['Worse6', 'Worse7','Better8','Worse9','Better10']
    'sections$carousel': 'total': ['Better11', 'Worse12', 'Better13', 'Worse14', 'Worse15'], 'age':['Better16', 'Worse17', 'Better18', 'Worse19', 'Worse20']
    'sections$hiring' : 'total': ['Better21', 'Worse22', 'Worse23', 'Worse24', 'Better25'], 'age': ['Worse26', 'Better27', 'Worse28', 'Worse29', 'Worse30']
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

  showByMode: (sample) ->
    modeList = ['M0','M1','M2']
    tempIndex = 0
    document.onkeydown = (e) =>
      if e.keyCode == 77
        if(tempIndex == 2)
          tempIndex = 0
        else 
          tempIndex++
        @showTable(sample,modeList,tempIndex) 

  showTable: (sample,modeList,tempIndex)->
    fields = sample.pop()
    html = ''
    console.log modeList[tempIndex]
    #console.log M0.valueDic
    valueDic = M0.valueDic[0]
    styleDic = M0.styleDic[0]
    resultsList = new Array()
    console.log resultsList
    if(modeList[tempIndex] == 'M0')
      
      for dateEle in dateLi
        resultsListRow = new Array()
        resultsListRow.push(dateEle)
        for key1,value1 of valueDic

          keySplit = key1.split("$")
          for keySplitEle in keySplit
            html += keySplitEle + "   "
            resultsListRow.push(keySplitEle)
            #console.log 'html:'+html
          for key2 ,value2 of value1
            #console.log 'key2:'+key2
            for colELe,p in columnLi
              #console.log 'colELe:'+colELe
              if colELe == key2
                for cellValue,i in value2
                  tempStyle = styleDic[key1][key2][i]
                  tempCellList = new Array()
                  tempCellList.push(cellValue)
                  tempCellList.push(tempStyle)
                  resultsListRow.push(tempCellList)
                  html += "   "+cellValue + "style: " + tempStyle + "   "
                  #console.log 'colELe:'+colELe
        console.log 'resultsListRow:   '+resultsListRow[0]
        console.log 'resultsListRow:   '+resultsListRow[1]
        console.log 'resultsListRow:   '+resultsListRow[2]
        console.log 'resultsListRow:   '+resultsListRow[3]
        console.log 'resultsListRow:   '+resultsListRow[4]


        resultsList.push(resultsListRow)

    #console.log 'resultsList:   '+resultsList

    @ele.innerHTML = resultsList


window.ResultShow = ResultShow