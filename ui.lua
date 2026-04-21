require "Globals"
local class = require 'middleclass'

ui = class('ui')


function ui:initialize(index)

  self.index = index;
  self.buttonsList = {};
  self.xpad = XPAD;
  self.ypad = YPAD;
  self.buttons = 0;
end


function ui:addButton(text,size,center,fn)
  self.buttons = self.buttons + 1;
  self.buttonsList[self.buttons] = {text=text,fn=fn,last=false,now=false,size=size,center=self:snap(center)};
end
 
function ui:distance(p1,p2)
  return math.sqrt((p1.x - p2.x)^2+(p1.y - p2.y)^2);
end

function ui:snap(p)
  local x0 = math.floor(p.x/self.xpad)*self.xpad;
  local y0 = math.floor(p.y/self.ypad)*self.ypad;
  
  local p0 ={};
  
  p0[1] = {x=x0,y=y0};
  p0[2] = {x=x0+self.xpad,y = y0};
  p0[3] = {x=x0,y=y0+self.ypad};
  p0[4] = {x=x0+self.xpad,y = y0+self.ypad};
  
  local dist = math.huge;
  local index = 0;
  
  for i = 1,4 do
    d = self:distance(p,p0[i]);
    if d < dist then
      dist = d;
      index = i;
    end
  end
  
  return p0[index];
end


function ui:draw()
  local ww = love.graphics.getWidth();
  local hh = love.graphics.getHeight();
  
  --love.graphics.setBackgroundColor(0,0.5,0.5,1);
  love.graphics.clear();
  love.graphics.reset();
  love.graphics.draw(menu, menuquad, 0, 0);
  love.graphics.reset();
  
  
  local margin = 16;
  --local buttonWidth = ww/5;
  local totalHeight = (BUTTON_HEIGHT) + margin * #self.buttonsList;
  local pos = 0;
  local titleTextW = font_64:getWidth(titleText);
  local titleTextH = font_64:getHeight(titleText);
  
  --love.graphics.setColor(1,1,0,1);

  local x0 = 0.9*ww;
  local y0 = 0.05*hh;
  
  local hot = false;
  if OS == 1 then
    local mx,my = love.mouse.getPosition();

    hot = (mx > x0) and (mx < (x0 + Radius)) and (my > y0) and ( my < y0 + Radius);
    local muteNow = love.mouse.isDown(1);
    if muteNow and hot then
      love.audio.stop();
    end
  elseif OS == 2 then
    local mx = touchX;
    local my = touchY;
    hot = (mx > x0) and (mx < (x0 + Radius)) and (my > y0) and ( my < y0 + Radius);
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
  
  for i,button in ipairs(self.buttonsList) do
    --print(i);
    button.last = button.now;
    local bx = button.center.x;
    local by = button.center.y;
    
    if OS == 1 or OS == 3 then
      local mx,my = love.mouse.getPosition();
    
      local hot = (mx > bx) and (mx < (bx + button.size.x)) and (my > by) and ( my < by + button.size.y);
    
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
      button.center.x,
      button.center.y,
      button.size.x,
      button.size.y
    );
    --pos = pos + (BUTTON_HEIGHT + margin);
    love.graphics.setColor(0,0,0,1);
    
    local textW = font_20:getWidth(button.text);
    local textH = font_20:getHeight(button.text);
    
    --love.graphics.print(button.text,font_20,bx - (textW/2),by + (textH/2));
    love.graphics.print(button.text,font_20,bx+(textW/2),by + (textH/2));

  end
end

