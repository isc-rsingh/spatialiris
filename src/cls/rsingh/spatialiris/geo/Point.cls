/// Model of a geospatial location
Class rsingh.spatialiris.geo.Point Extends AbstractGeometry
{

Property latitude As %Float(MAXVAL = 90.0, MINVAL = -90.0, SCALE = 6);

Property longitude As %Float(MAXVAL = 180.0, MINVAL = -180.0, SCALE = 6);

/// Is this point within the circle defined by input params 
/// radius: measured in kilometers
Method insideCircle(centerX As %Float, centerY As %Float, radius As %Float) As %Boolean
{
    set cpoint = ##class(rsingh.spatialiris.geo.Point).%New(centerX, centerY)
    Return '(..distance(cpoint)>radius)
}

/// Computes the great-circle distance between two points on a sphere 
/// returns: distance in kilometers 
Method distance(p1 As rsingh.spatialiris.geo.Point) As %Float
{
    Set lat1Radianos = (p1.latitude * $ZPI) / 180
    Set lng1Radianos = (p1.longitude * $ZPI) / 180
    Set lat2Radianos = (..latitude * $ZPI) / 180
    Set lng2Radianos = (..longitude * $ZPI) / 180
    // Haversine formula
    Return ($ZARCCOS((($ZCOS(lat1Radianos) * $ZCOS(lng1Radianos)) * ($ZCOS(lat2Radianos) * $ZCOS(lng2Radianos))) + ($ZCOS(lat1Radianos) * $ZSIN(lng1Radianos) * $ZCOS(lat2Radianos) * $ZSIN(lng2Radianos)) + ($ZSIN(lat1Radianos) * $ZSIN(lat2Radianos))) * (##class(rsingh.spatialiris.Tools).#RADIUSEARTH))
}

Method %OnNew(lon As %Float, lat As %Float) As %Status [ Private, ServerOnly = 1 ]
{
    set ..latitude = lat
    set ..longitude = lon
    Return $$$OK
}

/// Returns the geometry as a $LIST
Method asList()
{
    Return $lb(..longitude, ..latitude)
}

/// Returns a geometry as a GeoJSON "point"
Method asGeoJSON() As %String
{
    set tp = {"type": "Feature", "geometry": {"coordinates": [(..longitude), (..latitude)], "type": "Point"}}
    Return tp.%ToJSON()
}

/// Returns the OGC Well-Known Text (WKT) representation of the point
Method asText() As %String
{
    Return "POINT ("_..longitude_" "_..latitude_")"
}

/// Number of vertices comprising this Point
Method numPoints() As %Integer
{
    Return 1
}

/// Returns the type of the geometry as the string 'POINT'
ClassMethod geometryType() As %String
{
    Return "POINT"
}

/// Return the topological dimension of this Geometry object, which is 0, per OGC SPEC s2.1.1.1
ClassMethod dimension() As %Integer
{
    Return "0"
}

Storage Default
{
<Data name="PointState">
<Value name="1">
<Value>latitude</Value>
</Value>
<Value name="2">
<Value>longitude</Value>
</Value>
</Data>
<State>PointState</State>
<StreamLocation>^rsingh.spatialiris.geo.PointS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
