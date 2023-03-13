/// Model of a geospatial area, described as a rsingh.spatialiris.geo.LineString where the area > 0 (i.e. the line has more than 2 Points), 
/// and the first and last Points are the same.
Class rsingh.spatialiris.geo.Polygon Extends rsingh.spatialiris.geo.AbstractGeometry
{

Property line As rsingh.spatialiris.geo.LineString;

Method intersects(geom As rsingh.spatialiris.geo.AbstractGeometry) As %Boolean
{
    set mp = ##class(%SYS.Python).Import("matplotlib")
    set mpltPath = mp.path
    set polylist = ..line.asList()
    set nothing = ##class(Py.Helper).toPyListOrString(polylist,.poly2)
    set path = ##class(rsingh.spatialiris.Tools).invoke(mpltPath,.poly2)

    if $CLASSNAME(geom) = "rsingh.spatialiris.geo.Point" {
        Return ..contains(geom)
    } else {
        set linelist = geom.asList()
        set nothing = ##class(Py.Helper).toPyListOrString(linelist,.line)
        set linepath = ##class(rsingh.spatialiris.Tools).invoke(mpltPath,.line)
        Return path."intersects_path"(linepath)
    }
}

/// Is this rsingh.spatialiris.geo.Polygon within geom?
Method within(geom As rsingh.spatialiris.geo.Polygon) As %Boolean
{
    set mp = ##class(%SYS.Python).Import("matplotlib")
    set mpltPath = mp.path
    set polylist = geom.line.asList()
    set nothing = ##class(Py.Helper).toPyListOrString(polylist,.poly2)
    set otherpath = ##class(rsingh.spatialiris.Tools).invoke(mpltPath,.poly2)

    set polylist = ..line.asList()
    set nothing = ##class(Py.Helper).toPyListOrString(polylist,.poly2)
    set mypath = ##class(rsingh.spatialiris.Tools).invoke(mpltPath,.poly2)

    Return otherpath."contains_path"(mypath)
}

/// Is geom contained by this rsingh.spatialiris.geo.Polygon?
/// Polygon contains geom if and only if no points of geom lie in the exterior of Polygon, 
/// and at least one point of the interior of geom lies in the interior of Polygon.
Method contains(geom As rsingh.spatialiris.geo.AbstractGeometry) As %Boolean
{
    set mp = ##class(%SYS.Python).Import("matplotlib")
    set mpltPath = mp.path
    set polylist = ..line.asList()
    set nothing = ##class(Py.Helper).toPyListOrString(polylist,.poly2)
    set path = ##class(rsingh.spatialiris.Tools).invoke(mpltPath,.poly2)

    if $CLASSNAME(geom) = "rsingh.spatialiris.geo.Point" {
        set pointlist = geom.asList()
        set nothing = ##class(Py.Helper).toPyListOrString(pointlist,.point)
        Return path."contains_point"(point)
    } else {
        set linelist = geom.asList()
        set nothing = ##class(Py.Helper).toPyListOrString(linelist,.line)
        set linepath = ##class(rsingh.spatialiris.Tools).invoke(mpltPath,.line)
        Return path."contains_path"(linepath)
    }
    Return 0
}

Method isClosed() As %Boolean
{
    Return ..isValid()
}

/// Checks to see if conditions are true for this line to be a polygon
Method isValid() As %Boolean
{
    if ..line.Size < 3 Return 0
    Return ##class(rsingh.spatialiris.Tools).Identity(..line.GetAt(1), ..line.GetAt(..line.Size))
}

/// Returns the geometry as a $LIST
Method asList()
{
    Return ..line.asList()
}

/// Returns a geometry as a GeoJSON "Polygon"
Method asGeoJSON() As %String
{
    set cs = []
    for i = 1:1:..line.points.Count() {
        do cs.%Push([(..line.points.GetAt(i).longitude),(..line.points.GetAt(i).latitude)])
    }

    set geom = {"coordinates": [(cs)], "type": "Polygon"}
    set p = {"type": "Feature", "geometry": (geom)}

    Return p.%ToJSON()
}

/// Returns the OGC Well-Known Text (WKT) representation of the polygon
Method asText() As %String
{
    set t = "POLYGON (("
    for i = 1:1:..line.points.Count() {
        set t = t_..line.points.GetAt(i).longitude_" "_..line.points.GetAt(i).latitude_","
    }
    set t = $EXTRACT(t,1,*-1)
    Return t_"))"
}

/// Number of vertices comprising this Polygon
Method numPoints() As %Integer
{
    Return ..line.points.Count()
}

/// Returns the type of the geometry as the string 'POLYGON'
ClassMethod geometryType() As %String
{
    Return "POLYGON"
}

/// Return the topological dimension of this Geometry object, which is 2, per OGC SPEC s2.1.1.1
ClassMethod dimension() As %Integer
{
    Return "2"
}

Storage Default
{
<Data name="PolygonState">
<Value name="1">
<Value>line</Value>
</Value>
</Data>
<State>PolygonState</State>
<StreamLocation>^rsingh.spatialiris.geo.PolygonS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
