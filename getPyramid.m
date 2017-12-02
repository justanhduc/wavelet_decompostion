function [ pyramid,pind ] = getPyramid(sig,h0,h1,level)
%GETPYRAMID Summary of this function goes here
%   Detailed explanation goes here
pyramid = [];
pind = size(sig);
x = sig;
lenExt = length(h0)-1; 
for i = 1:level
    if size(x,1) > 1 && size(x,2) > 1
        y = wextend('2D','sym',x,lenExt);
        last1 = size(x,1)+length(h0)-1;
        last2 = size(x,2)+length(h0)-1;
        loPass = conv2(h0,h0,y,'valid');
        hiPass = conv2(h1,h1,y,'valid');
        loPass = loPass(2:2:last1,2:2:last2);
        hiPass = hiPass(2:2:last1,2:2:last2);
    else
        last = length(x)+length(h0)-1;
        y = wextend('1D','sym',x,lenExt);
        loPass = convds(y,h0,'valid',2,last);
        hiPass = convds(y,h1,'valid',2,last);
    end
    pyramid = [pyramid;hiPass(:);loPass(:)];
    pind = [pind;size(loPass)];
    x = loPass;
end
end

function y = convds(sig,fil,mode,first,last)
z = wconv1(sig,fil,mode); 
y = z(first:2:last);
end
