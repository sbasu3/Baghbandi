A = {};
for i=1,25 do
	A[i] = "_";
end
A[1] = "T";
A[5] = "T";
A[21] = "T";
A[25] = "T";
G = {};
G.num_goats = 0;
G.goat_selected = 0;
XY={};
move = {};
GS = {};
team = "goat";	
SIZE = 640;
BSIZE = 50;
GAP = (SIZE-2*BSIZE)/4;
