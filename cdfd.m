function [feat] = cdfd(deepf,imdata)
% % % % %cdfd main function
    [~,~,K]=size(deepf);
    lf=LLF(imdata,deepf);
% % % % % % spatial fusion % % % % % % %   
    S1=sum(deepf,3);
% % % 
    [cf,sw]=FDW(imdata,lf);
    S1=S1+cf;
    S1=S1.*sw;                           
    S=normp(S1);
    ft=deepf.*S;     
% % % % % % % % % % % % % % % % % % % % % % % % 
    X1 = reshape(mean(ft,[1,2]),[1,K]);    
    C=Cha_DCT(ft);                
    rst = X1.*C;                               
% % % % % % % % % % % % % % % % % % % % % % % % % % % %     
    feat=rst;  
end