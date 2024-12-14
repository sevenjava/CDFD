% % %%%%%image size <224,resize it to 224,otherwise retained unchanged.
% % %% setting parameters
test_datasets = {'oxford5k','paris6k', 'roxford5k', 'rparis6k'}; 
data_root='../datasets/';
feat_root='../features/';
dim=640;
net=importdata("repvgg.mat");
layer="relu4_24";
%% %%loading datafiles

% % %%%Oxford5k
ofiles = dir(strcat(data_root, '/oxford5k/*.jpg'));
ofile_num = size(ofiles,1);
oqfiles = dir(strcat(data_root, '/cropQuery/coquery/*.jpg'));
oqfile_num = size(oqfiles,1);
fofiles = dir(strcat(feat_root, '/repvgg/oxford5k/*.mat'));
foqfiles = dir(strcat(feat_root, '/repvgg/qOoxford/*.mat'));
ogt_files = '../datasets/gt_files_170407/';

% % % % Paris6k
pfiles = dir(strcat(data_root, '/paris6k/*.jpg'));
pfile_num = size(pfiles,1);
pqfiles = dir(strcat(data_root, '/cropQuery/cpquery/*.jpg'));
pqfile_num = size(oqfiles,1);
fpfiles = dir(strcat(feat_root, '/repvgg/paris6k/*.mat'));
fpqfiles = dir(strcat(feat_root, '/repvgg/qOparis/*.mat'));
pgt_files = '../datasets/gt_files_120310/';

% % % Holidays
hfiles = dir(strcat(data_root, '/holidays/*.jpg'));
fhfiles = dir(strcat(feat_root, '/repvgg/holidays/*.mat'));
hfile_num = size(hfiles,1);
gnd_holidays = importdata(strcat(data_root,'gnd_holidays.mat'));
[gnd_h,imlist,qidx] = deal(gnd_holidays.gnd,gnd_holidays.imlist,gnd_holidays.qidx);

% % % % Flickr100k
ffiles = dir(strcat(data_root, '/100k/*.jpg'));
ffile_num = size(ffiles,1);
fffiles = dir(strcat(feat_root, '/repvgg/100k/*.mat'));

% % % rOxford5k
rofiles = dir(strcat(data_root, '/roxford5k/*.jpg'));
roqfiles = dir(strcat(data_root, '/rQueryset/qOxford/*.jpg'));
frofiles = dir(strcat(feat_root, '/repvgg/roxford5k/*.mat'));
froqfiles = dir(strcat(feat_root, '/repvgg/rqoxford/*.mat'));

% % % % rParis6k
rpfiles = dir(strcat(data_root, '/rparis6k/*.jpg'));
rpqfiles = dir(strcat(data_root, '/rQueryset/qParis/*.jpg'));
frpfiles = dir(strcat(feat_root, '/repvgg//rparis6k/*.mat'));
frpqfiles = dir(strcat(feat_root, '/repvgg/rqparis/*.mat'));

