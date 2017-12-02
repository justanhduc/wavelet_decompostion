function [ pyramid ] = setBand(pyramid,pind,level,channel, val)
%SETBAND Summary of this function goes here
%   Detailed explanation goes here
idx = 0;
for i = 1:level-1
    idx = idx + 2 * prod(pind(i+1,:));
end
if channel == 2
    idx = idx + prod(pind(level+1,:));
end
pyramid(idx+1:idx+prod(pind(level+1,:))) = val;
end

