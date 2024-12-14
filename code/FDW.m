function [colorlf,fs] = FDW(I,lf)
%%%%%multi-trait spatial fusion  
    [h,w,~]=size(lf);
    rgb=ToRGB(I,h,w);
    I=1/3*(rgb(:,:,1)+rgb(:,:,2)+rgb(:,:,3));

    colorlf=lf.*I;

    fs=ButterWF(colorlf);
end