% % %% aggregating features
% % % 1 Oxford5k dataset
cfg = configdataset (test_datasets{1}, data_root);
imp= cfg.imlist;
ofeatures = zeros(cfg.n, dim);
tic;
parfor i = 1:cfg.n
    img = imread(strcat(ofiles(i).folder,'/',imp{i},'.jpg'));
    % % % % imgData = imSize(img);
    % % % % deepf = activations(net, imgData, layer);
    deepf=importdata([fofiles(i).folder,'\',imp{i},'.mat']);
    feat = cdfd(deepf, img);
    ofeatures(i,:) = feat;
end
toc
ofeatures_norm = normalize(ofeatures,2,'norm');
% % % %query set % % % % 
qimp= cfg.qimlist;
oqfeatures=zeros(cfg.nq,dim);
tic;
parfor i = 1:cfg.nq
    img = imread(strcat(oqfiles(i).folder,'/',qimp{i},'.jpg'));
    % % % % imgData = imSize(img);
    % % % % deepf = activations(net, imgData, layer);
    deepf=importdata([foqfiles(i).folder,'\',qimp{i},'.mat']);
    feat = cdfd(deepf, img);
    oqfeatures(i,:) = feat;
end
toc
oqfeatures_norm = normalize(oqfeatures,2,"norm");
% % % % % % % % 
% % % % 2 Paris6k
cfg = configdataset (test_datasets{2}, data_root);
imp= cfg.imlist;
pfeatures=zeros(cfg.n,dim);
tic;
parfor i = 1:cfg.n
    img = imread(strcat(pfiles(i).folder,'/',imp{i},'.jpg'));
    % % % % imgData = imSize(img);
    % % % % deepf = activations(net, imgData, layer);
    deepf=importdata([fpfiles(i).folder,'\',imp{i},'.mat']);
    feat = cdfd(deepf, img);
    pfeatures(i,:) = feat;
end
pfeatures_norm = normalize(pfeatures,2,'norm');
toc
% % % % % % % % % 
qimp= cfg.qimlist;
pqfeatures=zeros(cfg.nq,dim);
tic;
parfor i = 1:cfg.nq
    img = imread(strcat(pqfiles(i).folder,'/',qimp{i},'.jpg'));
    % % % % imgData = imSize(img);
    % % % % deepf = activations(net, imgData, layer);
    deepf=importdata([fpqfiles(i).folder,'\',qimp{i},'.mat']);
    feat = cdfd(deepf, img);
    pqfeatures(i,:) = feat;
end
toc
pqfeatures_norm = normalize(pqfeatures,2,'norm');
% % % % % % % % % % 
% 3 Holidays
hfeatures = zeros(hfile_num,dim);
tic;
parfor i = 1:hfile_num
    img = imread(strcat(hfiles(i).folder,'\',imlist{i}, '.jpg'));
    deepf=importdata([fhfiles(i).folder,'\',imlist{i},'.mat']);
    % % % % img = imresize(img, 0.5);
    % % % % imgData = imSize(img);
    % % % % deepf = activations(net, imgData, layer);
    feat = cdfd(deepf, img);
    hfeatures(i,:) = feat;
end
toc
hfeatures_norm = normalize(hfeatures,2,'norm');
% % % % % % % % % % % % 
% % %% 4 Oxford105k dataset
ffeatures = zeros(ffile_num, dim);
tic;
parfor i = 1:ffile_num
    img = imread(strcat(ffiles(i).folder,'\',ffiles(i).name));
    % % % % imgData = imSize(img);
    % % % % deepf = activations(net, imgData, layer);
    deepf=importdata([fffiles(i).folder,'\',fffiles(i).name]);
    feat = cdfd(deepf, img);
    ffeatures(i,:) = feat;        
end
toc
wofeatures = [ofeatures; ffeatures];
wofeatures_norm = normalize(wofeatures,2,'norm');
omfiles = [ofiles; ffiles];

% % % % 5 Paris106k
wpfeatures = [pfeatures; ffeatures];
wpfeatures_norm = normalize(wpfeatures,2,'norm');
pmfiles = [pfiles; ffiles];
% % % % % % % % 
%% 2.6 rOxford5k
cfg = configdataset (test_datasets{3}, data_root);
imp = cfg.imlist;
qimp = cfg.qimlist;

rofile_num = numel(imp);
rofeatures = zeros(rofile_num,dim);
tic;
parfor i = 1:rofile_num
    img = imread(strcat(rofiles(i).folder,'\',imp{i},'.jpg'));
    % % % % imgData = imSize(img);
    % % % % deepf = activations(net, imgData, layer);
    deepf=importdata([frofiles(i).folder,'\',imp{i},'.mat']);
    feat = cdfd(deepf, img);
    rofeatures(i,:) = feat;
end
toc
rofeatures_norm = normalize(rofeatures,2,'norm');
% % % % % % 
roqfile_num = numel(qimp);
roqfeatures = zeros(roqfile_num,dim);
tic;
parfor i = 1:roqfile_num
    img = imread(strcat(roqfiles(i).folder,'\',qimp{i},'.jpg'));
    % % % % imgData = imSize(img);
    % % % % deepf = activations(net, imgData, layer);
    deepf=importdata([froqfiles(i).folder,'\',qimp{i},'.mat']);
    feat = cdfd(deepf, img);
    roqfeatures(i,:) = feat;
end
toc
roqfeatures_norm = normalize(roqfeatures,2,"norm");

% % % % % 2.7 rParis6k
cfg = configdataset (test_datasets{4}, data_root);
imp = cfg.imlist;
qimp = cfg.qimlist;

rpfile_num = numel(imp);
rpfeatures = zeros(rpfile_num,dim);
tic;
parfor i = 1:rpfile_num
    img = imread(strcat(rpfiles(i).folder,'\',imp{i},'.jpg'));
    deepf=importdata([frpfiles(i).folder,'\',imp{i},'.mat']);
    % % % % % imgData = imSize(img);
    % % % % % deepf = activations(net, imgData, layer);
    feat = cdfd(deepf, img);
    rpfeatures(i,:) = feat;
end
toc
rpfeatures_norm = normalize(rpfeatures,2,'norm');
% % % % % % 
rpqfile_num = numel(qimp);
rpqfeatures = zeros(rpqfile_num,dim);
tic;
parfor i = 1:rpqfile_num
    img = imread(strcat(rpqfiles(i).folder,'\',qimp{i},'.jpg'));
    deepf=importdata([frpqfiles(i).folder,'\',qimp{i},'.mat']);
    % % % % % imgData = imSize(img);
    % % % % % deepf = activations(net, imgData, layer);
    feat = cdfd(deepf, img);
    rpqfeatures(i,:) = feat;
end
toc
rpqfeatures_norm = normalize(rpqfeatures,2,'norm');
% % % % % % % % % % % 
% % % %% compute map
% % %%oxford5k
cfg = configdataset (test_datasets{1}, data_root);
qe=0;dqe_flag=0; %%%%qe and dqe
for i=3:5
    % % % dd=dim;
    dd=32*2^(i-1);
    [vecsLw,qvecsLw]=DPCW(pfeatures_norm,ofeatures_norm,oqfeatures_norm,dd);
    tic;
    sim = vecsLw*qvecsLw';
    [sim, ranks] = sort(sim, 'descend');
% % %      if qe ~=0
% % % % % % 
% % %             Que=zeros(55,size(vecsLw,2));
% % %             for k=1:55
% % %                 for q=1:qe
% % %                     if dqe_flag==1
% % %                         y=((log(q)).^2+1)/q;
% % %                         Que(k,:)=Que(k,:)+y.*vecsLw(ranks(q,k),:);
% % %                     else
% % %                         Que(k,:)=Que(k,:)+vecsLw(ranks(q,k),:);  %%%y.*
% % %                     end
% % %                 end          
% % %             end
% % %            qvecsLw=normalize(Que,2,'norm');
% % %            sim = vecsLw*qvecsLw';
% % % 		   [sim, ranks] = sort(sim, 'descend');            
% % %       end
    map = compute_map (ranks, cfg.gnd);
    fprintf('>> %s: dim = %d mAP = %.4f\n', test_datasets{1}, dd, map);
    toc
end
% % % % % % % % % % % % % % % % % 
% % % % paris6k
cfg = configdataset (test_datasets{2}, data_root);
for i=3:5
    dd=32*2^(i-1);
    % % % % % dd=dim;
    [vecsLw,qvecsLw]=DPCW(ofeatures_norm,pfeatures_norm,pqfeatures_norm,dd);
    tic;
    sim = vecsLw*qvecsLw';
    [sim, ranks] = sort(sim, 'descend');
% % %     %      if qe ~=0
% % % % % % % 
% % % %             Que=zeros(55,size(vecsLw,2));
% % % %             for k=1:55
% % % %                 for q=1:qe
% % % %                     if dqe_flag==1
% % % %                         y=((log(q)).^2+1)/q;
% % % %                         Que(k,:)=Que(k,:)+y.*vecsLw(ranks(q,k),:);
% % % %                     else
% % % %                         Que(k,:)=Que(k,:)+vecsLw(ranks(q,k),:);  
% % % %                     end
% % % %                 end          
% % % %             end
% % % %            qvecsLw=normalize(Que,2,'norm');
% % % %            sim = vecsLw*qvecsLw';
% % % % 		   [sim, ranks] = sort(sim, 'descend');            
% % % %       end
    map = compute_map (ranks, cfg.gnd);
    fprintf('>> %s: dim = %d mAP = %.4f\n', test_datasets{2},dd, map);
    toc
end
% % % % % % % % % % % % % 
% 3.holidays
for i=3:5
    dd=32*2^(i-1);
    vecs_test=hfeatures_norm';
    qvecs = vecs_test(:,qidx);
    [hol_feature_pca,hq_feature_pca]=DPCW(ofeatures_norm,hfeatures_norm,qvecs',dd);
    tic;
    vecs_test=hol_feature_pca';
    qvecs=hq_feature_pca';
    [ranks,sim] = yael_nn(vecs_test, qvecs, size(vecs_test,2), 'L2');
    [map,aps] = compute_map (ranks, gnd_h);
    fprintf('>> holidays: dim = %d mAP = %.4f\n', dd, map);
     toc
end
% % % % % % % % % % % 
% % 4.oxford105k
cfg = configdataset (test_datasets{1}, data_root);
qe=0;dqe_flag=0; %%%%dqe label
for i=3:5
    % % % % dd=dim;
    dd=32*2^(i-1);
    [vecsLw,qvecsLw]=DPCW(pfeatures_norm,wofeatures_norm,oqfeatures_norm,dd);
    tic;
    sim = vecsLw*qvecsLw';
    [sim, ranks] = sort(sim, 'descend');
% % %      if qe ~=0
% % % % % % 
% % %             Que=zeros(55,size(vecsLw,2));
% % %             for k=1:55
% % %                 for q=1:qe
% % %                     if dqe_flag==1
% % %                         y=((log(q)).^2+1)/q;
% % %                         Que(k,:)=Que(k,:)+y.*vecsLw(ranks(q,k),:);
% % %                     else
% % %                         Que(k,:)=Que(k,:)+vecsLw(ranks(q,k),:);  %%%y.*
% % %                     end
% % %                 end          
% % %             end
% % %            qvecsLw=normalize(Que,2,'norm');
% % %            sim = vecsLw*qvecsLw';
% % % 		   [sim, ranks] = sort(sim, 'descend');            
% % %       end
    map = compute_map (ranks, cfg.gnd);
    fprintf('>> oxford105k: dim = %d mAP = %.4f\n',  dd, map);
    toc
end
% % % % % % % % % % % % % 
% % % paris106k
cfg = configdataset (test_datasets{2}, data_root);
for i=3:5
    dd=32*2^(i-1);
    % % % % dd=dim;
    [vecsLw,qvecsLw]=DPCW(ofeatures_norm,wpfeatures_norm,pqfeatures_norm,dd);
    tic;
    sim = vecsLw*qvecsLw';
    [sim, ranks] = sort(sim, 'descend');
% % %     %      if qe ~=0
% % % % % % % 
% % % %             Que=zeros(55,size(vecsLw,2));
% % % %             for k=1:55
% % % %                 for q=1:qe
% % % %                     if dqe_flag==1
% % % %                         y=((log(q)).^2+1)/q;
% % % %                         Que(k,:)=Que(k,:)+y.*vecsLw(ranks(q,k),:);
% % % %                     else
% % % %                         Que(k,:)=Que(k,:)+vecsLw(ranks(q,k),:);  
% % % %                     end
% % % %                 end          
% % % %             end
% % % %            qvecsLw=normalize(Que,2,'norm');
% % % %            sim = vecsLw*qvecsLw';
% % % % 		   [sim, ranks] = sort(sim, 'descend');            
% % % %       end
    map = compute_map (ranks, cfg.gnd);
    fprintf('>> paris106k: dim = %d mAP = %.4f\n', dd, map);
    toc
end
% % % % % % % % % % % % % % 
% % roxford
fprintf('>> %s: Processing test dataset...\n', test_datasets{3});		
cfg = configdataset (test_datasets{3}, data_root);
    % % % vecsLw=rofeatures_norm;
    % % % qvecsLw=roqfeatures_norm;
for m=3:5
    dd=32*2^(m-1);
    % % % dd=dim;
    fprintf('>> whitening: Learning...\n');
    [vecsLw,qvecsLw]=DPCW(rpfeatures_norm,rofeatures_norm,roqfeatures_norm,dd);
    tic;
    sim = vecsLw*qvecsLw';
    [sim, ranks] = sort(sim, 'descend');

    ks=0;
    % % % % % % search for easy (E setup)
    for i = 1:numel(cfg.gnd), gnd(i).ok = [cfg.gnd(i).easy]; gnd(i).junk = [cfg.gnd(i).junk, cfg.gnd(i).hard]; end
    [mapE, apsE, mprE, prsE] = compute_map (ranks, gnd, ks);
    % % % search for easy & hard (M setup)
    for i = 1:numel(cfg.gnd), gnd(i).ok = [cfg.gnd(i).easy, cfg.gnd(i).hard]; gnd(i).junk = cfg.gnd(i).junk; end
    [mapM, apsM, mprM, prsM] = compute_map (ranks, gnd, ks);
    % % % % search for hard (H setup)
    for i = 1:numel(cfg.gnd), gnd(i).ok = [cfg.gnd(i).hard]; gnd(i).junk = [cfg.gnd(i).junk, cfg.gnd(i).easy]; end
    [mapH, apsH, mprH, prsH] = compute_map (ranks, gnd, ks);
    fprintf('dim=%d',dd);
    fprintf('>> %s: mAP E: %.2f, M: %.2f, H: %.2f\n', test_datasets{3}, 100*mapE, 100*mapM, 100*mapH);
toc
end
% % % % % % % % % % % % % % 
% % rparis
fprintf('>> %s: Processing test dataset...\n', test_datasets{4});		
cfg = configdataset (test_datasets{4}, data_root);

for m=3:5
    dd=32*2^(m-1);
    fprintf('>> whitening: Learning...\n');   
    [vecsLw,qvecsLw]=DPCW(rofeatures_norm,rpfeatures_norm,rpqfeatures_norm,dd);
    tic;
    sim = vecsLw*qvecsLw';
    [sim, ranks] = sort(sim, 'descend');
    % % evaluate ranks
% % % % %     ks = [1, 5, 10];
    ks=0;
    % % % search for easy (E setup)
    for i = 1:numel(cfg.gnd), gnd(i).ok = [cfg.gnd(i).easy]; gnd(i).junk = [cfg.gnd(i).junk, cfg.gnd(i).hard]; end
    [mapE, apsE, mprE, prsE] = compute_map (ranks, gnd, ks);
    % % % search for easy & hard (M setup)
    for i = 1:numel(cfg.gnd), gnd(i).ok = [cfg.gnd(i).easy, cfg.gnd(i).hard]; gnd(i).junk = cfg.gnd(i).junk; end
    [mapM, apsM, mprM, prsM] = compute_map (ranks, gnd, ks);
    % % % search for hard (H setup)
    for i = 1:numel(cfg.gnd), gnd(i).ok = [cfg.gnd(i).hard]; gnd(i).junk = [cfg.gnd(i).junk, cfg.gnd(i).easy]; end
    [mapH, apsH, mprH, prsH] = compute_map (ranks, gnd, ks);
    fprintf('dim=%d',dd);
    fprintf('>> %s: mAP E: %.2f, M: %.2f, H: %.2f\n', test_datasets{4}, 100*mapE, 100*mapM, 100*mapH);
    toc;
end