function nw = normp(S)
    z=sum(S,'all');
% % %     z=sqrt(z);
    nw = (S/z).^(1/2); %%%%%power-scaling
end