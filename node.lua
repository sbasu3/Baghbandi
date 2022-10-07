local node = {}

node.__index = node

node.data = {}

node.data.__index = node.data

function node.create(data,id)
  local n = {}
  
  setmetatable(n,node)
  
  n.data = data
  --n.data = deepcopy(data)
  n.id = id
  n.value = nil
  n.num_children = 0
  n.children = {}
  
  return n
  
end

function node:clone(id)
  local n = {}
  
  setmetatable(n,node)
  
  --n.data = self.data
  n.data = deepcopy(self.data)
  n.id = id
  n.value = nil
  n.num_children = 0
  n.children = {}
  
  return n
end


function node:add_child(n)
  
  self.children[self.num_children] = n
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

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

return node