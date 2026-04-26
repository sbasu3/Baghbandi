function Heuristic(n)
  -- Positive score favors goats, negative favors tigers.
  -- Keep scores finite so alpha-beta remains stable.
  local WIN_SCORE = 100000

  if n.goatsDead > 5 then
    return -WIN_SCORE
  elseif n.tigersBlocked >= 4 then
    return WIN_SCORE
  end

  local tiger_list, tigerCount = getTigerLoc(n.A)
  local goat_list, goatCount = getGoatLoc(n.A)

  local score = 0

  -- Captures are the strongest non-terminal signal.
  score = score - (120 * n.goatsDead)

  -- Blocking tigers is the main goat objective.
  score = score + (85 * n.tigersBlocked)

  -- More goats on board generally means stronger containment potential.
  score = score + (4 * goatCount)

  -- Reward central control for goats and penalize central tiger control.
  local centerControl = 0
  for i = 1,goatCount do
    if n:isSpecial(goat_list[i].x, goat_list[i].y) then
      centerControl = centerControl + 1
    end
  end
  for i = 1,tigerCount do
    if n:isSpecial(tiger_list[i].x, tiger_list[i].y) then
      centerControl = centerControl - 1
    end
  end
  score = score + (6 * centerControl)

  return score
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
  resetNegamaxStats()
  startNegamaxMemoryStats()
  N:setValue(negamax(N,DEPTH,-math.huge,math.huge,-N.color))
  finalizeNegamaxStats()
  printNegamaxStats(DEPTH)
   
  if N.endgame == true then
    return
  end

  -- Sort descending (1 = highest value first): negamax values are always
  -- from the moving player's perspective, so highest = best regardless of color.
  N:sort_children(1);

  if N.num_children == 0 then
    N.endgame = true
    return
  end

  mv = N.children[1].mv;

  local nextNode = N.children[1]
  if nextNode == nil then
    return
  end
  N = nextNode
  
  collectgarbage("collect");
  
  turn = -turn;
  iteration = iteration + 1;
  mv = nil
  state = 0
end

function playerMove()
  if state ~= 2 then
    return;
  end

  if mv == nil then
    state = 0
    return
  end
    
  if not N:validate(mv) then
    -- Invalid selection should not lock the player in state 2.
    local srcStr = mv.src and (mv.src.x .. "," .. mv.src.y) or "nil"
    print("[PLAYER MOVE] validate FAILED src=" .. srcStr
      .. " dst=" .. mv.dst.x .. "," .. mv.dst.y
      .. " color=" .. tostring(mv.color))
    mv = nil
    state = 0
    return
  end

  N:setValue(negamax(N,DEPTH,-math.huge,math.huge,-N.color))
  local nextNode = N:getChildWithMove(mv)
  if nextNode == nil then
    -- If move matching fails (stale/partial input), allow retry.
    local srcStr = mv.src and (mv.src.x .. "," .. mv.src.y) or "nil"
    print("[PLAYER MOVE] getChildWithMove FAILED src=" .. srcStr
      .. " dst=" .. mv.dst.x .. "," .. mv.dst.y
      .. " color=" .. tostring(mv.color)
      .. " (" .. tostring(N.num_children) .. " children)")
    mv = nil
    state = 0
    return
  end
  print("[PLAYER MOVE] OK src=" .. (mv.src and (mv.src.x..","..mv.src.y) or "nil")
    .. " dst=" .. mv.dst.x .. "," .. mv.dst.y)

  N = nextNode

  turn = -turn;
  iteration = iteration + 1;
  mv = nil
  state = 0
end
  





 
