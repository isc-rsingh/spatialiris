Class geo.model.AbstractGeometry Extends %SerialObject
{

// Returns the geometry as a $LIST

Method asList() [ Abstract ]
{
}

// Returns a geometry as a GeoJSON "geometry"

Method asGeoJSON() As %String [ Abstract ]
{
}

// Returns the OGC Well-Known Text (WKT) representation of the geometry

Method asText() As %String [ Abstract ]
{
}

// Return the number of points in a geometry.

Method numPoints() As %Integer [ Abstract ]
{
}

// Returns the type of the geometry as a string. Eg: 'LINESTRING', 'POLYGON', 'POINT'

ClassMethod geometryType() As %String [ Abstract ]
{
}

// Return the topological dimension of this Geometry object, which must be less than or equal to the coordinate dimension. OGC SPEC s2.1.1.1 - returns 0 for POINT, 1 for LINESTRING, 2 for POLYGON

ClassMethod dimension() As %Integer [ Abstract ]
{
}

Storage Default
{
<StreamLocation>^geo.model.AbstractGeometryS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
