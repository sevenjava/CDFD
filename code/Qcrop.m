function Qcrop(gtfile,srfile,flag)
%%%%crop the query images,flag==1---Oxford,else----Paris.
gtfiles=dir(gtfile);
trfiles=srfile;
query_num=size(gtfiles,1);
query_list=[];
t=1;
for j=1:query_num
    a=strfind(gtfiles(j).name,'query');
    if a
        %get data
        path=gtfiles(j).folder+"\"+gtfiles(j).name;
        fdata=importdata(path);
        %query name
        filename=gtfiles(j).name;
        filename = filename(1:a-2);
        %image name
        fname=char(fdata.textdata);
        if flag==1
            query_list{t,1}=fname(6:end);
        else 
            query_list{t,1}=fname(1:end);%paris:1:end,oxford:6:end
        end
        query1=char(query_list(t));
        query=[trfiles,query1,'.jpg'];
        %crop
        x=fdata.data(1);
        y=fdata.data(2);
        w=fdata.data(3);
        h=fdata.data(4);
        rect=[x y w+x h+y];
        img=imread(query);

        rimg=imcrop(img,rect);
        if flag==1
            imwrite(rimg,['../datasets/cropQuery/coquery/',query1,'.jpg']);
        else
            imwrite(rimg,['../datasets/cropQuery/cpquery/',query1,'.jpg']);
        end
        t=t+1;
        hold off;
        clf;
    end
end
end