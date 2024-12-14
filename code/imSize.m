function img = imSize(imdata)
    if size(imdata,3) == 1
        imdata = cat(3, imdata, imdata, imdata);
    end
    img = single(imdata);
    [h, w, ~] = size(img);
    
   if h<224 || w<224
        if h<224 && w<224
            h=224;  w=224;
        elseif w<224
            w=224;
        elseif h<224
            h=224;
        end
        img=imresize(img,[h,w]);  
    end
end
