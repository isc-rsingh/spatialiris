/// Model of a geospatial linear feature
Class rsingh.spatialiris.geo.LineString Extends AbstractGeometry
{

Property points As list Of rsingh.spatialiris.geo.Point;

/// Returns the first point of the line. Returns NULL if line has no points.
Method startPoint() As rsingh.spatialiris.geo.Point
{
    if ..points.Count()<1 Return
    return ..points.GetAt(1)
}

/// Returns the last point of the line. Returns NULL if line has no points.
Method endPoint() As rsingh.spatialiris.geo.Point
{
    if ..points.Count()<1 Return
    return ..points.GetAt(..points.Count())
}

Method addPoint(pt As rsingh.spatialiris.geo.Point) As %Status
{
    do ..points.Insert(pt)
}

Method addPointFromCoords(lon As %Float, lat As %Float) As %Status
{
    do ..points.Insert(##class(rsingh.spatialiris.geo.Point).%New(lon, lat))
}

/// Returns the geometry as a $LIST
Method asList()
{
    for i = 1:1:..points.Count() {
        set $list(pointslist,i) = ..points.GetAt(i).asList()
    }
    Return pointslist
}

/// Returns a geometry as a GeoJSON "LineString"
Method asGeoJSON() As %String
{
    set cs = []
    for i = 1:1:..points.Count() {
        do cs.%Push([(..points.GetAt(i).longitude),(..points.GetAt(i).latitude)])
    }
    set geom = {"coordinates": (cs), "type": "LineString"}
    set p = {"type": "Feature", "geometry": (geom)}

    Return p.%ToJSON()
}

/// Returns the OGC Well-Known Text (WKT) representation of the line
Method asText() As %String
{
    set t = "LINESTRING ("
    for i = 1:1:..points.Count() {
        set t = t_..points.GetAt(i).longitude_" "_..points.GetAt(i).latitude_","
    }
    set t = $EXTRACT(t,1,*-1)
    Return t_")"
}

/// Returns TRUE if the LINESTRING's start and end points are coincident.
Method isClosed() As %String
{
    Return ##class(rsingh.spatialiris.Tools).Identity(..startPoint(), ..endPoint())
}

/// Number of vertices comprising this LineString
Method numPoints() As %Integer
{
    Return ..points.Count()
}

/// Returns the type of the geometry as the string 'LINESTRING'
ClassMethod geometryType() As %String
{
    Return "LINESTRING"
}

// Return the topological dimension of this Geometry object, which is 1, per OGC SPEC s2.1.1.1

ClassMethod dimension() As %Integer
{
    Return "1"
}

Storage Default
{
<Data name="LineStringState">
<Subscript>"LineString"</Subscript>
<Value name="1">
<Value>points</Value>
</Value>
</Data>
<State>LineStringState</State>
<Type>%Storage.Serial</Type>
}

}
