require "Globals"
--require "GameLogic"
require "Board"
require "Interact"

--g = require "gamestate"
local g = require('gamestate').create()

function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start(); end
	iteration = 1
	max = 4
	idle = false
	time = 0;
	frame = 0;
  --GS = g.create()
  mv = {};
  mv["src"] = nil
  mv["dst"] = nil
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
	--turn();
	--GS = GameState(A);	
	--print(GS[1],GS[2],GS[3],GS[4]);
end


function love.draw()
	love.graphics.clear();
	love.graphics.reset();
  love.graphics.draw(board, myquad, 0, 0);
	drawBoard(SIZE,BSIZE);
  love.graphics.reset();
	for i=1,5 do
    for j = 1,5 do
      if g.A[i][j] ~= nil then
        if g.A[i][j] == 1 then
          --love.graphics.setColor(254,100,46,255);
            love.graphics.draw(goat,gquad,GAP*(i-1),GAP*(j-1));
        elseif g.A[i][j] == -1 then
          --love.graphics.setColor(154,46,254,255);	  
          love.graphics.draw(tiger,tquad,GAP*(i-1),GAP*(j-1));
        end
        if g.A[i][j] ~= 0 then
          --love.graphics.circle("fill",BSIZE+GAP*((i-1)%5),BSIZE+GAP*math.floor((i-1)/5),10, 100);
        end
      end
    end
    
	end
end

function love.mousepressed( x , y , button , isTouch)
	local gap = (SIZE-BSIZE)/4;
	local NearList = {};

	if button == 1 then
		for i = 1,5 do
      NearList[i] = {}
			for j =1,5 do
				--NearList[ (i-1)*5 + j] = distance(x,y,BSIZE+gap*(j-1),BSIZE+gap*(i-1));
        NearList[i][j] = distance(x,y,BSIZE+gap*(j-1),BSIZE+gap*(i-1));
			end
		end
		local x,y = GetMin(NearList);
    
    if button == 1 then -- Versions prior to 0.10.0 use the MouseConstant 'l'
      if mv.src == nil then
        mv.src = {}
        mv.src.x = x
        mv.src.y = y
      else
        mv.dst = {}
        mv.dst.x = x
        mv.dst.y = y
      end
      
   end
		print("Mouse clicked at",x,y);
	end
end