require "ui"
--require ("suit")

local DEPTH_MIN = 1
local DEPTH_MAX = 4
local DEPTH_LABEL_BUTTON = nil

local function clampDepth(d)
  if d < DEPTH_MIN then
    return DEPTH_MIN
  end
  if d > DEPTH_MAX then
    return DEPTH_MAX
  end
  return d
end

local function updateDepthButtonText()
  if DEPTH_LABEL_BUTTON ~= nil and settingsMenu ~= nil
    and settingsMenu.buttonsList ~= nil
    and settingsMenu.buttonsList[DEPTH_LABEL_BUTTON] ~= nil then
    settingsMenu.buttonsList[DEPTH_LABEL_BUTTON].text = "Depth: " .. tostring(DEPTH)
  end
end

local function setDepth(d, label)
  local newDepth = clampDepth(d)
  local changed = (newDepth ~= DEPTH)
  DEPTH = newDepth
  updateDepthButtonText()

  if showPopup ~= nil then
    local popupLabel = label or "Depth Updated"
    showPopup(popupLabel, "Depth = " .. tostring(DEPTH))
  elseif changed then
    love.window.showMessageBox("Depth Updated", "Depth = " .. tostring(DEPTH), info, false)
  end
end

function selectTiger()
  PLAYER = -1;
  AI = 1;
  if showPopup ~= nil then
    showPopup("Playing as Tiger","")
  else
    love.window.showMessageBox( "Playing as Tiger", "", info, false );
  end
end

function selectGoat()
  PLAYER = 1;
  AI = -1;
  if showPopup ~= nil then
    showPopup("Playing as Goat","")
  else
    love.window.showMessageBox( "Playing as Goat", "", info, false );
  end
end

function selectBack()
  uistate = 1;
end

function selectEasy()
  setDepth(2, "Easy Selected")
end

function selectMedium()
  setDepth(3, "Medium Selected")
end

function selectHard()
  setDepth(4, "Hard Selected")
end

function selectDepthDown()
  setDepth(DEPTH - 1, "Depth Decreased")
end

function selectDepthUp()
  setDepth(DEPTH + 1, "Depth Increased")
end

function selectDepthInfo()
  if showPopup ~= nil then
    showPopup("Current Search Depth", tostring(DEPTH))
  else
    love.window.showMessageBox("Current Search Depth", tostring(DEPTH), info, false)
  end
end

function createSettings()
  local ww = love.graphics.getWidth();
  local hh = love.graphics.getHeight();
  
  local size = {x=ww/6,y=BUTTON_HEIGHT};
  
  settingsMenu:addButton("Goat",size,{x=ww/5,y=hh/3},selectGoat);
  settingsMenu:addButton("Tiger",size,{x=(3*ww)/5,y=hh/3},selectTiger);
  settingsMenu:addButton("Easy",size,{x=ww/5,y=(2*hh)/3},selectEasy);
  settingsMenu:addButton("Medium",size,{x=2*ww/5,y=(2*hh)/3},selectMedium);
  settingsMenu:addButton("Hard",size,{x=3*ww/5,y=(2*hh)/3},selectHard);

  local depthBtnSize = {x=ww/10,y=BUTTON_HEIGHT}
  local depthLabelSize = {x=ww/5,y=BUTTON_HEIGHT}
  settingsMenu:addButton("-", depthBtnSize, {x=ww/5,y=(5*hh)/6}, selectDepthDown)
  settingsMenu:addButton("Depth: " .. tostring(DEPTH), depthLabelSize, {x=2*ww/5,y=(5*hh)/6}, selectDepthInfo)
  DEPTH_LABEL_BUTTON = settingsMenu.buttons
  settingsMenu:addButton("+", depthBtnSize, {x=3*ww/5,y=(5*hh)/6}, selectDepthUp)

  updateDepthButtonText()
end
  
