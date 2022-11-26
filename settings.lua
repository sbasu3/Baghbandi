--require "menu"


settingsMenu = {};

settingsText = "Settings";

function selectTiger()
  AI = 1;
  love.window.showMessageBox( "Playing as Tiger", "", info, true );
end

function selectGoat()
    AI = -1;
  love.window.showMessageBox( "Playing as Goat", "", info, true );
end

function selectBack()
  uistate = 1;
end

function selectEasy()
  DEPTH = 2;
   love.window.showMessageBox( "Easy Selected", "", info, true );
end

function selectMedium()
  DEPTH = 3;
  love.window.showMessageBox( "Medium Selected", "", info, true );
end

function selectHard()
  DEPTH = 4;
   love.window.showMessageBox( "Hard Selected", "", info, true );
end

function createSettings()
    table.insert(settingsMenu,1,newButton("Tiger",selectTiger));
    table.insert(settingsMenu,2,newButton("Goat", selectGoat));
    table.insert(settingsMenu,3,newButton("Easy",selectEasy));
    table.insert(settingsMenu,4,newButton("Medium", selectMedium));
    table.insert(settingsMenu,5,newButton("Hard", selectHard));
    table.insert(settingsMenu,6,newButton("Back", selectBack));
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