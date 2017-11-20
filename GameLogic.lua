function A:update(mv)
 
	if mv.src then
		A[mv.src] = "_";
    local X1,Y1 = GetXY(mv.src);
    local X2,Y2 = GetXY(mv.dst);
    local dist = math.sqrt((X1-X2)^2+(Y1-Y2)^2);
    
    if dist == 2 or dist == 2*math.sqrt(2) then
      local middleX = (X1+X2)/2;
      local middleY = (Y1+Y2)/2;
      A[GetNum(middleX,middleY)] = "_";
    end
	end
	A[mv.dst] = mv.val;
end

function A:Validate(mv)
	if mv == nil then
		return false;
	end
	if mv.src == nil then
		if mv.val == "G" and G.num_goats < 20 and A[mv.dst] == "_" then
			return true;
		else
			return false;
		end
	end
	if A[mv.src] ~= mv.val or A[mv.dst] ~= "_" then
		return false;
	end

	local X1,Y1 = GetXY(mv.src);
	local X2,Y2 = GetXY(mv.dst);
	local dist = math.sqrt((X1-X2)^2+(Y1-Y2)^2);

	if dist == 1 then
		return true;
	elseif dist == math.sqrt(2) then
		return isSpecial(X1,Y1) or isSpecial(X2,Y2);
	elseif dist == 2*math.sqrt(2) or dist == 2 then
		local middleX = (X1+X2)/2;
		local middleY = (Y1+Y2)/2;
		if A[GetNum(middleX,middleY)] ~= "G" or mv.val ~= "T" then
			return false;
		else 
			return true;
		end
	else
		return false;
	end
	 	
end

function isSpecial(x,y)
	if x == 1 or x ==3 then
		if y == 1 or y ==3 then
			return true;
		end
	end
	return false;

end

function turn()
	if G.click ~= nil then
		if team == "goat" then
			if G.num_goats < 20 then
				move = {dst=G.click,val="G"};
			else
				if move.src == nil then
					move.src = G.click;
					move.val = "G";
				else
					move.dst = G.click;
				end	
			end
			
		else
			if move.src == nil then
				move.src = G.click;
				move.val = "T";
			else
				move.dst = G.click;
			end		
		end




		G.click = nil;
		if A:Validate(move) then
			A:update(move);move = {};
			if team == "goat" then
				team = "tiger";
			else
				team = "goat";
			end
		end
    
	end
end

function GetXY(num)
	if XY[num] then
		return XY[num].x , XY[num].y;
	else
		--local Xact = BSIZE + GAP * ((num - 1)%5);
		--local Yact = BSIZE + GAP * math.floor((num - 1)/5);
		local X = (num - 1) % 5;
		local Y = math.floor((num-1) /5);
		--print("Num,X,Y" ,num,X,Y);
		XY[num] = {};
		XY[num].x,XY[num].y = X,Y;
		return X,Y;
	end
end

function GetNum(X,Y)
	local num = 5*Y + X + 1;
	return num;
end

function Get_H_Reflection(num)
	local X,Y = GetXY(num);
	X = 4 - X ;
	return GetNum(X , Y);
end

function Get_V_Reflection(num)
	local X,Y = GetXY(num);
	Y = 4 - Y ;
	return GetNum(X , Y);
end

function GameState(A)
	local B = {};
	B[1] = A;
	B[2] = {};
	B[3] = {};
	B[4] = {};
	local T = {};	

	for i=1,25 do 
		B[2][i] = A[Get_H_Reflection(i)]; 
		B[3][i] = A[Get_V_Reflection(i)]; 
		B[4][i] = A[Get_H_Reflection(Get_V_Reflection(i))]; 
	end

	for i= 1,4 do
		T[i] = B[i][1];
		for j = 2,25 do
			T[i] = T[i]..B[i][j];
		end
	end
	
	return T;
end
