/// <pre>
/// Author - Alex Woodhead  2021-04-26 - V1 IRIS arrays and Lists to Py Dict and List<br/>
///                         2021-05-07 - Added support for py Dict and List back to IRIS array and List<br/>
///                                      Added Error log notifications for unsupported types.
///                                      Added string only keys for dictionaries
/// </pre>
/// 
/// Mission:<br/>
/// A convenience utility to convert between:<ul>
/// <li>IRIS LIST and Python list</li>
/// <li>IRIS array and Python dictionary</li>
/// 
/// Method:<br/>
/// When converting IRIS arrays to Python dictionaries
/// the keys generated (for key,values) will always be strings.<br/>
/// This simplifies implementation IRIS->Python by providing consist output
/// whatever the invocation style is in IRIS.
/// <br/>
/// Conversion error information will be written to the IRIS event log<br/>
/// </br>
/// Whats is supported in both directions:<ul>
/// <li>Converting IRIS Arrays to Py Dictionaries</li>
/// <li>Converting IRIS multidimensional array to inner Py Dictionaries within Py Dictionaries</li>
/// <li>Converting IRIS Arrays that also contain lists to Dictionaries with values of Py Lists</li>
/// <li>Converting IRIS LIST to Py List</li>
/// </ul>
/// What is not supported:<ul>
/// <li>Converting Py Lists that contain Py Dictionaries into IRIS LISTS</li>
/// </ul>
Class Py.Helper [ Abstract ]
{

/// Allows dictionary key to be set
/// python language provides "[]" mutator
/// This method wraps this with a "Set" method
/// <example>
/// set impBi=##class(%SYS.Python).Import("builtins")
/// set pRequest=impBi.dict()
/// do ##class(Py.Helper).pyDictSet(pRequest,"Fname","Bob")
/// do ##class(Py.Helper).pyDictSet(pRequest,"Mname","Henry")
/// do ##class(Py.Helper).pyDictSet(pRequest,"Lname","Smith")
/// zw pRequest
/// pRequest=52@%SYS.Python  ; {'Fname': 'Bob', 'Mname': 'Henry', 'Lname': 'Smith'}  ; <OREF>
/// </example>
ClassMethod pyDictSet(ByRef dict As %SYS.Python, key, value)
{
	// Force key names to strings
	do ..pyDictSetInner(dict,""_key_"",value)
}

ClassMethod pyDictSetInner(ByRef dict As %SYS.Python, key, value) [ Language = python, Private ]
{
	dict[key]=value
}

/// Allows dictionary key to be removed
/// python language provides del keyword
/// This method wraps this with a "Kill" method
/// <example>
/// ; see pyDictSet method example for previous variable setup)
/// zw pRequest
/// pRequest=52@%SYS.Python  ; {'Fname': 'Bob', 'Mname': 'Henry', 'Lname': 'Smith'}  ; <OREF>
/// do ##class(Py.Helper).pyDictKill(pRequest,"Mname")
/// zw pRequest
/// pRequest=52@%SYS.Python  ; {'Fname': 'Bob', 'Lname': 'Smith'}  ; <OREF>
/// </example>
ClassMethod pyDictKill(ByRef dict As %SYS.Python, key)
{
	// Force key names to strings
	do ..pyDictKillInner(dict,""_key_"")
}

ClassMethod pyDictKillInner(ByRef dict As %SYS.Python, key) [ Language = python, Private ]
{
	del dict[key]
}

/// Convert IRIS array variable to python dictionary
/// Supports Nexted List Nodes as node values where IRIS Lists are converted to python Lists.
/// Where there is a node value AND sub-nodes the node value is given dictionary key "_value"
/// <example>
/// set array=123
/// set array(1)=456
/// set array("ADDRESS",1,"ADD1")="HouseOrFlatNumber"
/// set array("ADDRESS",1,"ADD2")="TownOrCity"
/// set array("ADDRESS",1,"ADD3")="CountyOrRegion"
/// set array("ADDRESS",1,"ADD4")="Country"
/// set array("ADDRESS",1,"ADD5")="ZIPCode"
/// set array("FNAME")="BOB"
/// set array("LNAME")="SMITH"
/// set array("ListTest",1)=$lb(1,2,$lb(3,4,"Five"))
/// set myPyDict=##class(Py.Helper).pyDictFromArray(.array)
/// zw myPyDict
/// myPyDict=46@%SYS.Python  ; {'_value': 123, '1': 456, 'ADDRESS': {1: {'ADD1': 'HouseOrFlatNumber', 'ADD2': 'TownOrCity', 'ADD3': 'CountyOrRegion', 'ADD4': 'Country', 'ADD5': 'ZIPCode'}}, 'FNAME': 'BOB', 'LNAME': 'SMITH', 'ListTest': {1: [1, 2, [3, 4, 'Five']]}}  ; <OREF>
/// </example>
ClassMethod pyDictFromArray(ByRef array, ByRef ret As %SYS.Python = {$$$NULLOREF}, ByRef impBi As %SYS.Python = {##class(%SYS.Python).Import("builtins")}) As %SYS.Python [ ProcedureBlock = 1 ]
{
	if ret=$$$NULLOREF {
		set ret=impBi.dict()
		if $Data(array)#2 {
			do ..pyDictSet(ret,"_value",..toPyListOrString(array,,impBi))  // Value of top node only
		}
	}
	set k1=""
	for {
		set k1=$O(array(k1),+1,data)
		quit:k1=""
		if $D(array(k1))=1 {
			do ..pyDictSet(ret,k1,..toPyListOrString(data,,impBi))
			continue
		}
		set k1dict=impBi.dict()
		do ..pyDictSet(ret,k1,k1dict)  // pre-append dictionary to Key
		if $D(array(k1))=11 {
			do ..pyDictSet(k1dict,"_value",..toPyListOrString(data,,impBi))
		}
		kill subarry
		merge subarry=array(k1)
		do ..pyDictFromArray(.subarry,k1dict,impBi)
	}
	quit ret
}

/// Convert IRIS array variable to python dictionary
/// <example>
/// set tlist=$LB(1,2,3,$LB("A","B","C"))
/// set myPyList=##class(Py.Helper).toPyListOrString(tlist)
/// myPyList=59@%SYS.Python  ; [1, 2, 3, ['A', 'B', 'C']]  ; <OREF>
/// </example>
ClassMethod toPyListOrString(ByRef data, ByRef ret As %SYS.Python = {$$$NULLOREF}, ByRef impBi As %SYS.Python = {##class(%SYS.Python).Import("builtins")}) As %SYS.Python
{
	quit:'$LISTVALID(data) data
	if ret=$$$NULLOREF {
		set ret=impBi.list()
	}
	set listLen=$ListLength(data)
	for i=1:1:listLen {
		set nData=$LG(data,i)
		if '$LISTVALID(nData) {
			do ret.append(nData)
		} else {
			set l1List=impBi.list()
			do ret.append(..toPyListOrString(nData,l1List,impBi))
		}
	}
	quit ret
}

/// Convert Python dictionary to IRIS array
/// <example>
/// USER>zw myPyDict
/// myPyDict=4@%SYS.Python  ; {'_value': 123, '1': 456, 'ADDRESS': {1: {'ADD1': 'HouseOrFlatNumber', 'ADD2': 'TownOrCity', 'ADD3': 'CountyOrRegion', 'ADD4': 'Country', 'ADD5': 'ZIPCode'}}, 'FNAME': 'BOB', 'LNAME': 'SMITH', 'ListTest': {1: [1, 2, [3, 4, 'Five']]}}  ; <OREF>
/// 
/// USER>kill echoArray
/// 
/// USER>do ##class(Py.Helper).ArrayFrompyDict(myPyDict,,.echoArray)
/// 
/// USER>zw echoArray
/// echoArray=123
/// echoArray(1)=456
/// echoArray("ADDRESS",1,"ADD1")="HouseOrFlatNumber"
/// echoArray("ADDRESS",1,"ADD2")="TownOrCity"
/// echoArray("ADDRESS",1,"ADD3")="CountyOrRegion"
/// echoArray("ADDRESS",1,"ADD4")="Country"
/// echoArray("ADDRESS",1,"ADD5")="ZIPCode"
/// echoArray("FNAME")="BOB"
/// echoArray("LNAME")="SMITH"
/// echoArray("ListTest",1)=$lb(1,2,$lb(3,4,"Five"))
/// </example>
ClassMethod ArrayFrompyDict(ByRef pyDict As %SYS.Python = {$$$NULLOREF}, ByRef impBi As %SYS.Python = {##class(%SYS.Python).Import("builtins")}, ByRef array, msgkeys = "") [ ProcedureBlock = 1 ]
{
	quit:'$IsObject(pyDict)
	// Itterate over the keys of the Dictionary
	set dictKeys=impBi.list(pyDict.keys())
	set dictValues=impBi.list(pyDict.values())
	set listLen=impBi.len(dictKeys)
	for i=1:1:listLen {
		kill data
		set key=..pyListGet(i,dictKeys)
		continue:key=""  // Can't use empty string key
		set data=..pyListGet(i,dictValues)
		if $IsObject(data) {
			if ..pyListIs(data) {
				set data=..ListFrompyList(data,impBi)
			} elseif ..pyDictIs(data) {
				kill innerArray
				do ..ArrayFrompyDict(data,impBi,.innerArray,msgkeys_"["_key_"]")
			} else {
				set $ZE="Class "_..%ClassName(1)_" Method ArrayFrompyDict. Unsupported value type """_..pyTypeName(data)_""" at key "_msgkeys_"["_key_"]"
				do BACK^%ETN
			}
		} else {
			set data=..toPyListOrString(data)	
		}
		if key="_value" {
			set array=data	// Strings and Lists
		} elseif $Data(innerArray)>1 {
			merge array(key)=innerArray  // Strings, 
			kill innerArray
		} else {
			set array(key)=data // lists and "sub-array"
		}
	}
	quit
}

/// Convert Python list to IRIS list
/// <example>
/// USER>zw myPyList
/// myPyList=7@%SYS.Python  ; [1, 2, 3, ['A', 'B', 'C']]  ; <OREF>
/// 
/// 
/// </example>
ClassMethod ListFrompyList(ByRef pyList As %SYS.Python = {$$$NULLOREF}, ByRef impBi As %SYS.Python = {##class(%SYS.Python).Import("builtins")}, msgkeys = "") As %SYS.Python [ ProcedureBlock = 1 ]
{
	set ret=$LB()
	// How to get length of list
	set listlen=impBi.len(pyList)
	for i=1:1:listlen {
		set data=##class(Py.Helper).pyListGet(i,pyList)
		// if data is also a list // TODO
		if $IsObject(data) {
			if ..pyListIs(data) {
			  set data=..ListFrompyList(data,impBi,,msgkeys_"["_i_"]")
			} else {
				set $ZE="Class "_..%ClassName(1)_" Method ListFrompyList. Unsupported value type """_..pyTypeName(data)_""" at position "_msgkeys_"["_i_"]"
				do BACK^%ETN	
			}
		}
		// add string / numeric / IRIS LIST to ret
		set ret=$LU(ret,i,data)
	}
	quit ret
}

/// Returns empty string on error
/// position starts at one to keep same as IRIS List
ClassMethod pyListGet(position As %Integer, ByRef pyList As %SYS.Python) As %SYS.Python [ Language = python ]
{
	ret=""
	try:
	  ret=(pyList[position-1])
	except:
	  print("Error in pyListGet")
	  
	return ret
}

ClassMethod pyListIs(ByRef pyList As %SYS.Python) As %SYS.Python [ Language = python ]
{
	return (type(pyList)==list)
}

ClassMethod pyDictIs(ByRef pyDict As %SYS.Python) As %SYS.Python [ Language = python ]
{
	return (type(pyDict)==dict)
}

ClassMethod pyTypeName(obj As %SYS.Python) As %String [ Language = python ]
{
	return type(obj).__name__
}

}
