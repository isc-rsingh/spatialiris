/// Model of a geospatial linear feature
Class geo.model.Line Extends %SerialObject
{

Property points As list Of geo.model.Point;

Method addPoint(pt As geo.model.Point) As %Status
{
    do ..points.Insert(pt)
}

Method getAsList()
{
    for i = 1:1:..points.Count() {
        set $list(pointslist,i) = ..points.GetAt(i).getAsList()
    }
    Return pointslist
}

Storage Default
{
<Data name="LineState">
<Value name="1">
<Value>points</Value>
</Value>
</Data>
<State>LineState</State>
<StreamLocation>^geo.model.LineS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
