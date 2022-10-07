--[
--Description : Negamax is a Pruning Method of Min-Max Algorithm.
--             This implementation is dependent on GenerateMoves and OrderMoves
--Author : Subhojit Basu
--Date : 21 May 2014
--]

require "moveUtils"
require "node"
--require "graph";

function negamax(node,depth,alpha,beta,color)
	if depth == 0 or node:isTerminal() then
		return color * Heuristic(node);	
	end

	bestval = -math.huge;
	generateMoves(node);
	node:sort_children();

	for key,child in pairs(node.children) do
		val = -negamax(child,depth -1, -beta, -alpha , -color);
		bestval = math.max(bestval,val);
    node:set_value(bestval);
		alpha = math.max(alpha,val);
		if alpha >= beta then
			break;
		end
	end

	return bestval;
end
