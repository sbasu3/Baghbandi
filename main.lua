require "Globals"
require "Board"
require "Interact"

require "node"
require "negamax"
require "menu"
require "settings"

socket = require("socket")
--suit = require ("ui")

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
  aiWaitTimer = 0;
  
  --whose turn is it
  turn = 1;
  
  --mouse state
  state = 0

  N = node:new()

  mv = {};
  mv["src"] = nil
  mv["dst"] = nil
  
	--love.graphics.setMode(SIZE,SIZE,false,true,0);
  local width, height = love.graphics.getDimensions()
  osString = love.system.getOS()
  print(osString);
  if osString == "Linux" then
    OS = 1; -- Linux == 1
  elseif osString == "Android" then
    OS = 2; -- Android == 2
    BUTTON_HEIGHT = height/10;
  else
    OS = 3;
  end
  
  print(OS);
  
  if OS == 2 then
    touchX = 0;
    touchY = 0;
  end
  
  
  --local wd = love.graphics.getWidth()
  --local ht = love.graphics.getHeight()
    
  print(width)
  print(height)
  
  SIZE = height;

  BORDER = 32;
  BSIZE = BORDER;
  
  OFFSETX = 0;
  OFFSETY = 0;
  GAP = (SIZE-2*BSIZE)/4;
  
  TIGERSIZE = height/8;
  GOATSIZE = height/8;
  
  TEXTWRAP = 100;
  
  Radius = 0.05*height;
  SIDE = 0.707*Radius;

	love.window.setMode(SIZE + 5*BSIZE,SIZE,{fullscreen = false,vsync = true,resizable = false, borderless = false,centered = false});
  love.window.setTitle("Baghbandi");
  
  font_12 = love.graphics.newFont("assets/PartyConfettiRegular-eZOn3.ttf",12);
  font_16 = love.graphics.newFont("assets/PartyConfettiRegular-eZOn3.ttf",16);
  font_20 = love.graphics.newFont("assets/PartyConfettiRegular-eZOn3.ttf",20);
  font_32 = love.graphics.newFont("assets/PartyConfettiRegular-eZOn3.ttf",32);
  font_64 = love.graphics.newFont("assets/PartyConfettiRegular-eZOn3.ttf",64);

  timeText = love.graphics.newText(font_12, {{1, 1, 0},""});
  FPSText = love.graphics.newText(font_12, {{1, 1, 0},""});
  turnText = love.graphics.newText(font_12, {{1, 1, 0},""});
  goatsText = love.graphics.newText(font_12 ,{{1,1,0},""});
  tigersText = love.graphics.newText(font_12 ,{{1,1,0},""});
  goatsDeadText = love.graphics.newText(font_12 ,{{1,1,0},""});
  howToText = love.graphics.newText(font_20,{{0,0,0,1},howToMessage});
  
  
	board = love.graphics.newImage("assets/images/back.png");
	goat = love.graphics.newImage("assets/images/goat.png");
	tiger = love.graphics.newImage("assets/images/tiger.png");
  menu = love.graphics.newImage("assets/images/44780.jpg");
  mute = love.graphics.newImage("assets/images/icons8-no-audio-50.png");
  
	myquad = love.graphics.newQuad(0 , 0, SIZE, SIZE , SIZE, SIZE);
	gquad = love.graphics.newQuad(0,0,TIGERSIZE,TIGERSIZE,TIGERSIZE,TIGERSIZE);
	tquad = love.graphics.newQuad(0,0,0.6*GOATSIZE,GOATSIZE,0.6*GOATSIZE,GOATSIZE);
  menuquad = love.graphics.newQuad(0 , 0, width, height , width, height);
  mutequad = love.graphics.newQuad(0,0,width/20,width/20,width/20,width/20);
  
  sourceMain = love.audio.newSource( "assets/sounds/554__bebeto__ambient-loop.mp3", "stream");
  sourceMain:setLooping(true)
  --only for debug
  --sourceMain:play();
  
  sourceGame = love.audio.newSource("assets/sounds/103120__andylist__first-909-drum-loop.wav","stream");
  sourceGame:setLooping(true);
  
  sourceEvent = love.audio.newSource("assets/sounds/220184__gameaudio__win-spacey.wav","stream");

  settingsMenu = ui:new(1);

  settingsText = "Settings";
  
  createMenu();
  createSettings();
  uistate = 1;
  
end


