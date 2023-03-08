/// Model of a geospatial location
Class geo.model.Point Extends %SerialObject
{

Property latitude As %Float(MAXVAL = 90.0, MINVAL = -90.0, SCALE = 6);

Property longitude As %Float(MAXVAL = 180.0, MINVAL = -180.0, SCALE = 6);

Method %OnNew(lat As %Float, lon As %Float) As %Status [ Private, ServerOnly = 1 ]
{
    set ..latitude = lat
    set ..longitude = lon
    Return $$$OK
}

Method getAsList()
{
    Return $lb(..longitude, ..latitude)
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
<StreamLocation>^geo.model.PointS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
