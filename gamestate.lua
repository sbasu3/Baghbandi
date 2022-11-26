local class = require 'middleclass'

GS = class('GS')

--GS.__index = GS


function GS:initialize(t)  
  --local g = {}
  
  --setmetatable(g,GS)
  --g.__index = GS

--initialize game state
  if self == nil then
    assert( self == t , "object is modifying self")
  end
  
  self.A = {}


  for i =1,BOARDSIZE do
    self.A[i] = {}
    --print(g.A[i])
    for j =1,BOARDSIZE do
      self.A[i][j] = 0
    end
  end
--put tigers on corners
  self.A[1][1] = -1
  --self.A[1][3] = -1
  --self.A[1][5] = -1
  self.A[1][BOARDSIZE] = -1
  self.A[BOARDSIZE][1] = -1
  self.A[BOARDSIZE][BOARDSIZE] = -1
    --remember last move
  self.mv = nil
  self.postA = nil
  --remember whose turn is it now
  -- Goat is G or 1
  -- Tiger is T or -1
  -- Empty is 0
  self.color = -1
  self.goatsBoard = 0
  self.goatsDead = 0
  self.tigersBlocked = 0

  --remember moves
  self.moves = 0
  --return g
end





function GS:addMove(mv)
  self.mv = {}
  self.mv.color = mv.color
  --assert( self.color == mv.color, " Some problem with color")
  if mv.src ~= nil then
    self.mv.src = {}
    self.mv.src.x = mv.src.x
    self.mv.src.y = mv.src.y
  end
  
  self.mv.dst = {}
  self.mv.dst.x = mv.dst.x
  self.mv.dst.y = mv.dst.y
end


function GS:apply()
  
  local killed = false; 
  -- copy the original state first
  self.postA = {}
  
  for i =1,BOARDSIZE do
    self.postA[i] = {}
    for j =1,BOARDSIZE do
      self.postA[i][j] = self.A[i][j]
    end
  end
  
  if self.mv.src then
		--self.postA[mv.src.x][mv.src.y] = 0;
    local X1,Y1 = self.mv.src.x,self.mv.src.y;
    local X2,Y2 = self.mv.dst.x,self.mv.dst.y;
    local dist = math.sqrt((X1-X2)^2+(Y1-Y2)^2);
    
    self.postA[self.mv.src.x][self.mv.src.y] = 0
  
    if dist == 2*math.sqrt(2) or dist == 2 then
      local middleX = (X1+X2)/2;
      local middleY = (Y1+Y2)/2;
      self.postA[middleX][middleY] = 0;
      self.goatsDead = self.goatsDead + 1;
      self.goatsBoard = self.goatsBoard - 1;
      killed = true;
    end
	end
	self.postA[self.mv.dst.x][self.mv.dst.y] = self.mv.color;
  
  if self.mv.color == 1 and self.mv.src == nil then
    self.goatsBoard = self.goatsBoard + 1
  end
  
  
  self.A = self.postA
  
  return killed;
end

function GS:isSpecial(x,y)
	if x == 2 or x == 4 then
		if y == 2 or y == 4 then
			return true;
		end
	end
  
  if x == 3 and y == 3 then
    return true
  end
  
	return false;
end

function GS:validate(mv)
  --check if move is there
	if mv == nil or mv.dst == nil then
		return false;
	end
  --check out of bounds
  if mv.dst.x < 1 or mv.dst.x > 5 or mv.dst.y < 1 or mv.dst.y > 5 then
    return false
  end
  --check mv color matches self
  --assert( self.color == mv.color , " Problem with color setting")
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
	elseif ((dist == 2*math.sqrt(2) and (self:isSpecial(X1,Y1) or self:isSpecial(X2,Y2))) or dist == 2 )  then
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

--return GS