function love.update(dt)

  time = time + dt

  if uistate == 3 then
    -- check game over first (bug 9: moved out of drawGame)
    if N.goatsDead > 5 then
      love.window.showMessageBox( "Tigers WIN", "", info, true );
      uistate = 1;
      return;
    elseif N.endgame then
      love.window.showMessageBox( "Goats WIN", "", info, true );
      uistate = 1;
      return;
    end

    if AI == turn then
      -- bug 8: use dt-based timer instead of blocking socket.sleep
      aiWaitTimer = aiWaitTimer + dt;
      if aiWaitTimer >= 1 then
        aiWaitTimer = 0;
        aiMove();
        sourceEvent:play();
      end
    else
      playerMove();
    end

    if AI == turn then
      assert(N ~= nil, "No child found");
      print("Goats on Board:",N.goatsBoard);
      print("Tigers Blocked:", N.tigersBlocked);
      print("Goats Dead:",N.goatsDead);
    end
  end

end

function drawGame()
  
  sourceMain:stop();
  sourceGame:play();
  
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
  goatsText:set("Goat's on Board: ")
  tigersText:set("Tiger's Blocked : ")
  goatsDeadText:set("Goat's Dead : ")
  
  if N.goatsDead > 5 then
    turnText:set("TIGER's WIN!");
  elseif N.endgame then
    turnText:set("GOAT's WIN !");
  elseif turn == 1 then
    turnText:set("Goat's Turn!!")
  else
    turnText:set("Tiger's Turn!!")
  end
  
  
  timeText:addf(tostring(math.floor(time)),TEXTWRAP,"right")
  FPSText:addf(tostring(math.floor(frame/time)),TEXTWRAP,"right")
  goatsText:addf(tostring(N.goatsBoard),TEXTWRAP,"right")
  tigersText:addf(tostring(N.tigersBlocked),TEXTWRAP,"right")
  goatsDeadText:addf(tostring(N.goatsDead),TEXTWRAP,"right")
  
  
  love.graphics.draw(timeText,SIZE+BSIZE/2,10)
  love.graphics.draw(FPSText,SIZE+BSIZE/2,30)
  love.graphics.draw(goatsText,SIZE+BSIZE/2,60)
  love.graphics.draw(tigersText,SIZE+BSIZE/2,90)
  love.graphics.draw(goatsDeadText,SIZE+BSIZE/2,120)
  
  love.graphics.draw(turnText,SIZE+BSIZE/2,SIZE/2)
  
  
  
  
	for i=1,5 do
    for j = 1,5 do
      if N.A[i][j] ~= nil then
        if N.A[i][j] == 1 then
          --love.graphics.setColor(254,100,46,255);
          --love.graphics.draw(goat,gquad,BSIZE+GAP*(i-1),BSIZE+GAP*(j-1));
          if OS == 1 then
            love.graphics.draw(goat,gquad,GAP*(i-1),GAP*(j-1));
          else
            love.graphics.draw(goat,gquad,GAP*(i-1)-OFFSETX,GAP*(j-1)-OFFSETY);
          end
          
        elseif N.A[i][j] == -1 then
          --love.graphics.draw(tiger,tquad,BSIZE+GAP*(i-1),BSIZE+GAP*(j-1));
          
          if OS == 1 then
            love.graphics.draw(tiger,tquad,GAP*(i-1),GAP*(j-1));
          else
            love.graphics.draw(tiger,tquad,GAP*(i-1)-OFFSETX,GAP*(j-1)-OFFSETY);
          end
          
        end
        if N.A[i][j] ~= 0 then
        end
      end
    end
    
	end
  
end

function love.draw()
  if uistate == 1 then
    drawMenu();
  elseif uistate == 2 then
    --drawSettings();
    settingsMenu:draw();
    --suit.draw();
  elseif uistate == 3 then
    drawGame();
  elseif uistate ==4 then
    drawHowTo();
  end
  
end

function love.mousepressed( x , y , button , isTouch)

	local NearList = {};

  if turn == AI then
    return
  end
  --love.graphics.print("Click",x,y)


  for i = 1,5 do
    NearList[i] = {}
    for j =1,5 do
      --NearList[ (i-1)*5 + j] = distance(x,y,BSIZE+gap*(j-1),BSIZE+gap*(i-1));
      NearList[i][j] = distance(x,y,BSIZE+GAP*(i-1),BSIZE+GAP*(j-1));
    end
  end
  local bx,by = GetMin(NearList);
  
  if state == 0 then -- Versions prior to 0.10.0 use the MouseConstant 'l'
    mv = {}
    if N.A[bx][by] == turn then
      mv.src = {}
      mv.src.x = bx
      mv.src.y = by
      state = 1
    else
      mv.dst = {}
      mv.dst.x = bx
      mv.dst.y = by
      state = 2
    end
    
  elseif state == 1 then
    mv.dst = {}
    mv.dst.x = bx
    mv.dst.y = by
    state = 2
  end
  mv.color = turn
  print("Mouse clicked at",bx,by);

end

function love.touchpressed( id, x, y, dx, dy, pressure )

  touchX = x;
  touchY = y;
  released = false;
end

function love.touchreleased( id, x, y, dx, dy, pressure )
  touchX = x;
  touchY = y;
  released = true;
end

