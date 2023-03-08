Class geo.TestTools Extends %UnitTest.TestCase
{

Method TestIdentity(p1 As geo.model.Point, p2 As geo.model.Point)
{
    do $$$AssertEquals(##class(geo.model.Point).%New(42.3, 77.1), ##class(geo.model.Point).%New(42.3, 77.1))
    do $$$AssertNotEquals(##class(geo.model.Point).%New(42.3, 77.1), ##class(geo.model.Point).%New(42.3, 77.11))
}

}
