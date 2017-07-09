%Takes in function aurguments x0 and a
function [x,y] = func(x0,a)
%inc from 0
x =0:x0;
%sin for given aurgument and x
y = sin(a*x);
%plot the graph
plot(x,y);
end
