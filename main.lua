require "Globals"
require "GameLogic"
require "Board"
require "Interact"

function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start(); end
	iteration = 1
	max = 4
	idle = false
	time = 0;
	frame = 0;
	--love.graphics.setMode(SIZE,SIZE,false,true,0);
	love.window.setMode(SIZE,SIZE,{fullscreen = false,vsync = true,resizable = false, borderless = false,centered = false});
	board = love.graphics.newImage("assets/images/back.png");
	goat = love.graphics.newImage("assets/images/goat.png");
	tiger = love.graphics.newImage("assets/images/tiger.png");
	myquad = love.graphics.newQuad(0 , 0, SIZE, SIZE , SIZE, SIZE);
	gquad = love.graphics.newQuad(0,0,100,100,100,100);
	tquad = love.graphics.newQuad(0,0,60,100,60,100);
end


function love.update(dt)
	time = time + dt;
	if time > 60 then
		exit = true;
	end
	turn();
	--GS = GameState(A);	
	--print(GS[1],GS[2],GS[3],GS[4]);
end


function love.draw()
	love.graphics.clear();
	love.graphics.reset();
  love.graphics.draw(board, myquad, 0, 0);
	drawBoard(SIZE,BSIZE);
  love.graphics.reset();
	for i=1,25 do
		if A[i] ~= nil then
			if A[i] == "G" then
				--love.graphics.setColor(254,100,46,255);
          love.graphics.draw(goat,gquad,GAP*((i-1)%5),GAP*math.floor((i-1)/5));
			elseif A[i] == "T" then
				--love.graphics.setColor(154,46,254,255);	  
        love.graphics.draw(tiger,tquad,GAP*((i-1)%5),GAP*math.floor((i-1)/5));
			end
			if A[i] ~= "_" then
				--love.graphics.circle("fill",BSIZE+GAP*((i-1)%5),BSIZE+GAP*math.floor((i-1)/5),10, 100);
			end
		end
	end
end
	
