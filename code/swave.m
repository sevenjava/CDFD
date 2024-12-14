function Lfimg = swave(X,h,w)
%UNTITLE
X1=imresize(X,[2*h 2*w]);
X1=rgb2gray(X1);
[c,s] =wavedec2(X1,1,'haar');
% [H2,V2,D2]=detcoef2('all',c,s,1);
A3=appcoef2(c,s,'haar',1);
A3img=wcodemat(A3,255,'mat',1);
Lfimg=abs(A3img-255)./255;

end
