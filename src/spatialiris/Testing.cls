Class geo.Testing
{

ClassMethod createSimpleTestPolygon() As geo.model.Polygon
{
    set l = ##class(geo.model.LineString).%New()
    do l.addPoint(##class(geo.model.Point).%New(0.01,0.01))
    do l.addPoint(##class(geo.model.Point).%New(2.01,0.01))
    do l.addPoint(##class(geo.model.Point).%New(2.01,2.01))
    do l.addPoint(##class(geo.model.Point).%New(0.01,2.01))
    do l.addPoint(##class(geo.model.Point).%New(0.01,0.01))
    set polygon = ##class(geo.model.Polygon).%New()
    set polygon.line = l
    Return polygon
}

ClassMethod createCambridgePolygon() As geo.model.Polygon
{
    set l = ##class(geo.model.LineString).%New()
    do l.addPoint(##class(geo.model.Point).%New(-71.07296971120546, 42.36751524646158))
    do l.addPoint(##class(geo.model.Point).%New(-71.08872828096423, 42.36897060744346))
    do l.addPoint(##class(geo.model.Point).%New(-71.08982906341102, 42.36605985176101))
    do l.addPoint(##class(geo.model.Point).%New(-71.09226237197649, 42.36717280368296))
    do l.addPoint(##class(geo.model.Point).%New(-71.09434806503295, 42.36511810781076))
    do l.addPoint(##class(geo.model.Point).%New(-71.08814892178214, 42.358268636220345))
    do l.addPoint(##class(geo.model.Point).%New(-71.0776045846639, 42.36019512557601))
    do l.addPoint(##class(geo.model.Point).%New(-71.07296971120546, 42.36751524646158))
    set polygon = ##class(geo.model.Polygon).%New()
    set polygon.line = l
    Return polygon
}

ClassMethod createLineIntersectingKendall() As geo.model.LineString
{
    set l = ##class(geo.model.LineString).%New()
    do l.addPointFromCoords(-71.09009501700031,42.36703809)
    do l.addPointFromCoords(-71.08100073568535,42.3670380723421)
    do l.addPointFromCoords(-71.085000,42.3670380723)
    Return l
}

ClassMethod createLineInsideKendall() As geo.model.LineString
{
    set l = ##class(geo.model.LineString).%New()
    do l.addPointFromCoords(-71.08100073568535,42.3670380723421)
    do l.addPointFromCoords(-71.085000,42.3670380723)
    Return l
}

ClassMethod createLineOutsideKendall() As geo.model.LineString
{
    set l = ##class(geo.model.LineString).%New()
    do l.addPointFromCoords(-71.09009501700031,42.3670380723421)
    do l.addPointFromCoords(-71.09009501700031,42.60000)
    Return l
}

ClassMethod createPointOutsideKendall() As geo.model.Point
{
    Return ##class(geo.model.Point).%New(-71.09009501700031,42.3670380723421)
}

ClassMethod createPointInsideKendall() As geo.model.Point
{
    Return ##class(geo.model.Point).%New(-71.08100073568535,42.3670380723421)
}

ClassMethod test()
{
    set polygon = ..createSimpleTestPolygon()
    set isin = ##class(geo.Tools).PointInPolygon(polygon, ##class(geo.model.Point).%New(1.01,1.01))
    w isin,!
    set isout = ##class(geo.Tools).PointInPolygon(polygon, ##class(geo.model.Point).%New(3.01,3.01))
    w isout,!
}

}
