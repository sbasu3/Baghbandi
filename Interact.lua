function love.mousepressed( x , y , button)
	local gap = (SIZE-BSIZE)/4;
	local NearList = {};
	if button == "l" then
		for i = 1,5 do
			for j =1,5 do
				NearList[ (i-1)*5 + j] = distance(x,y,BSIZE+gap*(j-1),BSIZE+gap*(i-1));
			end
		end
		k1,k2 = GetMin(NearList);
		G.click = k2;
		--print("Mouse clicked at",k2);
	end
end

function distance(x1,y1,x2,y2)
	return math.sqrt((x1 - x2)^2+(y1 - y2)^2);
end

function SearchVal(A,Val)	-- A is an Array, Val a numerical value
	local index;

	for index, v in ipairs(A) do
		if v == Val then
			return index;
		end
	end

	return nil;
end

function GetMin(T)
	local Min_index;
	local Min = math.huge;

	for index, v in ipairs(T) do
		if v < Min then
			Min = v;
			Min_index = index;
		end
	end

	return Min,Min_index;
end
