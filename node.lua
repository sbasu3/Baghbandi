local class = require('middleclass')
require "gamestate"


node = class('node',GS)

function node:initialize (t)
  --local n = {}
  
  --setmetatable(n,node)
  --n.__index = node
  GS:initialize(t)
  --self.data = GS:new()
  --n.data.__index = gs

  --node.data = gs:makeCopy(GS)
  --node.data.__index = node.data

  --gs = require('gamestate').create()

  --function node.create(data,id)
  --local n = {}

  --setmetatable(n,node)

  --n.data = GS:new(data)
  --n.data = deepcopy(data)
  --self.color = 1
  self.id = math.random(1,1000)
  self.value = nil
  self.num_children = 0
  self.children = {}

  --return n
  
end


function node:clone(id)
  --local n = {}
  
  --setmetatable(n,node)
   --n.__index = node
  --n.data = self.data
  n.data = self.data:makeCopy(self.data)
  n.id = id
  n.value = nil
  n.num_children = 0
  n.children = {}
  
  return n
end


function node:add_child(n)
  --print(n.A)
  table.insert(self.children,n)
  --self.children[self.num_children] = n
  self.num_children = self.num_children + 1
  
end

function node:delete_child(n)
  
  for i=0,self.num_children do
    if self.children[i].id == n.id then
      table.remove(self.children,i) 
      break
    end
  end
  if self.num_children ~= 0 then
    self.num_children = self.num_children - 1
  end
  
end

function node:delete_all_children()
  
  for i = self.num_children,0,-1 do
    self.children[i]:delete_all_children()
    table.remove(self.children)
  end
  self.num_children = 0
end

function node:set_value(val)
  
  self.value = val
end

 function node:sort_children()
   
   table.sort(self.children,function (k1, k2) return k1.value < k2.value end )
 end
 
function node:get_data()
  return self.data
end

function node:isTerminal()
  if self.children == 0 then
    return true
  else
    return false
  end
end



--return node