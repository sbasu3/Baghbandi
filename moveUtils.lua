--require "gamestate"


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

 






 
