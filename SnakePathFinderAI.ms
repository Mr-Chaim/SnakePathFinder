y=1
obj = getcurrentselection()
select obj[1]

obj[1].name = "TestSubject"
ConvertTo obj[1] Editable_Poly
numOVerts = polyop.getnumverts obj[1]
currentN=(random 1 numOVerts)
a = line()
addnewspline a
addknot a 1 #smooth #curve (polyop.getvert obj[1] (currentN))
tryLine = 1
trueSpotArray = #() --This array is for the true position of the 
learntspot = #()
while y <= 20 do
(
learntspot = #()

k=1
n=1
j=1 

endPoint=(random 1 numOVerts)--
Sphereend = sphere()
Sphereend.radius = 1
Sphereend.name = "endPoint"
Sphereend.pos = (polyop.getvert obj[1] (endPoint))
animationRange = interval 0f (300)
randomspotArray = #()
goalachieved = false

--max tool animmode
while goalachieved == false do
(
	j=1 
	potentialArrayEdges = (polyop.getEdgesUsingVert obj[1] currentN)
	potentialArrayVertex = (polyop.getVertsUsingEdge obj[1] potentialArrayEdges) as array
	directNeighbourArray = potentialArrayVertex
	/*for p=1 to potentialarrayvertex.count do 
	(
		newPoint = potentialarrayvertex[p]
		potentialArrayEdges = (polyop.getEdgesUsingVert obj[1] newPoint)
		NewpotentialArrayVertex = (polyop.getVertsUsingEdge obj[1] potentialArrayEdges)
		join potentialArrayVertex NewpotentialArrayVertex
	)*/
	makeuniqueArray potentialarrayvertex
	currentInArray = finditem potentialArrayVertex currentN
	finalArray = deleteitem potentialarrayvertex currentInArray
--	randomSpot = random 1 numOVerts -- random point to be used as objective
	endVert = (polyop.getvert obj[1] (endPoint)) -- objective spot
	currentSpot = (polyop.getvert obj[1] (currentN)) --currentSpot
	vertexarrayCount = finalArray.count
	distanceCurrentMin = distance currentSpot endVert --distance between current position and destination
	distanceCurrentMinTest = distance currentSpot endVert --same as above but for testing purposes
	weight1 = 0
	weight2 = 0
	weight3 = 0
	weight0 = 0
	weight = 0
	--distanceBetweenPotential = distance currentSpot potencial --distance betwen current spot and potential next spot
	--distanceBetweenPotentialToend = distance potencial endVert --same as above but for testing purposes
	
	for t=1 to vertexarrayCount do --serch through all vertex in the array
	(
		potencial = (polyop.getvert obj[1] (finalArray[t]))
		testTrueSpot = finditem trueSpotArray finalArray[t] -- find if the potential has been used already
		testLearntSpot = finditem learntspot  finalArray[t]
		--testArray = finditem randomspotArray potentialArrayVertex[j] -- find if the potential has been used in this loop
		
		if potentialarrayvertex[t] != currentN do
		(
			--weight0 = finalarray[t]
			if testLearntSpot == 0 do
			(
				if testTrueSpot == 0 then
				(
					weight0 = finalarray[t]
					weight1 = finalarray[t]
					currentSpot = (polyop.getvert obj[1] (currentN))
					potencial = (polyop.getvert obj[1] (finalArray[t])) --
					distanceBetweencurrentend = distance currentSpot endVert
					distanceBetweenPotentialToend = distance potencial endVert
					if distanceBetweenPotentialToend <= distanceBetweencurrentend then
					(
						weight2 = finalarray[t]

						if distanceBetweenPotentialToend < distanceBetweencurrentend then
						(
							currentTry = t as string
							if (finditem directNeighbourArray finalarray[t]) != 0 do
							(
								weight3 = finalarray[t]
								currentN = finalArray[t]
							)
							/*else
							(
								weight2 = finalarray[t]
								currentN = finalArray[t]
							)*/	
						)
						else
						(

							currentTry = t as string
						)
					)
					else
					(

						currentTry = t as string
					)
				)
				else
				(
					/*print ("Current try N :" +(t as string))
					print ("Current " + (currentN as string))
					print ("Potencial " + (finalArray[t] as string) + " - Distance to end : " + (distanceBetweenPotentialToend as string))*/
					currentTry = t as string
				)
			)
				
		)--print currentTry
	)
	if weight0 !=0 do
	(
		if weight1 != 0 then
		(
			if weight2 != 0 then
			(
				if weight3 != 0 then
				(
					currentN = weight3
					weight = 4
				--	Print "Weight 3"
				)
				else 
				( 
					currentN = weight2
					weight = 3
				--	print "Weight 2"
				)
			)
			else 
			(
				currentN = weight1
				weight = 2
				--print "Weight 1"
			)
		)
		else
		(
		currentN = weight0
		weight = 1
		)
	)
	
	

	testArray = finditem trueSpotArray currentN
	sl = getseglengths a 1
	slc = sl.count
	print ("Cycle: " + (y as string) + " - Steps: " + (k as string) + " - Spline N: " + (tryline as string) + " - Weight: " + (weight as string) + " - Current vertex: " + (currentN as string) + " - Lnegth:  " + (sl[slc] as string) + " - N of learned spots : " + (learntspot.count as string))
	if distanceCurrentMinTest != 0.0 then 
	(
		if weight0 == 0 do 
		(
			delete a
			a = line()
			addnewspline a
			addknot a 1 #smooth #curve (polyop.getvert obj[1] (currentN))
			tryLine+=1
			trueSpotArray = #()
			append trueSpotArray currentN
			append learntspot currentN
			goalachieved = true
			k=1
			print "Goal Failed"
		)
	)
		
		--print randomspotArray
		--print randomspotArray.count
		--print distanceCurrentMinTest
		--print distanceCurrentMin
		--print distanceBetweenPotentialToend
		--print distanceBetweenPotential
		if distanceCurrentMinTest == 0.0 then 
		(
			goalachieved = true
			--print "Goal Reached"
		)
		else
		(
			append trueSpotArray currentN
		addknot a 1 #smooth #curve (polyop.getvert obj[1] (currentN))
		knotsCounter = numknots a
		if k >= 2 then 
		(
			updateshape a
			deleteKnot a 1 (1)
			deleteitem trueSpotArray 1
			updateshape a
			
		)
		if k > 10 do 
		(
			append learntspot currentN
			/*if (numknots a) > 2 do
			(
				updateshape a
				deleteKnot a 1 (1)
				deleteitem trueSpotArray 1
				updateshape a
				
			)*/
		)
		if k > 300 do
		(
			delete a
			a = line()
			addnewspline a
			addknot a 1 #smooth #curve (polyop.getvert obj[1] (currentN))
			tryLine+=1
			trueSpotArray = #()
			append learntspot currentN
			append trueSpotArray currentN
			goalachieved = true
			k=1
			print "Goal Failed"
		)
		)
		if testArray != 0 do (goalachieved = true)
		

		--sliderTime = n
		--addnewKey addknot n
		
		--n = randomspotArray.count
		sliderTime = k
		k+=1
		if distanceCurrentMinTest == 0.0 do 
		(
			goalachieved = true
			--print "Goal Reached"
		)
		if testArray != 0 do (goalachieved = true)

)
delete Sphereend
--append randomspotArray currentN
--deleteitem randomspotArray randomspotArray.count
--max tool animmode
--a.name = ((y as string) + "-- line --- lenght_" + (sl[sl.count] as string))
--spheretest.name = ((y as string) + "-- sphere --- lenght_" + (sl[sl.count] as string))
select obj[1]

--updateshape a
y+=1
currentN = endPoint
)