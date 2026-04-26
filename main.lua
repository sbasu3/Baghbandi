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

function showPopup(title,message,duration,onClose)
  popup = {
    title = title or "",
    message = message or "",
    timer = duration,
    onClose = onClose
  }
end

function closePopup()
  if popup == nil then
    return
  end

  local cb = popup.onClose
  popup = nil
  if cb ~= nil then
    cb()
  end
end

function isInsideRect(px, py, x, y, w, h)
  return (px >= x) and (px <= x + w) and (py >= y) and (py <= y + h)
end

function getBackButtonRect()
  local ww = love.graphics.getWidth()
  local hh = love.graphics.getHeight()
  local w = math.max(120, ww * 0.08)
  local h = math.max(44, hh * 0.055)
  local margin = 20
  local x = ww - w - margin
  local y = hh - h - margin
  return x, y, w, h
end

function drawBackButton()
  local x, y, w, h = getBackButtonRect()
  local mx = 0
  local my = 0

  if OS == 2 then
    mx = touchX
    my = touchY
  else
    mx, my = love.mouse.getPosition()
  end

  local hot = isInsideRect(mx, my, x, y, w, h)

  if hot then
    love.graphics.setColor(1,1,0,1)
  else
    love.graphics.setColor(1,215/255,0,1)
  end

  love.graphics.rectangle("fill", x, y, w, h, 8, 8)
  love.graphics.setColor(0,0,0,1)

  local label = "< Back"
  local textW = font_20:getWidth(label)
  local textH = font_20:getHeight(label)
  love.graphics.print(label, font_20, x + (w - textW) / 2, y + (h - textH) / 2)
end

function handleBackButtonPress(x, y)
  local bx, by, bw, bh = getBackButtonRect()
  if not isInsideRect(x, y, bx, by, bw, bh) then
    return false
  end

  if uistate == 1 then
    love.event.quit()
    return true
  end

  if uistate == 3 then
    resetMatch()
  end

  uistate = 1
  return true
end

function drawPopup()
  if popup == nil then
    return
  end

  local ww = love.graphics.getWidth()
  local hh = love.graphics.getHeight()
  local w = math.max(ww * 0.5, 420)
  local h = math.max(hh * 0.5, 260)
  local x = (ww - w) / 2
  local y = (hh - h) / 2

  love.graphics.setColor(0,0,0,0.6)
  love.graphics.rectangle("fill",0,0,ww,hh)

  love.graphics.setColor(0.98,0.9,0.45,1)
  love.graphics.rectangle("fill",x,y,w,h,12,12)
  love.graphics.setColor(0.2,0.1,0.05,1)
  love.graphics.setLineWidth(4)
  love.graphics.rectangle("line",x,y,w,h,12,12)

  love.graphics.setColor(0.2,0.1,0.05,1)
  local titleY = y + h * 0.18
  local bodyY = y + h * 0.5
  local title = popup.title
  local body = popup.message

  if title ~= "" then
    love.graphics.printf(title,font_64,x + 20,titleY,w - 40,"center")
  end

  if body ~= "" then
    love.graphics.printf(body,font_20,x + 30,bodyY,w - 60,"center")
  end
end

function resetMatch()
  iteration = 1
  turn = 1
  state = 0
  aiWaitTimer = 0
  N = node:new()
  popup = nil

  mv = {}
  mv.src = nil
  mv.dst = nil
end


