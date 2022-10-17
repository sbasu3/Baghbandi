require "Globals"
--require "GameLogic"
require "Board"
require "Interact"

--local socket = require "socket"

--[[
function sleep(sec)
    socket.select(nil, nil, sec)
end
]]--
--gs = require  "gamestate"

require "node"
require "negamax"



function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start(); end
	iteration = 1
	max = 4
	idle = false
	time = 0;
	frame = 0;
  turn = color;
  --local g = GS:new()
  
  --g = GS:makeCopy(g)
  --g = require('gamestate').create()
  --N = require('node').create(g,math.random(1,1000))
  --N = node:clone(math.random(1,1000))

  N = node:new()

  --GS = g.create()
  --N = require('node').create(g,math.random());
  --print(N.data.A[1][1]);

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



  
  if turn == -1 then
  
    N.color = -1
    N:setValue(minimax(N,DEPTH,N.color))

    N:sort_children();
    assert( N.children[1] , "No children created ")

    mv = N.children[1].mv;
    mv.color = -1;
    N:addMove(mv);
    N:apply();
    print("Goats Dead:",N.goatsDead)

    turn = -turn;
    iteration = iteration + 1;
    mv = {}
  else
    --mv = {}
 
    
    
    if mv == nil or mv.dst == nil then
      return;
    end
    
    if N:validate(mv) then
      N:setValue(minimax(N,DEPTH,1))  
      N:addMove(mv)
      N = N:getChildWithMove(mv);
      --N:update();
      assert(N ~= nil, "No child found")
      print("Goats on Board:",N.goatsBoard)
      --assert( N.children[1] , "No children created ")

    
      --N.A = N.postA;
      turn = -turn;
      mv = {};
    
    else
      return
    end
    
  end

end


function love.draw()
	love.graphics.clear();
	love.graphics.reset();
  love.graphics.draw(board, myquad, 0, 0);
	drawBoard(SIZE,BSIZE);
  love.graphics.reset();
  frame = frame + 1;
  --local gs = N;
  
	for i=1,5 do
    for j = 1,5 do
      if N.A[i][j] ~= nil then
        if N.A[i][j] == 1 then
          --love.graphics.setColor(254,100,46,255);
            love.graphics.draw(goat,gquad,GAP*(i-1),GAP*(j-1));
        elseif N.A[i][j] == -1 then
          --love.graphics.setColor(154,46,254,255);	  
          love.graphics.draw(tiger,tquad,GAP*(i-1),GAP*(j-1));
        end
        if N.A[i][j] ~= 0 then
          --love.graphics.circle("fill",BSIZE+GAP*((i-1)%5),BSIZE+GAP*math.floor((i-1)/5),10, 100);
        end
      end
    end
    
	end
  --mv = {};
end

function love.mousepressed( x , y , button , isTouch)
	local gap = (SIZE-BSIZE)/4;
	local NearList = {};
  
  if turn == -1 then
    return
  end
  --love.graphics.print("Click",x,y)

	if button == 1 then
		for i = 1,5 do
      NearList[i] = {}
			for j =1,5 do
				--NearList[ (i-1)*5 + j] = distance(x,y,BSIZE+gap*(j-1),BSIZE+gap*(i-1));
        NearList[i][j] = distance(x,y,BSIZE+gap*(i-1),BSIZE+gap*(j-1));
			end
		end
		local x,y = GetMin(NearList);
    
    if button == 1 then -- Versions prior to 0.10.0 use the MouseConstant 'l'
      if mv.src == nil and N.A[x][y] == 1 then
        mv.src = {}
        mv.src.x = x
        mv.src.y = y
      else
        mv.dst = {}
        mv.dst.x = x
        mv.dst.y = y
      end
  
    end
     mv.color = turn
		print("Mouse clicked at",x,y);
	end
end