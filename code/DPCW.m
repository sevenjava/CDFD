function [testset_pca,queryset_pca] = DPCW(train_features,test_features,query_features,dim)
%%%%%%double PCA whitening
    epsilon=1*10^(-5);
% % % %%%%%testset
    [coeff,scoreTrain,~,~,explained,mu]=pca(train_features);
    x_train=scoreTrain;
    % Calculate covariance matrix and perform singular value decomposition
    sigma=cov(x_train,'omitrows');
    [u,s,~]=svd(sigma);    
    x_test=(test_features-mu)*coeff;
  %%%%%%%PCA whitening
    xRot=x_test*u;
    xPCAWhite=diag(1./(sqrt(diag(s)+epsilon)))*xRot';
    testset_pca=xPCAWhite';
    %%%%%second pca
    [coeff1,scoreTrain1,~,~,~,mu1]=pca(testset_pca);
    testset_pca=scoreTrain1(:,1:dim);
    %%%normalize
    testset_pca=normalize(testset_pca,2,"norm");
% % % % queryset 
   %%%%%pca whitening
    q_test=(query_features-mu)*coeff;
    q_xRot=q_test*u;
    q_xPCAWhite=diag(1./(sqrt(diag(s)+epsilon)))*q_xRot';
    query_features_white=q_xPCAWhite';
    %%%%second pca
    q_features=(query_features_white-mu1)*coeff1;
    queryset_pca=q_features(:,1:dim);
    %%%normalize
    queryset_pca=normalize(queryset_pca,2,"norm");

end