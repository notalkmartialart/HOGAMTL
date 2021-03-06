%len是所有测试图像块的数量；outputs是分配权重后各测试图像块的预测质量分数列表;scores是各测试图像块的真实质量分数列表

addpath /home/xiaogao/Downloads/screen_content/simpsal/simpsal;
addpath libsvm;
k=1;
p=1;
%获得测试图像块的名字、分数列表
[patch]=textread('/media/xiaogao/老毛桃U盘/gr/outputs/lbp/lbp_val_name_score.txt','%s%*[^\n]')
%获得测试图像的名字列表
[val]=textread('/media/xiaogao/老毛桃U盘/gr/outputs/lbp/lbp_val_name.txt','%s');
%获得所有图像块的预测分数值
output=textread('/media/xiaogao/老毛桃U盘/gr/outputs/lbp/output_nolbp_60000.txt','%s');
%获得所有图像块的真实分数值
score=textread('/media/xiaogao/老毛桃U盘/gr/outputs/lbp/scores_nolbp_60000.txt','%s');
len=length(output);
outputs=[];
scores=[];
patchSize=32;
%%%%%%%%%%%%%%%%%一张张读取测试图像%%%%%%%%%%%%%%%%%%%%
for i=1:length(val)
    im = imread(strcat('/home/xiaogao/Downloads/screen_content/SCIQAD/distorted_after/',val{i,1}));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
all=0;
%im=imread('/home/xiaogao/Downloads/screen_content/SCIQAD/distorted_after/img1.bmp');
%fim=mat2gray(im);
fim=rgb2gray(im);%将测试图像转为灰度图
fim=mat2gray(fim);%归一化该灰度图，便于之后的处理
gaussian1=fspecial('gaussian',3,0.1);%求局部标准差时的高斯滤波参数
gaussian2=fspecial('gaussian',3,25);%求局部平均值时的高斯滤波参数
%meanFilter(:,:,1) = ones(3, 3) / (3 * 3);
% meanFilter(:,:,2) = ones(3, 3) / (3 * 3);
% meanFilter(:,:,3) = ones(3, 3) / (3 * 3);
num=fim-imfilter(fim,gaussian2);
%num=im2double(num);
den=sqrt(imfilter(num.^2,gaussian1));%局部标准差LSD
%den=num./(den+1e-8);
%den=rgb2gray(den);
%den=mat2gray(den);
%imshow(den);
%        lnfim=num./(den+1e-8);
%lnfim=localnormalize(fim,4,4);
%den=mat2gray(den);
den(:)=(den(:)-mean(den(:))).^2;
%den=mat2gray(den);
%imshow(den);
%den=mat2gray(den);
[rows, cols] = size(den);


nRowPatches = double(int32(rows / patchSize));
nColPatches = double(int32(cols / patchSize));
nScaledRows = nRowPatches * patchSize;
nScaledCols = nColPatches * patchSize;


resizedImage = imresize(den, [nScaledRows nScaledCols]);
rowPatchSizeVector = patchSize * ones(1, nRowPatches);
colPatchSizeVector = patchSize * ones(1, nColPatches);
new = mat2cell(resizedImage, rowPatchSizeVector, colPatchSizeVector);%把图像进行分块
large=cellfun(@(x) sum(x(:))/1024,new);%每一块子图像的VLSD
%large=mat2gray(large);
[entropy,lsd,T,T1] = findVacancy(im);
tr=0;
pr=0;
amount=0;
saliency=my_simpsal(im);
[r,c]=size(saliency);
for m=1:nRowPatches
	for n=1:nColPatches
		%new{m,n}(:)=large(m,n);
        if entropy(m,n)>T || lsd(m,n)>T1 %%是老夫选中的块，小样，你很荣幸嘛！
            if saliency(m,n)>=0 && saliency(m,n)<=0.03
                tr=tr+1; %努力地统计文字块数量ing...
            else
                pr=pr+1; %努力地统计图像块数量ing...
            end
            amount=amount+1;
        end
    end
end
%tr=length(find(saliency>=0 & saliency<=0.05))/r*c;
%pr=length(find(saliency>0.05 & saliency<=1))/r*c;
%all=sum(sum(large));
for m=1:nRowPatches
	for n=1:nColPatches
		%new{m,n}(:)=large(m,n);
        if entropy(m,n)>T || lsd(m,n)>T1  %只有被朕选中的块才有资格进行以下操作，空白块，你想都别想！
            if saliency(m,n)>=0 && saliency(m,n)<=0.03 %如果你是文字块的话，嘿嘿...
                large(m,n)=large(m,n)+tr;%这是朕赐予你文字块的专属权重，朕不容许你拒绝!
                all=all+large(m,n);
                outputs(k,1)=str2double(output{k,1})*large(m,n);%待求和的每一块子图像的s值
                scores(k,1)=str2double(score{k,1});
            else %如果你是图像块，哈哈...
                large(m,n)=large(m,n)+pr;%这是朕赐予你图像块的独有权重，别块勿觊觎，否则杀无赦！
                all=all+large(m,n);
                outputs(k,1)=str2double(output{k,1})*large(m,n);%待求和的每一块子图像的s值
                scores(k,1)=str2double(score{k,1});
            end
          %  p=p+1;
        else
            outputs(k,1)=0;
            scores(k,1)=str2double(score{k,1});
        end
        k=k+1;
    end
end
%outputs=cell2mat(outputs);
outputs(length(outputs)-nRowPatches*nColPatches+1:length(outputs))= outputs(length(outputs)-nRowPatches*nColPatches+1:length(outputs))/all;
%outputs=mat2cell(outputs);
%end
%den=cell2mat(new);
%den=mat2gray(den);
%imshow(den);
%figure,imshow(lnfim);
end


%a=cell2mat(outputs);
%b=cell2mat(scores);
[m,n]=size(outputs);
fid1=fopen('/home/xiaogao/下载/NR-IQA-CNN-master1/outputs/outputs_lbp.txt','wt');
fid2=fopen('/home/xiaogao/下载/NR-IQA-CNN-master1/outputs/scores_lbp.txt','wt');
for i=1:m
    fprintf(fid1,'%g',outputs(i,:));
    fprintf(fid1,'\n');
end
fclose(fid1);
for i=1:m
    fprintf(fid2,'%g',scores(i,:));
    fprintf(fid2,'\n');
end
fclose(fid2);