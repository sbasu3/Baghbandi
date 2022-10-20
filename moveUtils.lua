--require "gamestate"


function Heuristic(n)
  -- retuns positive value for goat
  -- negative value for tiger
  local A = n.A
  --check for game end condition
  --return huge val if game ends
  -- <1> goats eaten > 5
  -- <2> All tigers trapped
  if n.goatsDead > 5 then
    return -math.huge
  elseif n.tigersBlocked == 4 then
    return math.huge
  end
  
  
  --check if any tiger trapped
  --return a positive value if goat
  --negative otherwise
  if n.tigersBlocked > 0 then
    return n.color * ( math.huge/4) * n.tigersBlocked
  end
  
  --check if any goat eaten
  --return a negative value if goat
  --return positive otherwise
  local goats,num_g = getGoatLoc(n.A)
  --local postGoats,num_post_goats = getGoatLoc(node.postA)
  if  n.goatsDead > 0 then
    return n.color * (math.huge/20) * n.goatsDead
  else
    return math.huge
    --can be optimised to just divided by node.data.goatsDead
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
        goat_list[idx] = {}
        goat_list[idx]["x"] = i
        goat_list[idx]["y"] = j
        idx = idx + 1
      end
    end
  end
  
  return goat_list,(idx - 1) 
  
end

 






 
