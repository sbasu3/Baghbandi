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

howToMessage = "Baghbandi is a game of Tigers and Goats.You can select to play as Tiger or Goat vs AI. If you are playing as Tiger, the Objective is to eat Goats by jumping over them. Only One jump is allowed in a turn and teh destination location has to be free. That means you cannot jump over 2 or more goats. If you mange to eat 6 Goats you win the game. If the Tigers are cornered and do not have a valid move then they loose the game. If you are playing as Goat , you have 20 Goats at your disposal to place anywhere on the Board. However the Goats once placed cannot be moved until all Goats are placed. If you manage to corner the Tigers , you win. If you loose 6 Goats you loose.";
--policyMessage = "";

function newGame()
  uistate = 3;
end
 
function settings()
  uistate = 2;
end
 
function exitfn()
  love.event.quit()
end

function howTo()
  uistate = 4;
end

function drawHowTo()
    --love.window.showMessageBox( "How To Play", howToMessage, info, true );
  local ww = love.graphics.getWidth();
  local hh = love.graphics.getHeight();
  
  --love.graphics.setBackgroundColor(0,0.5,0.5,1);
  love.graphics.clear();
  love.graphics.reset();
  love.graphics.draw(menu, menuquad, 0, 0);
  love.graphics.reset();
  
  love.graphics.setColor(0,0,0,1);
  howToText:clear();
  howToText:addf(howToMessage,0.8*ww,"center");
  love.graphics.draw(howToText,(0.1*ww),(hh/4));
  --love.graphics.print(howToMessage,font_20,(ww/6),(hh/4));
end

 
function createMenu()
    table.insert(AllButtonsMenu,1,newButton("New Game",newGame));
    table.insert(AllButtonsMenu,2,newButton("Settings", settings));
    table.insert(AllButtonsMenu,3,newButton("How to Play",howTo));
    --table.insert(AllButtonsMenu,4,newButton("Privacy Policy", policy));
    table.insert(AllButtonsMenu,4,newButton("Exit", exitfn));
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
  local buttonWidth = ww/5;
  local totalHeight = (BUTTON_HEIGHT) + margin * #AllButtonsMenu;
  local pos = 0;
  local titleTextW = font_64:getWidth(titleText);
  local titleTextH = font_64:getHeight(titleText);
  
  --love.graphics.setColor(1,1,0,1);

  local x0 = 0.9*ww;
  local y0 = 0.05*hh;
  
  if OS == 1 then
    local mx,my = love.mouse.getPosition();

    local hot = (mx > x0) and (mx < (x0 + Radius)) and (my > y0) and ( my < y0 + Radius);
    local muteNow = love.mouse.isDown(1);
    if muteNow and hot then
      love.audio.stop();
    end
  elseif OS == 2 then
    local mx = touchX;
    local my = touchY;
    local hot = (mx > x0) and (mx < (x0 + Radius)) and (my > y0) and ( my < y0 + Radius);
    if hot and released then
      love.audio.stop();
    end
  end
  
  if hot then
    love.graphics.setColor(1,1,0,1);
  else
    love.graphics.setColor(1,215/255,0,1);
  end
  --love.graphics.circle("fill", x0, y0, Radius );
  love.graphics.draw(mute,mutequad,x0-SIDE,y0-SIDE);
  
  love.graphics.setColor(0.5,0,0,1);
  love.graphics.print(titleText,font_64,(ww/2) - (titleTextW/2), hh/8);
  
  for i,button in ipairs(AllButtonsMenu) do
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

  
  