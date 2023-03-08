/// Model of a geospatial area, described as a geo.model.Line where the area > 0 (i.e. the line has more than 2 Points), 
/// and the first and last Points are the same.
Class geo.model.Polygon Extends %SerialObject
{

Property line As geo.model.Line;

/// Checks to see if conditions are true for this line to be a polygon
Method isValid() As %Boolean
{
    if ..line.Size < 3 Return 0
    Return ##class(geo.Tools).Identity(..line.GetAt(1), ..line.GetAt(..line.Size))
}

Method getAsList()
{
    Return ..line.getAsList()
}

Storage Default
{
<Data name="PolygonState">
<Value name="1">
<Value>line</Value>
</Value>
</Data>
<State>PolygonState</State>
<StreamLocation>^geo.model.PolygonS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
