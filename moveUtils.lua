require "gamestate"


function Heuristic(node,color)
  
  local A = node.A
  --check for game end condition
  --return huge val if game ends
  -- <1> goats eaten > 5
  -- <2> All tigers trapped
  if node.goatsDead > 5 or node.tigersBlocked == 4 then
    return math.huge
  end
  
  
  --check if any tiger trapped
  --return a positive value if goat
  --negative otherwise
  
  --check if any goat eaten
  --return a negative value if goat
  --return positive otherwise
  local goats,num_g = getGoatLoc(node.A)
  --local postGoats,num_post_goats = getGoatLoc(node.postA)
  if  num_g > 0 then
    return -color * math.huge/(node.goatsDead)
  else
    return math.huge
    --can be optimised to just divided by node.data.goatsDead
  end
  
  
end

function generateMoves(n)

  local t,num_t = getTigerLoc(n.A)
  local g,num_g = getGoatLoc(n.A)
  local idx = 1
  
  if n.color == 1 then
    
    if num_g == 0 then
      for i = 1,BOARDSIZE do
        for j = 1,BOARDSIZE do
          local m = {}
          m.src = nil
          m.dst = {}
          m.dst.x = i
          m.dst.y = j
          m.color = n.color
          local game = node:new(n.A)
          --game = node.data:makeCopy(node.data)
          if game:validate(m) then
            --local n = node:clone(math.random(1,1000))
            n:add_child(game)
            n.children[n.num_children]:addMove(m)
          end
        end
      end
    end
    
    for i = 1,num_g do
      local m = {}
      m.src = {}
      m.src.x = g[idx]["x"]
      m.src.y = g[idx]["y"]
      for j = -1,1 do
        for k = -1,1 do
          m.dst = {}
          m.dst.x = m.dst.x + j
          m.dst.y = m.dst.y + k
          if node.data:validate(m) then
            local n = node:clone(math.random(1,1000))
            node:add_child(n)
            n.children[n.num_children].mv = m
          end
        end
      end
    end
  elseif node.color == -1 then
    for i = 1,num_t do
      local m = {}
      m.src = {}
      m.src.x = t[idx]["x"]
      m.src.y = t[idx]["y"]
      for j = -1,1 do
        for k = -1,1 do
          m.dst = {}
          m.dst.x = m.dst.x + j
          m.dst.y = m.dst.y + k
          if node.data:validate(m) then
            local n = node:clone(math.random(1,1000))
            node:add_child(n)
            n.children[n.num_children].mv = m
          end
        end
      end
    end
  end
  
end

function getTigerLoc(a)
  
  local tiger_list = {}
  local idx = 1
  
  for i = 1,BOARDSIZE do
    for j = 1,BOARDSIZE do
      if a[i][j] == -1 then
        tiger_list[idx] = {}
        tiger_list[idx]["x"] = i
        tiger_list[idx]["y"] = j
        idx = idx + 1
      end
    end
  end
  
  return tiger_list,(idx - 1)
  
end

function getGoatLoc(a)
  
  local goat_list = {}
  local idx = 1
  
  for i = 1,BOARDSIZE do
    for j = 1,BOARDSIZE do
      if a[i][j] == 1 then
        tiger_list[idx] = {}
        tiger_list[idx]["x"] = i
        tiger_list[idx]["y"] = j
        idx = idx + 1
      end
    end
  end
  
  return goat_list,(idx - 1) 
  
end

 






 
