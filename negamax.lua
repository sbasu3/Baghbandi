--[
--Description : Negamax is a Pruning Method of Min-Max Algorithm.
--             This implementation is dependent on GenerateMoves and OrderMoves
--Author : Subhojit Basu
--Date : 21 May 2014
--]

--require "moveUtils"
require "node"
--require "graph";

NegamaxStats = {
  calls = 0,
  leafs = 0,
  cutoffs = 0,
  internal = 0,
  memStartKB = 0,
  memEndKB = 0,
  memDeltaKB = 0,
  memPeakKB = 0,
  memPeakDeltaKB = 0,
}

NegamaxTotals = {
  searches = 0,
  calls = 0,
  leafs = 0,
  cutoffs = 0,
  internal = 0,
  memDeltaKB = 0,
  memPeakDeltaKB = 0,
  memPeakKBMax = 0,
}

function resetNegamaxStats()
  NegamaxStats.calls = 0
  NegamaxStats.leafs = 0
  NegamaxStats.cutoffs = 0
  NegamaxStats.internal = 0
  NegamaxStats.memStartKB = 0
  NegamaxStats.memEndKB = 0
  NegamaxStats.memDeltaKB = 0
  NegamaxStats.memPeakKB = 0
  NegamaxStats.memPeakDeltaKB = 0
end

function startNegamaxMemoryStats()
  local memNow = collectgarbage("count")
  NegamaxStats.memStartKB = memNow
  NegamaxStats.memEndKB = memNow
  NegamaxStats.memDeltaKB = 0
  NegamaxStats.memPeakKB = memNow
  NegamaxStats.memPeakDeltaKB = 0
end

function sampleNegamaxMemoryStats()
  local memNow = collectgarbage("count")
  if memNow > NegamaxStats.memPeakKB then
    NegamaxStats.memPeakKB = memNow
  end
end

function finalizeNegamaxStats()
  local memNow = collectgarbage("count")
  NegamaxStats.memEndKB = memNow
  if memNow > NegamaxStats.memPeakKB then
    NegamaxStats.memPeakKB = memNow
  end
  NegamaxStats.memDeltaKB = NegamaxStats.memEndKB - NegamaxStats.memStartKB
  NegamaxStats.memPeakDeltaKB = math.max(0, NegamaxStats.memPeakKB - NegamaxStats.memStartKB)
  NegamaxStats.internal = math.max(0, NegamaxStats.calls - NegamaxStats.leafs)

  NegamaxTotals.searches = NegamaxTotals.searches + 1
  NegamaxTotals.calls = NegamaxTotals.calls + NegamaxStats.calls
  NegamaxTotals.leafs = NegamaxTotals.leafs + NegamaxStats.leafs
  NegamaxTotals.cutoffs = NegamaxTotals.cutoffs + NegamaxStats.cutoffs
  NegamaxTotals.internal = NegamaxTotals.internal + NegamaxStats.internal
  NegamaxTotals.memDeltaKB = NegamaxTotals.memDeltaKB + NegamaxStats.memDeltaKB
  NegamaxTotals.memPeakDeltaKB = NegamaxTotals.memPeakDeltaKB + NegamaxStats.memPeakDeltaKB
  NegamaxTotals.memPeakKBMax = math.max(NegamaxTotals.memPeakKBMax, NegamaxStats.memPeakKB)
end

function printNegamaxStats(depth)
  print("Negamax stats (turn): depth=" .. tostring(depth)
    .. " calls=" .. tostring(NegamaxStats.calls)
    .. " leafs=" .. tostring(NegamaxStats.leafs)
    .. " internal=" .. tostring(NegamaxStats.internal)
    .. " cutoffs=" .. tostring(NegamaxStats.cutoffs)
    .. " memStartKB=" .. string.format("%.2f", NegamaxStats.memStartKB)
    .. " memEndKB=" .. string.format("%.2f", NegamaxStats.memEndKB)
    .. " memDeltaKB=" .. string.format("%.2f", NegamaxStats.memDeltaKB)
    .. " memPeakKB=" .. string.format("%.2f", NegamaxStats.memPeakKB)
    .. " memPeakDeltaKB=" .. string.format("%.2f", NegamaxStats.memPeakDeltaKB))

  print("Negamax stats (total): searches=" .. tostring(NegamaxTotals.searches)
    .. " calls=" .. tostring(NegamaxTotals.calls)
    .. " leafs=" .. tostring(NegamaxTotals.leafs)
    .. " internal=" .. tostring(NegamaxTotals.internal)
    .. " cutoffs=" .. tostring(NegamaxTotals.cutoffs)
    .. " memDeltaKB=" .. string.format("%.2f", NegamaxTotals.memDeltaKB)
    .. " memPeakDeltaKB=" .. string.format("%.2f", NegamaxTotals.memPeakDeltaKB)
    .. " memPeakKBMax=" .. string.format("%.2f", NegamaxTotals.memPeakKBMax))
end

function negamax(n,depth,alpha,beta,color)
	NegamaxStats.calls = NegamaxStats.calls + 1
	sampleNegamaxMemoryStats()

	if depth == 0 or n:isTerminal() then
		NegamaxStats.leafs = NegamaxStats.leafs + 1
		return color * Heuristic(n);	
	end

	local bestval = -math.huge;
	n:generateMoves();

  -- Order children by a cheap static estimate so alpha-beta can prune earlier.
  for _,child in ipairs(n.children) do
    child:setValue(color * Heuristic(child))
  end
  n:sort_children(1)

  for _,child in ipairs(n.children) do
    local val = -negamax(child,depth - 1, -beta, -alpha, -color);
    bestval = math.max(bestval,val);
    child:setValue(val);
    alpha = math.max(alpha,val);
    if alpha >= beta then
      NegamaxStats.cutoffs = NegamaxStats.cutoffs + 1
      break;
    end
  end
  
  -- Sort descending (1 = highest value first) since negamax values are always
  -- from the current player's perspective (higher = better).
  n:sort_children(1);
	
  return bestval;
end


function  minimax( n, depth, color )
    
  if depth == 0 or n:isTerminal() then
    return Heuristic(n)
  end
  
  n:generateMoves()
  --n:sort_children(n.color)
  
  if color == 1 then
        
    local bestval = -math.huge
        
    for key,child in pairs(n.children) do
      local val = minimax( child, (depth - 1), -color )
      child:setValue(val)
      bestval = math.max( val , bestval )
    end
        
    return bestval
      
    
  else 
    local bestval = math.huge
        
    for key,child in pairs(n.children) do
      local val = minimax( child, (depth - 1), -color )
      child:setValue(val)
      bestval = math.min( val, bestval )
    end
    
    return bestval
    
  end
end
