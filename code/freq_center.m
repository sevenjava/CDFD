function [u0,v0]=freq_center(F)
%%%%%locate the center
    [h,w]=size(F);
    rect=h*w;
    C=round(rect*0.2); %%%Pareto principle
    p=reshape(F,[1,rect]);
    [q, ~] = sort(p,'descend');
    u=0;   
    v=0;
    for i=1:C
        [x,y]=find(F==q(i),1);
        u=u+x;
        v=v+y;
    end
    u0=floor(u/C);
    v0=floor(v/C);

end