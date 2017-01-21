from xml.dom import minidom
myList = []
xmldoc = minidom.parse('TrafficSpeed.xml')
itemlist = xmldoc.getElementsByTagName('TrafficSpeedData')
#print(len(itemlist))
#print(itemlist[0].attributes['linkSpeed'].value)
for s in itemlist:
    #myList.append(s.attributes['linkSpeed'].value)
    print(s.attributes['linkSpeed'].value, ' ', s.attributes['linkBorough'].value)

#myList.sort(reverse=True)
#for s in myList:
#    print(s)

















