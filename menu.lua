require "Globals"

function newButton(text,fn)
  return {
            text = text;
            fn = fn;
            last = false;
            now = false;
          }
end
 
AllButtonsMenu = {};
 
function newGame()
end
 
function settings()
end
 
function exitfn()
end

 
function createMenu()
    table.insert(AllButtonsMenu,1,newButton("New Game",newGame));
    table.insert(AllButtonsMenu,2,newButton("Settings", settings));
    table.insert(AllButtonsMenu,3,newButton("Exit", exitfn));
end

function drawMenu()
  local ww = love.graphics.getWidth();
  local hh = love.graphics.getHeight();
  
  --love.graphics.setBackgroundColor(0,0.5,0.5,1);
  love.graphics.clear();
  love.graphics.reset();
  love.graphics.draw(menu, menuquad, 0, 0);
  love.graphics.reset();
  
  
  local margin = 16;
  local buttonWidth = ww/4;
  local totalHeight = (BUTTON_HEIGHT) + margin * #AllButtonsMenu;
  local pos = 0;
  local titleTextW = font_64:getWidth(titleText);
  local titleTextH = font_64:getHeight(titleText);
  
  
  love.graphics.setColor(0.5,0,0,1);
  love.graphics.print(titleText,font_64,(ww/2) - (titleTextW/2), hh/5);
  
  for i,button in ipairs(AllButtonsMenu) do
    --print(i);
    local bx = (ww/2) - (buttonWidth/2);
    local by = (hh/2) - (BUTTON_HEIGHT/2) - (totalHeight/2) + pos;
    
    love.graphics.setColor(1,215/255,0,1);
    
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

  
  