Class geo.Tools Extends %RegisteredObject
{

/// Earth's radius in km
Parameter RADIUSEARTH = 6371;

ClassMethod test()
{
    set l = ##class(geo.model.Line).%New()
    do l.addPoint(##class(geo.model.Point).%New(0.01,0.01))
    do l.addPoint(##class(geo.model.Point).%New(2.01,0.01))
    do l.addPoint(##class(geo.model.Point).%New(2.01,2.01))
    do l.addPoint(##class(geo.model.Point).%New(0.01,2.01))
    do l.addPoint(##class(geo.model.Point).%New(0.01,0.01))
    set polygon = ##class(geo.model.Polygon).%New()
    set polygon.line = l
    set fp = ##class(geo.model.Point).%New(1.01,1.01)
    #; set poly = ##class(Py.Helper).toPyListOrString(polygon.getAsList())
    #; set point = ##class(Py.Helper).toPyListOrString(fp.getAsList())

    set isin = ..PointInPolygon(polygon, fp)
    w isin
}

ClassMethod PointInPolygon(poly As geo.model.Polygon, pt As geo.model.Point) As %Boolean
{
    #; https://stackoverflow.com/questions/36399381/whats-the-fastest-way-of-checking-if-a-point-is-inside-a-polygon-in-python
    #; https://matplotlib.org/stable/api/path_api.html
    #; import numpy as np
    set mp = ##class(%SYS.Python).Import("matplotlib")
    set mpltPath = mp.path
    set polylist = poly.getAsList()
    set poly = ##class(Py.Helper).toPyListOrString(polylist)
    set point = ##class(Py.Helper).toPyListOrString(pt.getAsList())
    zw poly
    set path = mpltPath.Path(poly)
    Return path.contains_point(pt)
}

/// Computes the great-circle distance between two points on a sphere 
/// returns: distance in kilometers 
ClassMethod DistancePointandLine(pt As geo.model.Point, line As geo.model.Line) As %Float
{
    set dist = 0
    for i = 2:1:line.points.Count() {
        set d = ..Distance(line.GetAt(i-1), line.GetAt(i))
        if d>dist set dist = d
    }
    Return dist
}

ClassMethod Distance(p1 As geo.model.Point, p2 As geo.model.Line) As %Float
{
    Set lat1Radianos = (p1.latitude * $ZPI) / 180
    Set lng1Radianos = (p1.longitude * $ZPI) / 180
    Set lat2Radianos = (p2.latitude * $ZPI) / 180
    Set lng2Radianos = (p2.longitude * $ZPI) / 180
    // Haversine formula
    Return ($ZARCCOS((($ZCOS(lat1Radianos) * $ZCOS(lng1Radianos)) * ($ZCOS(lat2Radianos) * $ZCOS(lng2Radianos))) + ($ZCOS(lat1Radianos) * $ZSIN(lng1Radianos) * $ZCOS(lat2Radianos) * $ZSIN(lng2Radianos)) + ($ZSIN(lat1Radianos) * $ZSIN(lat2Radianos))) * ..#RADIUSEARTH)
}

/// Are two points identical -- have the same latitude and longitude values
ClassMethod Identity(p1 As geo.model.Point, p2 As geo.model.Point) As %Boolean
{
    Return (p1.latitude = p2.latitude) && (p1.longitude = p2.longitude)
}

}