function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start(); end
	--max = 4
	--idle = false
	time = 0;
	frame = 0;
  resetMatch()
  
	--love.graphics.setMode(SIZE,SIZE,false,true,0);
  local width, height = love.graphics.getDimensions()
  local windowWidth = 1920
  local windowHeight = 1080
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
  
  love.window.setMode(windowWidth,windowHeight,{fullscreen = false,vsync = true,resizable = false, borderless = false,centered = false});
  love.window.setTitle("Baghbandi");

  width, height = love.graphics.getDimensions()
  SIZE = height;

  BORDER = 32;
  BSIZE = BORDER;
  BOARD_ORIGIN_X = BSIZE;
  BOARD_ORIGIN_Y = BSIZE;
  
  OFFSETX = 0;
  OFFSETY = 0;
  GAP = (SIZE-2*BSIZE)/4;
  
  TIGERSIZE = height/8;
  GOATSIZE = height/8;
  
  TEXTWRAP = 100;
  
  Radius = 0.05*height;
  SIDE = 0.707*Radius;
  MUTE_ICON_SIZE = 2 * SIDE;
  
  font_12 = love.graphics.newFont("assets/PartyConfettiRegular-eZOn3.ttf",12);
  font_16 = love.graphics.newFont("assets/PartyConfettiRegular-eZOn3.ttf",16);
  font_20 = love.graphics.newFont("assets/PartyConfettiRegular-eZOn3.ttf",20);
  font_32 = love.graphics.newFont("assets/PartyConfettiRegular-eZOn3.ttf",32);
  font_64 = love.graphics.newFont("assets/PartyConfettiRegular-eZOn3.ttf",64);

  timeText = love.graphics.newText(font_12, {{1, 1, 0},""});
  FPSText = love.graphics.newText(font_12, {{1, 1, 0},""});
  turnText = love.graphics.newText(font_12, {{1, 1, 0},""});
  rolesText = love.graphics.newText(font_12, {{1, 1, 0},""});
  goatsText = love.graphics.newText(font_12 ,{{1,1,0},""});
  tigersText = love.graphics.newText(font_12 ,{{1,1,0},""});
  goatsDeadText = love.graphics.newText(font_12 ,{{1,1,0},""});
  howToText = love.graphics.newText(font_20,{{0,0,0,1},howToMessage});
  
  
	board = love.graphics.newImage("assets/images/back.png");
	goat = love.graphics.newImage("assets/images/goat.png");
	tiger = love.graphics.newImage("assets/images/tiger.png");
  menu = love.graphics.newImage("assets/images/44780.jpg");
  mute = love.graphics.newImage("assets/images/icons8-no-audio-50.png");
  muteScale = MUTE_ICON_SIZE / mute:getWidth();
  
	myquad = love.graphics.newQuad(0 , 0, SIZE, SIZE , SIZE, SIZE);
	gquad = love.graphics.newQuad(0,0,TIGERSIZE,TIGERSIZE,TIGERSIZE,TIGERSIZE);
	tquad = love.graphics.newQuad(0,0,0.6*GOATSIZE,GOATSIZE,0.6*GOATSIZE,GOATSIZE);
  menuquad = love.graphics.newQuad(0 , 0, width, height , width, height);
  mutequad = love.graphics.newQuad(0,0,mute:getWidth(),mute:getHeight(),mute:getWidth(),mute:getHeight());
  
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

  if popup ~= nil then
    if popup.timer ~= nil then
      popup.timer = popup.timer - dt
      if popup.timer <= 0 then
        closePopup()
      end
    end
  end

  if uistate == 3 then
    -- check game over first (bug 9: moved out of drawGame)
    if N.goatsDead > 5 then
      showPopup("Tigers WIN","",2.0)
      uistate = 1;
      return;
    elseif N.endgame then
      showPopup("Goats WIN","",2.0)
      uistate = 1;
      return;
    end

    if AI == turn then
      aiMove();
      sourceEvent:play();
    else
      playerMove();
    end

    if AI == turn then
      assert( N ~= nil, "N is nil in update" );
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
  local boardScaleX = SIZE / board:getWidth();
  local boardScaleY = SIZE / board:getHeight();
  love.graphics.draw(board, 0, 0, 0, boardScaleX, boardScaleY);
	drawBoard(SIZE,BSIZE);
  love.graphics.reset();
  frame = frame + 1;
  
  timeText:clear()
  FPSText:clear()
  turnText:clear()
  rolesText:clear()
  goatsText:clear()
  tigersText:clear()
  goatsDeadText:clear()
  
  timeText:set("Time : ")
  FPSText:set("FPS : ")
  goatsText:set("Goat's on Board: ")
  tigersText:set("Tiger's Blocked : ")
  goatsDeadText:set("Goat's Dead : ")

  local playerRole = "Goat"
  local aiRole = "Tiger"
  if PLAYER == -1 then
    playerRole = "Tiger"
    aiRole = "Goat"
  end
  rolesText:set("You: " .. playerRole .. " | AI: " .. aiRole)
  
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
  love.graphics.draw(rolesText,SIZE+BSIZE/2,150)
  
  love.graphics.draw(turnText,SIZE+BSIZE/2,SIZE/2)
  
  
  
  
	for i=1,5 do
    for j = 1,5 do
      if N.A[i][j] ~= nil then
        local nodeX = BOARD_ORIGIN_X + GAP * (i - 1)
        local nodeY = BOARD_ORIGIN_Y + GAP * (j - 1)

        if N.A[i][j] == 1 then
          local goatW = TIGERSIZE
          local goatH = TIGERSIZE
          love.graphics.draw(goat,gquad,nodeX - (goatW/2),nodeY - (goatH/2));
          
        elseif N.A[i][j] == -1 then
          local tigerW = 0.6 * GOATSIZE
          local tigerH = GOATSIZE
          love.graphics.draw(tiger,tquad,nodeX - (tigerW/2),nodeY - (tigerH/2));
          
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

  drawBackButton()

  drawPopup()
  
end

function love.mousepressed( x , y , button , isTouch)

  if popup ~= nil then
    closePopup()
    return
  end

  if handleBackButtonPress(x, y) then
    return
  end

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

  if popup ~= nil then
    closePopup()
    return
  end

  touchX = x;
  touchY = y;
  released = false;
end

function love.touchreleased( id, x, y, dx, dy, pressure )
  touchX = x;
  touchY = y;
  released = true;

  if popup ~= nil then
    closePopup()
    return
  end

  if handleBackButtonPress(x, y) then
    return
  end
end

