require "Globals"
require "Board"
require "Interact"

require "node"
require "negamax"



function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start(); end
	iteration = 1
	--max = 4
	--idle = false
	time = 0;
	frame = 0;
  turn = color;
  state = 0
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

  time = time + dt
  if turn == -1 then
  
    if AI == -1 then
      N:setValue(minimax(N,DEPTH,-1))
   
      if N.endgame == true then
        return
      end
    
      N:sort_children(N.color);

        
      assert( N.num_children > 0 , "No children created ")

      mv = N.children[1].mv;

      N = N:getChildWithMove(mv);
    else
        if state ~= 2 then
          return;
        end
    
        if N:validate(mv) then
          N:setValue(minimax(N,DEPTH,1))  
          N = N:getChildWithMove(mv);
        end
      end
      

    print("Goats Dead:",N.goatsDead)

    turn = -turn;
    iteration = iteration + 1;
    mv = nil
    state = 0
  else
    if AI == -1 then
      if state ~= 2 then
        return;
      end
      
      if N:validate(mv) then
        N:setValue(minimax(N,DEPTH,1))  
        --N:setValue(negamax(N,DEPTH,math.huge,-math.huge,1))

        --N:addMove(mv)
        N = N:getChildWithMove(mv);
        --N:update();
      end
      
    else
      N:setValue(minimax(N,DEPTH,-1))
   
      if N.endgame == true then
        return
      end
    
      N:sort_children(N.color);

        
      assert( N.num_children > 0 , "No children created ")

      mv = N.children[1].mv;

      N = N:getChildWithMove(mv);
    end
      
    assert(N ~= nil, "No child found")
    print("Goats on Board:",N.goatsBoard)
    print("Tigers Blocked:", N.tigersBlocked)
    --assert( N.children[1] , "No children created ")

  
    --N.A = N.postA;
    turn = -turn;
    iteration = iteration + 1;
    mv = nil
    state = 0
 
    
  end

end


function love.draw()
	love.graphics.clear();
	love.graphics.reset();
  love.graphics.draw(board, myquad, 0, 0);
	drawBoard(SIZE,BSIZE);
  love.graphics.reset();
  frame = frame + 1;

  love.graphics.print(tostring(time),200,10)
  love.graphics.print("framerate"..tostring(frame/time),400,10)
	for i=1,5 do
    for j = 1,5 do
      if N.A[i][j] ~= nil then
        if N.A[i][j] == 1 then
          --love.graphics.setColor(254,100,46,255);
            love.graphics.draw(goat,gquad,GAP*(i-1),GAP*(j-1));
        elseif N.A[i][j] == -1 then
          love.graphics.draw(tiger,tquad,GAP*(i-1),GAP*(j-1));
        end
        if N.A[i][j] ~= 0 then
        end
      end
    end
    
	end
    if N.goatsDead > 5 then
    love.graphics.print("Tigers Win",10,10)
    return
  elseif N.endgame then
    love.graphics.print("Goats Win",10,10)
    return
  end
  --mv = {};
end

function love.mousepressed( x , y , button , isTouch)
	local gap = (SIZE-BSIZE)/4;
	local NearList = {};

  if turn == AI then
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
    
    if state == 0 then -- Versions prior to 0.10.0 use the MouseConstant 'l'
      mv = {}
      if N.A[x][y] == 1 or N.A[x][y] == -1 then
        mv.src = {}
        mv.src.x = x
        mv.src.y = y
        state = 1
      else
        mv.dst = {}
        mv.dst.x = x
        mv.dst.y = y
        state = 2
      end
      
    elseif state == 1 then
      mv.dst = {}
      mv.dst.x = x
      mv.dst.y = y
      state = 2
    end
    mv.color = turn
    print("Mouse clicked at",x,y);
  end
  

end

