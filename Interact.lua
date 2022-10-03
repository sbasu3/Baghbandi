
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
  --accepts a 2D array only
	local min_x;
  local min_y;
	local Min = math.huge;

	for x, t1 in ipairs(T) do
    for y,v in ipairs(t1) do
      if v < Min then
        min_x = x;
        min_y = y;
        Min = v;
      end
      
		end
	end

	return min_x,min_y;
end
