local class = require('middleclass')
require "gamestate"
require "moveUtils"

node = class('node',GS)

function node:initialize (t)
  --local n = {}
  
  --setmetatable(n,node)
  --n.__index = node
  GS:initialize(t)
  --self.data = GS:new()
  --n.data.__index = gs

  --node.data = gs:makeCopy(GS)
  --node.data.__index = node.data

  --gs = require('gamestate').create()

  --function node.create(data,id)
  --local n = {}

  --setmetatable(n,node)

  --n.data = GS:new(data)
  --n.data = deepcopy(data)
  --self.color = 1
  self.id = math.random(1,1000)
  self.value = nil
  self.num_children = 0
  self.children = {}
  self.generated = false
  --return n
  
end

function node:setGameState(t)
  --local t = node:new()
  
  for i =1,BOARDSIZE do
    --self.A[i] = {}
    --print(g.A[i])
    for j =1,BOARDSIZE do
      self.A[i][j] = t[i][j]
    end
  end
end

function node:setVars(t)
        --remember last move
  self.mv = t.mv
  self.postA = t.postA
  --remember whose turn is it now
  -- Goat is G or 1
  -- Tiger is T or -1
  -- Empty is 0
  self.color = t.color
  self.goatsBoard = t.goatsBoard
  self.goatsDead = t.goatsDead
  self.tigersBlocked = t.tigersBlocked

  --remember moves
  self.moves = t.moves
  ---------------------------
  self.id = math.random(1,1000)
  self.value = nil
  self.num_children = 0
  self.children = {}
  self.generated = false
  --return t
end


function node:add_child(n)
  --print(n.A)
  table.insert(self.children,n)
  --self.children[self.num_children] = n
  self.num_children = self.num_children + 1
  
end

function node:delete_child(n)
  
  for i=1,self.num_children do
    if self.children[i].id == n.id then
      table.remove(self.children,i) 
      break
    end
  end
  if self.num_children ~= 0 then
    self.num_children = self.num_children - 1
  end
  
end

function node:delete_all_children()
  
  for _ = self.num_children,1,-1 do
    --self.children[i]:delete_all_children()
    table.remove(self.children)
  end
  self.num_children = 0
end

function node:setValue(val)
  
  self.value = val
end

 function node:sort_children(color)
   
  if color == 1 then
    table.sort(self.children,function (k1, k2)
      local v1 = k1.value
      local v2 = k2.value
      if v1 == nil then v1 = -math.huge end
      if v2 == nil then v2 = -math.huge end
      return v1 > v2
    end )
  else
    table.sort(self.children,function (k1, k2)
      local v1 = k1.value
      local v2 = k2.value
      if v1 == nil then v1 = math.huge end
      if v2 == nil then v2 = math.huge end
      return v1 < v2
    end )
  end
  
end
 
function node:getChildWithMove(mv)

  assert(mv ~= nil, "move not there")
  for _,child in pairs(self.children) do
    assert(child.mv ~= nil, "child mv not there!")
    local sameColor = (child.mv.color == mv.color)
    local sameDst = (child.mv.dst.x == mv.dst.x and child.mv.dst.y == mv.dst.y)
    local sameSrc = false

    if child.mv.src == nil and mv.src == nil then
      sameSrc = true
    elseif child.mv.src ~= nil and mv.src ~= nil then
      sameSrc = (child.mv.src.x == mv.src.x and child.mv.src.y == mv.src.y)
    end

    if sameColor and sameDst and sameSrc then
      return child
    end
  end
  return nil
end


function node:isTerminal()
  if not self.generated then
    self:generateMoves()
  end

  if #self.children == 0 then
    return true
  else
    return false
  end
end

function node:generateMoves()

  if self.generated then
    return
  end
  

  local t,num_t = getTigerLoc(self.A)
  local g,num_g = getGoatLoc(self.A)
  --local idx = 1
  assert(num_g == self.goatsBoard, "Goats on Board Mismatch")
  if self.color == -1 then
    -- Recalculate tigersBlocked for the current board state
    self.tigersBlocked = 0
    for idx = 1,num_t do
      local blocked = true
      for j = -2,2 do
        for k = -2,2 do
          local chk = {}
          chk.src = {x=t[idx]["x"], y=t[idx]["y"]}
          chk.dst = {x=t[idx]["x"]+j, y=t[idx]["y"]+k}
          chk.color = -1
          if self:validate(chk) then
            blocked = false
            break
          end
        end
        if not blocked then break end
      end
      if blocked then
        self.tigersBlocked = self.tigersBlocked + 1
      end
    end

    if num_g < (20 - self.goatsDead) then
      for i = 1,BOARDSIZE do
        for j = 1,BOARDSIZE do
          local m = {}
          m.src = nil
          m.dst = {}
          m.dst.x = i
          m.dst.y = j
          m.color = -self.color
          local game = node:new()
          game:setGameState(self.A)
          game:setVars(self)
          game.color = -self.color
          --game = node.data:makeCopy(node.data)
          if game:validate(m) then
            --local n = node:clone(math.random(1,1000))
      
            game:addMove(m)
            assert(m ~= nil , "Move nil")
            game:apply()
            --game.A = game.postA
            
            self:add_child(game)
            --self.children[self.num_children]:addMove(m)
          end
        end
      end
    end
    
    for idx = 1,num_g do
      local m = {}
      m.src = {}
      m.src.x = g[idx]["x"]
      m.src.y = g[idx]["y"]
      for j = -1,1 do
        for k = -1,1 do
          m.dst = {}
          m.dst.x = m.src.x + j
          m.dst.y = m.src.y + k
          m.color = -self.color
          local game = node:new()
          game:setGameState(self.A)
          game:setVars(self)
          game.color = -self.color
          --game = node.data:makeCopy(node.data)
          if game:validate(m) then
            
            game:addMove(m)
            game:apply()
            --game.A = game.postA
            

            self:add_child(game)
            --self.children[self.num_children]:addMove(m)
          end
        end
      end
    end
  elseif self.color == 1 then
    self.tigersBlocked = 0
    for idx = 1,num_t do
      local m = {}
      m.src = {}
      m.src.x = t[idx]["x"]
      m.src.y = t[idx]["y"]

      local blocked = true
      for j = -2,2 do
        for k = -2,2 do
          m.dst = {}
          m.dst.x = m.src.x + j
          m.dst.y = m.src.y + k
          m.color = -self.color
          local game = node:new()
          game:setGameState(self.A)
          game:setVars(self)
          game.color = -self.color
          --game = node.data:makeCopy(node.data)
          if game:validate(m) then
            
            game:addMove(m)
            game:apply()
            --game.A = game.postA
            --game.color = -self.color
            blocked = false
            self:add_child(game)
            --self.children[self.num_children]:addMove(m)
          end
        end
      end
      if blocked then
        self.tigersBlocked = self.tigersBlocked + 1
      end
    end
  end
  if self.tigersBlocked == 4 then
    self.endgame = true
  end
  
  self.generated = true
end


--return node