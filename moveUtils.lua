--require "gamestate"


function Heuristic(n)
  -- retuns positive value for goat
  -- negative value for tiger
  
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
  --return a small positive value if goat
  --return large negative otherwise


  if  n.goatsDead > 0 and n.color == 1 then
    return -(math.huge/20) * n.goatsDead
  elseif n.goatsDead > 0 and n.color == -1 then
    return -math.huge
  else
    return math.huge
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

 
function aiMove()
  
  assert(turn == -N.color, "some problem with turn")
  N:setValue(minimax(N,DEPTH,-N.color))
   
  if N.endgame == true then
    return
  end

  N:sort_children(N.color);

    
  assert( N.num_children > 0 , "No children created ")

  mv = N.children[1].mv;

  N = N:getChildWithMove(mv);
  
  turn = -turn;
  iteration = iteration + 1;
  mv = nil
  state = 0
end

function playerMove()
  if state ~= 2 then
    return;
  end
    
  if N:validate(mv) then
    N:setValue(minimax(N,DEPTH,-N.color))  
    N = N:getChildWithMove(mv);
 
  
    turn = -turn;
    iteration = iteration + 1;
    mv = nil
    state = 0
  end
end
  





 
