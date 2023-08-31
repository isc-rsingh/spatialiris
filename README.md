# SpatialIRIS

SpatialIRIS is a library of basic geographic features -- points, lines and polygons -- that implement common spatial operations, such as those involving distances between points, and containment of a geometry within a polygon. 

Many of these operations match those found in PostGIS, but the selection here is much more limited, and there are no spatial indices applied, so they will execute fairly slowly. However, this library brings useful functionality to InterSystems IRIS, such as identifying all patients with 10km of a hospital, or within a zip code or county.

## Classes

rsingh.spatialiris.geo.**Point**

A Point is a 0-dimensional geometry that represents a single location in coordinate space.

---

rsingh.spatialiris.geo.**LineString**

A LineString is a 1-dimensional line formed by a contiguous sequence of line segments. Each line segment is defined by two points, with the end point of one segment forming the start point of the next segment.

---

rsingh.spatialiris.geo.**Polygon**

A Polygon is a 2-dimensional planar region, delimited by an exterior boundary. Each boundary is a LineString for which the first and last points must be equal, and the line must not self-intersect.

## Methods

### Implemented by all geometry types

---

AbstractGeometry.**dimension()**

  The topological dimension of this Geometry object -- 0 for POINT, 1 for LINESTRING, 2 for POLYGON.

  **Returns:** %Integer

---

AbstractGeometry.**geometryType()**

  Returns the type of the geometry -- 'LINESTRING', 'POLYGON', or 'POINT'

  **Returns:** %String

---

AbstractGeometry.**numPoints()**

  Return the number of points in a geometry

  **Returns:** %Integer

---

AbstractGeometry.**asText()**

  Returns the OGC Well-Known Text (WKT) representation of the geometry/geography

  **Returns:** %String

---

AbstractGeometry.**asGeoJSON()**

  Returns a geometry as a GeoJSON "feature" (See the [GeoJSON specifications RFC 7946](https://tools.ietf.org/html/rfc7946)).

  **Returns:** %JSON

---
### Implemented by rsingh.spatialiris.geo.Point

---

rsingh.spatialiris.geo.Point.**pointInsideCircle**(centerX As %Float, centerY As %Float, radius As %Float)

  Parameters: 
  - **centerX** longitude of circle's center 
  - **centerY** latitude of circle's center
  - **radius** circle's radius in km

  Returns: **%Boolean** True if the point is inside the circle with center `center_x,center_y` and radius (in kilometers) `radius`. Otherwise False.

---

rsingh.spatialiris.geo.Point.**distance**(rsingh.spatialiris.geo.Point)

  Computes the minimum 2D Cartesian (planar) distance between two Points, in kilometers

 Returns: **%Integer** distance in km

### Implemented by rsingh.spatialiris.geo.Line

---

`startPoint() returns rsingh.spatialiris.geo.Point`

Returns the first point of a LineString.

---

`endPoint() returns rsingh.spatialiris.geo.Point`

Returns the last point of a LineString.

### Implemented by rsingh.spatialiris.geo.Polygon

---

`isClosed() returns %Boolean`

Returns TRUE if the Polygon's start and end points are coinciden

---

`contains(rsingh.spatialiris.geo.AbstractGeometry) returns %Boolean`

Returns TRUE if and only if no points of the passed geometry lie in the exterior of Polygon, and at least one point of the interior of the geometry lies in the interior of Polygon.

---

`intersects(rsingh.spatialiris.geo.AbstractGeometry) returns %Boolean`

Returns TRUE if any point of the passed geometry falls within the polygon.

---

`within(rsingh.spatialiris.geo.Polygon) returns %Boolean`

Returns TRUE if all points of the passed geometry fall within the polygon.

## Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.

## Installation 

Clone/git pull the repo into any local directory

```
$ git clone https://github.com/intersystems-community/objectscript-docker-template.git
```

Open the terminal in this directory and run:

```
$ docker-compose build
```

3. Run the IRIS container with your project:

```
$ docker-compose up -d
```

## How to Test it

Open IRIS terminal:

```
$ docker-compose exec iris iris session iris
USER>write ##class(dc.sample.ObjectScript).Test()
```

## Example

TBD

## How to start coding
This repository is ready to code in VSCode with ObjectScript plugin.
Install [VSCode](https://code.visualstudio.com/), [Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker) and [ObjectScript](https://marketplace.visualstudio.com/items?itemName=daimor.vscode-objectscript) plugin and open the folder in VSCode.
Open /src/cls/PackageSample/ObjectScript.cls class and try to make changes - it will be compiled in running IRIS docker container.
![docker_compose](https://user-images.githubusercontent.com/2781759/76656929-0f2e5700-6547-11ea-9cc9-486a5641c51d.gif)

Feel free to delete PackageSample folder and place your ObjectScript classes in a form
/src/Package/Classname.cls
[Read more about folder setup for InterSystems ObjectScript](https://community.intersystems.com/post/simplified-objectscript-source-folder-structure-package-manager)

The script in Installer.cls will import everything you place under /src into IRIS.


## What's inside the repository

### Dockerfile

The simplest Dockerfile which starts IRIS and imports code from /src folder into it.
Use the related docker-compose.yml to easily setup additional parametes like port number and where you map keys and host folders.

### .vscode/settings.json

Settings file to let you immediately code in VSCode with [VSCode ObjectScript plugin](https://marketplace.visualstudio.com/items?itemName=daimor.vscode-objectscript))

### .vscode/launch.json
Config file if you want to debug with VSCode ObjectScript

[Read about all the files in this article](https://community.intersystems.com/post/dockerfile-and-friends-or-how-run-and-collaborate-objectscript-projects-intersystems-iris)
