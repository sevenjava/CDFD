function [B] = ButterWF(X)
% % % % % Butterworth filter
    [x,y]=size(X);
    d0=max(x,y);
    d0=ceil(d0/4); %%%%%
    r=2*2.25;  %%%%rank
% % % % frequency center% % % % % % % % % 
    [m,n]=freq_center(X); %%%%% 
    B=zeros(x,y);
    D=zeros(x,y);
    for i=1:x
        for j=1:y
            D(i,j)=sqrt((i-m).^2+(j-n).^2);
            B(i,j)=1./(1+(D(i,j)./d0).^r); 
        end
    end

end