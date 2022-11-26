function drawBoard(N,K)
	local Points;
	local Lines;
	--local gap = (N - 2*K)/4; 

	love.graphics.setColor(138/255,43/255,226/255,1);
	love.graphics.setLineWidth(3);
	love.graphics.setLineStyle("smooth");
	--love.graphics.setLine(5,"smooth");

	for i = 1,5 do			--iTH vertical line
		love.graphics.line( K + GAP * (i-1) , K , K + GAP * (i-1) , N - K );
	end

	for i = 1,5 do			--ith Horizontal line
		love.graphics.line(K,K + GAP * (i-1),N - K,K + GAP * (i-1) );
	end

	-- Diagonals
	love.graphics.line(K , K , N - K , N - K);
	love.graphics.line(K , N - K , N - K , K);
	love.graphics.line(K, N/2, N/2, N-K);
	love.graphics.line(K, N/2 ,N/2 , K);
	love.graphics.line(N/2 , N-K , N-K , N/2);
	love.graphics.line(N/2, K , N-K, N/2);
end
