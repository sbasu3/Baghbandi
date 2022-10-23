require "Globals"
require "Board"
require "Interact"

require "node"
require "negamax"

socket = require("socket")

function sleep(sec)
    socket.sleep(sec)
end


function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start(); end
	iteration = 1
	--max = 4
	--idle = false
	time = 0;
	frame = 0;
  
  --whose turn is it
  turn = 1;
  
  --mouse state
  state = 0

  N = node:new()

  mv = {};
  mv["src"] = nil
  mv["dst"] = nil
  
	--love.graphics.setMode(SIZE,SIZE,false,true,0);
	love.window.setMode(SIZE + 5*BSIZE,SIZE,{fullscreen = false,vsync = true,resizable = false, borderless = false,centered = false});
  love.window.setTitle("Baghbandi");
  
  font_20 = love.graphics.newFont("assets/PartyConfettiRegular-eZOn3.ttf",20);
  font_32 = love.graphics.newFont("assets/PartyConfettiRegular-eZOn3.ttf",32);

  timeText = love.graphics.newText(font_20, {{1, 1, 0},""})
  FPSText = love.graphics.newText(font_20, {{1, 1, 0},""})
  turnText = love.graphics.newText(font_32, {{1, 1, 0},""})
  goatsText = love.graphics.newText(font_32 ,{{1,1,0},""})
  tigersText = love.graphics.newText(font_32 ,{{1,1,0},""})
  goatsDeadText = love.graphics.newText(font_32 ,{{1,1,0},""})
  
  
	board = love.graphics.newImage("assets/images/back.png");
	goat = love.graphics.newImage("assets/images/goat.png");
	tiger = love.graphics.newImage("assets/images/tiger.png");
	myquad = love.graphics.newQuad(0 , 0, SIZE, SIZE , SIZE, SIZE);
	gquad = love.graphics.newQuad(0,0,100,100,100,100);
	tquad = love.graphics.newQuad(0,0,60,100,60,100);
end


function love.update(dt)

  time = time + dt

  
  if AI == turn then
    sleep(1)
    aiMove()
  else
    playerMove()
  end

  if AI == turn then
    assert(N ~= nil, "No child found")
    print("Goats on Board:",N.goatsBoard)
    print("Tigers Blocked:", N.tigersBlocked)
    print("Goats Dead:",N.goatsDead)
  end


end


function love.draw()
	love.graphics.clear();
	love.graphics.reset();
  love.graphics.draw(board, myquad, 0, 0);
	drawBoard(SIZE,BSIZE);
  love.graphics.reset();
  frame = frame + 1;
  
  timeText:clear()
  FPSText:clear()
  turnText:clear()
  goatsText:clear()
  tigersText:clear()
  goatsDeadText:clear()
  
  timeText:set("Time : ")
  FPSText:set("FPS : ")
  goatsText:set("Goat's on Board : ")
  tigersText:set("Tiger's Blocked : ")
  goatsDeadText:set("Goat's Dead : ")
  
  if N.goatsDead > 5 then
    turnText:set("TIGER's WIN!")
  elseif N.endgame then
    turnText:set("GOAT's WIN !")
  elseif turn == 1 then
    turnText:set("Goat's Turn!!")
  else
    turnText:set("Tiger's Turn!!")
  end
  
  
  timeText:addf(tostring(math.floor(time)),250,"right")
  FPSText:addf(tostring(math.floor(frame/time)),250,"right")
  goatsText:addf(tostring(N.goatsBoard),250,"right")
  tigersText:addf(tostring(N.tigersBlocked),250,"right")
  goatsDeadText:addf(tostring(N.goatsDead),250,"right")
  
  
  love.graphics.draw(timeText,640,10)
  love.graphics.draw(FPSText,640,30)
  love.graphics.draw(goatsText,640,60)
  love.graphics.draw(tigersText,640,90)
  love.graphics.draw(goatsDeadText,640,120)
  
  love.graphics.draw(turnText,640,300)
  
  
  
  
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
      if N.A[x][y] == turn then
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

