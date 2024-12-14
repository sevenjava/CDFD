function dctChan= Cha_DCT(X)
% % % %cross-domain convergence
    [~,~,K] = size(X) ;
    e=1*10^(-7);%%%%%%
    dctChan=zeros(1,K);
 
    for k=1:K
        Y=dct2(X(:,:,k));
        dctChan(k)=Y(1,1).^2;  %%%%
    end
    nzsum = sum(dctChan);
% % % % % % % % % % % % % 
    for i=1:K
        if dctChan(i)>0
            dctChan(i) = log((nzsum/(dctChan(i)+e)));
        else
            dctChan(i) = 0;
        end
    end    

end