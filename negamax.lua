--[
--Description : Negamax is a Pruning Method of Min-Max Algorithm.
--             This implementation is dependent on GenerateMoves and OrderMoves
--Author : Subhojit Basu
--Date : 21 May 2014
--]

require "moveUtils"
--require "graph";

function negamax(node,depth,alpha,beta,color)
	if depth == 0 or is_Terminal(node) then
		return color * Heuristic(node);	
	end

	bestval = -math.huge;
	childnodes = GenerateMoves(node);
	childnodes = OrderMoves(childnodes);

	for key,child in pairs(childnodes) do
		val = -negamax(child,depth -1, -beta, -alpha , -color);
		bestval = math.max(bestval,val);
		alpha = math.max(alpha,val);
		if alpha >= beta then
			break;
		end
	end

	return bestval;
end
