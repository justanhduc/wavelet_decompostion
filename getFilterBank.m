function [ h0,h1,g0,g1 ] = getFilterBank(L, wp, ws, alpha)
%FIRLOWPASS Summary of this function goes here
%   Detailed explanation goes here
m = floor(L/2):-1:1;
[M,N] = meshgrid(m,m);
Pstop = coefficients1(M,N,ws);
Ppass = coefficients2(M,N,wp);
P = alpha*Pstop + (1-alpha)*Ppass;
[u,~,~] = svd(P);
h = u(:,end)';
h = [h,fliplr(h)];
h0 = h / sum(h);
% h0 = fir1(3,0.5);
n = 0:L-1;
g0 = getG0(h0);
h1 = ((-1).^n).*g0;
% g0 = fliplr(h0);
g1 = -((-1).^n).*h0;
end

function coeff = coefficients1(m,n,w)
coeff = 2*(-sin((m+n-1).*w)./(m+n-1)-sin((n-m).*w)./(n-m));
coeff(isnan(coeff)) = 2.*(pi-w)-2.*sin((2.*m(isnan(coeff))-1).*w)./...
    (2.*m(isnan(coeff))-1);
end

function coeff = coefficients2(m,n,w)
coeff = 4*w-4*(sin((n-0.5).*w)./(n-0.5)+sin((m-0.5).*w)./(m-0.5))...
    + coefficients21(m,n,w);
end

function coeff = coefficients21(m,n,w)
coeff = 2*(sin((m+n-1)*w)./(m+n-1)+sin((n-m)*w)./(n-m));
coeff(isnan(coeff)) = 2*(pi-w)+2*sin((2*m(isnan(coeff))-1)*w)./...
    (2*m(isnan(coeff))-1);
end

function g0 = getG0(h0)
% % y = -h0(3)/(-h0(1)*h0(4)/h0(3)+h0(2)-h0(3)+h0(4));
% % x = 1 - y + h0(4)/h0(3)*y;
% % t = -h0(4)/h0(3)*y;
% x = 0.1;
% y = -h0(3)*x/(h0(2)-h0(1)*h0(4)/h0(3));
% t = -h0(4)/h0(3) * y;
% g0 = [x, y, t];
% % g0 = g0 / sum(g0);
A = [h0(2) h0(1) 0 0;h0(4) h0(3) h0(2) h0(1);0 0 h0(4) h0(3); 1 1 1 1];
b = [0 1 0 2]';
g = pinv(A)*b;
g0 = g';
end
