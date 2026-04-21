--[
--Description : Negamax is a Pruning Method of Min-Max Algorithm.
--             This implementation is dependent on GenerateMoves and OrderMoves
--Author : Subhojit Basu
--Date : 21 May 2014
--]

--require "moveUtils"
require "node"
--require "graph";

function negamax(n,depth,alpha,beta,color)
	if depth == 0 or n:isTerminal() then
		return color * Heuristic(n);	
	end

	local bestval = -math.huge;
	n:generateMoves();
	
  n:sort_children(n.color);
  
	for key,child in pairs(n.children) do
		local val = -negamax(child,depth -1, -beta, -alpha , -color);
		bestval = math.max(bestval,val);
    child:setValue(val);
		alpha = math.max(alpha,val);
		if alpha >= beta then
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
