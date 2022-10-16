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

	bestval = -math.huge;
	n:generateMoves();
	
  n:sort_children();
  
	for key,child in pairs(n.children) do
		val = -negamax(child,depth -1, -beta, -alpha , -color);
		bestval = math.max(bestval,val);
    n:set_value(bestval);
		alpha = math.max(alpha,val);
		if alpha >= beta then
			break;
		end
	end
  

	
  return bestval;
end
