local GS = {}

function GS.create()
  
  local g = {}
  
  setmetatable(g,GS)
  
  --initialize game state
  g.A = {}
  
  for i =1,BOARDSIZE do
    g.A[i] = {}
    for j =1,BOARDSIZE do
      g.A[i][j] = 0
    end
  end
  --put tigers on corners
  g.A[1][1] = -1
  g.A[1][BOARDSIZE] = -1
  g.A[BOARDSIZE][1] = -1
  g.A[BOARDSIZE][BOARDSIZE] = -1

  --remember last move
  g.mv = nil
  --remember whose turn is it now
  -- Goat is G or 1
  -- Tiger is T or -1
  -- Empty is 0
  g.color = 1
  g.goatsBoard = 0
  g.goatsDead = 0
  g.tigersBlocked = 0
  
  --remember moves
  g.moves = 0
  
  return g
  
end


function GS:update(mv)
  	if mv.src then
		self.A[mv.src.x][mv.src.y] = 0;
    local X1,Y1 = mv.src.x,mv.src.y;
    local X2,Y2 = mv.dst.x,mv.dst.y;
    local dist = math.sqrt((X1-X2)^2+(Y1-Y2)^2);
    
    self.A[mv.src.x][mv.src.y] = 0
  
    if dist == 2*math.sqrt(2) or dist == 2 then
      local middleX = (X1+X2)/2;
      local middleY = (Y1+Y2)/2;
      self.A[middleX][middleY] = 0;
    end
	end
	self.A[mv.dst.x][mv.dst.y] = mv.color;
end

function GS:isSpecial(x,y)
	if x == 2 or x == 4 then
		if y == 2 or y == 4 then
			return true;
		end
	end
	return false;
end

function GS:Validate(mv)
  --check if move is there
	if mv == nil then
		return false;
	end
  
  --check if new goat can be placed
	if mv.src == nil then
		if mv.color == 1 and (self.goatsBoard + self.goatsDead) < 20 and self.A[mv.dst.x][mv.dst.y] == 0 then
			return true;
		else
			return false;
		end
	end
  
  --check if you are moving an existing piece
  --of the correct color and
  --destination is free
	if self.A[mv.src.x][mv.src.y] ~= mv.color or self.A[mv.dst.x][mv.dst.y] ~= 0 then
		return false;
	end

	local X1,Y1 = mv.src.x,mv.src.y;
	local X2,Y2 = mv.dst.x,mv.dst.y;
  
	local dist = math.sqrt((X1-X2)^2+(Y1-Y2)^2);

	if dist == 1 then
		return true;
	elseif dist == math.sqrt(2) then
		return self:isSpecial(X1,Y1) or self:isSpecial(X2,Y2);
	elseif dist == 2*math.sqrt(2) or dist == 2 then
		local middleX = (X1+X2)/2;
		local middleY = (Y1+Y2)/2;
		if self.A[middleX][middleY] ~= 1 or mv.color ~= -1 then
			return false;
		else 
			return true;
		end
	else
		return false;
	end
	 	
end

return GS
