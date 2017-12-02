function [ out ] = reconstruct(pyramid,pind,g0,g1,numlevels)
%RECONTRUCT Summary of this function goes here
%   Detailed explanation goes here
for l = numlevels:-1:1
    b1 = getBand(pyramid,pind,l,1);
    b2 = getBand(pyramid,pind,l,2);
    if size(b1,1) > 1 && size(b1,2) > 1
        b1 = upsample(b1,2);
        b2 = upsample(b2,2);
        b2 = conv2(g0,g0,b2,'same');
        b1 = conv2(g1,g1,b1,'same');
    else
        b2 = upsconv1(b2,g0,max(pind(l,:)),'sym',0);
        b1 = upsconv1(b1,g1,max(pind(l,:)),'sym',0);
    end
    y = b1 + b2;
    if l == 1
        out = y;
    else
        pyramid = setBand(pyramid,pind,l-1,2,y);
    end
end

end
