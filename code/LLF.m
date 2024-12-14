function [lf] = LLF(I,X) 
%%%%To generate deep low-frequency features
    [h,w,dim]=size(X);
    dd=zeros(1,dim);
    simg=swave(I,h,w);
    nq=normalize(X,'range');%%%%%%ft
    for k=1:dim
       
        d=pdist2(single(nq(:,:,k)),single(simg),'cityblock');
        dd(k)=sum(d,"all");
    end
    
    [sdist,index]=sort(dd,'ascend');
% % % % % % % % % % % % % % % % % % % % % % % % % 
    xh=find(sdist>mean(sdist),1);
    lf=sum(X(:,:,index(1:xh)),3);
end