function drawSettingsSuit()
    local ww = love.graphics.getWidth();
    local hh = love.graphics.getHeight();
    local showMessage = {};
    -- put the layout origin at position (100,100)
    -- cells will grow down and to the right of the origin
    -- note the colon syntax
    suit.layout:reset(ww/10,hh/10)

    -- put 10 extra pixels between cells in each direction
    suit.layout:padding(ww/20,hh/20)
    
    for i,button in ipairs(settingsMenu) do
      
      if i ==1 then
        suit.Label("Play As:",suit.layout:col(ww/4,hh/10));
      elseif i == 3 then
        suit.layout:left();
        suit.layout:left();
        suit.Label("Difficulty:",suit.layout:row(ww/4,hh/10));
      elseif i == 6 then
        suit.layout:left();
        suit.layout:left();
      end
      
      
      if (i == 1 or i == 2 ) and suit.Button(button.text, {id=i}, suit.layout:col()).hit  then
          showMessage[i] = true
      end
      if (i == 3 or i == 4 or i == 5) and suit.Button(button.text, {id=i}, suit.layout:col(ww/10,hh/10)).hit  then
          showMessage[i] = true
      end
      
      if (i == 6) and suit.Button(button.text, {id=i}, suit.layout:row(ww/4,hh/10)).hit then
        uistate = 1;
      end
      


      -- if the button was pressed at least one time, but a label below
      if showMessage[i] then
          --suit.Label("i",suit.layout:row(ww/4,hh/10));
          if i == 1 then
            selectTiger();
          elseif i == 2 then
            selectGoat();
          elseif i == 3 then
            selectEasy();
          elseif i == 4 then
            selectMedium();
          elseif i == 5 then
            selectHard();
          end
          
      end
    end
  end
  


  
function drawSettings()
    
    local ww = love.graphics.getWidth();
    local hh = love.graphics.getHeight();
    
    --love.graphics.setBackgroundColor(0,0.5,0.5,1);
    love.graphics.clear();
    love.graphics.reset();
    love.graphics.draw(menu, menuquad, 0, 0);
    love.graphics.reset();
    
    
    local margin = 16;
    local buttonWidth = ww/5;
    local totalHeight = (BUTTON_HEIGHT) + margin * #settingsMenu;
    local pos = 0;
    local titleTextW = font_64:getWidth(settingsText);
    local titleTextH = font_64:getHeight(settingsText);

    love.graphics.setColor(0.5,0,0,1);
    love.graphics.print(settingsText,font_64,(ww/2) - (titleTextW/2), hh/5);
    
    for i,button in ipairs(settingsMenu) do
    --print(i);
    button.last = button.now;
    local bx = (ww/2) - (buttonWidth/2);
    local by = (hh/2) - (BUTTON_HEIGHT/2) - (totalHeight/2) + pos;
    
    if OS == 1 or OS == 3 then
      local mx,my = love.mouse.getPosition();
    
      local hot = (mx > bx) and (mx < (bx + buttonWidth)) and (my > by) and ( my < by + BUTTON_HEIGHT);
    
      if hot then
        love.graphics.setColor(1,1,0,1);
      else
        love.graphics.setColor(1,215/255,0,1);
      end
 
      button.now = love.mouse.isDown(1);
    
      if button.now and not button.last and hot then
        button.fn();
      end
    elseif OS == 2 then
      local mx = touchX;
      local my = touchY;
      
      local hot = (mx > bx) and (mx < (bx + buttonWidth)) and (my > by) and ( my < by + BUTTON_HEIGHT);

      if hot then
        love.graphics.setColor(1,1,0,1);
      else
        love.graphics.setColor(1,215/255,0,1);
      end
    
      if hot and released then
        button.fn()
      end
    end
    
    
    love.graphics.rectangle(
      "fill",
      bx,
      by,
      buttonWidth,
      BUTTON_HEIGHT
    );
    pos = pos + (BUTTON_HEIGHT + margin);
    love.graphics.setColor(0,0,0,1);
    
    local textW = font_20:getWidth(button.text);
    local textH = font_20:getHeight(button.text);
    
    love.graphics.print(button.text,font_20,(ww/2) - (textW/2),by + (textH/2));
  end
end
