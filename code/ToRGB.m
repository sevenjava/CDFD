function Rimg = ToRGB(I,h,w)
    
    RI=imresize(I,[h w]);
    Rimg=single(RI)./255;
end