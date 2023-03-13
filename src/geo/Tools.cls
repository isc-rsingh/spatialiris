Class geo.Tools Extends %RegisteredObject
{

/// Earth's radius in km
Parameter RADIUSEARTH = 6371;

ClassMethod PointInPolygon(poly As geo.model.Polygon, pt As geo.model.Point) As %Boolean
{
    #; https://stackoverflow.com/questions/36399381/whats-the-fastest-way-of-checking-if-a-point-is-inside-a-polygon-in-python
    #; https://matplotlib.org/stable/api/path_api.html
    #; import numpy as np
    set mp = ##class(%SYS.Python).Import("matplotlib")
    set mpltPath = mp.path
    set polylist = poly.asList()
    set nothing = ##class(Py.Helper).toPyListOrString(polylist,.poly2)
    zw poly2
    set point = ##class(Py.Helper).toPyListOrString(pt.asList())
    set path = ..invoke(mpltPath,poly2)
    Return path."contains_point"(point)
}

ClassMethod invoke(ByRef mpltPath As %SYS.Python, ByRef poly2) As %SYS.Python [ Language = python ]
{
    return mpltPath.Path(poly2)
}

/// Computes the great-circle distance between a point and the closest point to it on a line
/// returns: distance in kilometers 
ClassMethod DistancePointandLine(pt As geo.model.Point, line As geo.model.LineString) As %Float
{
    set dist = 0
    for i = 2:1:line.points.Count() {
        set d = ..Distance(line.GetAt(i-1), line.GetAt(i))
        if d>dist set dist = d
    }
    Return dist
}

/// Computes the great-circle distance between two points on a sphere 
/// returns: distance in kilometers 
ClassMethod Distance(p1 As geo.model.Point, p2 As geo.model.Point) As %Float
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
