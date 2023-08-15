%% 20220615
%% from 文档\实验室信息\iFAST_log2.ftxt
%{
地址::Matlab\iFAST\auto_select.m
+[保存M函数](,auto_select)
测试:...
%}

function auto_select(date,n,is,ratio0)
addpath('Matlab\iFAST');

%date=20220615;
%n=0:12;

if nargin<3
is=1:length(n);
end
if nargin<4
ratio0=0.95;
end


% mask
date=20220615;
n=0:12;
axis_=zeros(length(n),4);
axis_(1,:)=[2.7098      6.1651      5.4366       8.892];
%axis_(2,:)=[4.1758      5.5129      6.5128      7.8499];
axis_(2,:)=[3.4      6.5129      5.5128      8.8499];

i=2;
[I,x,y]=read_profile(date,n(i),zeros(1,4),0);
%I(y>axis_(3)&y<axis_(4),x>axis_(1)&x<axis_(2))=0;
I(y>axis_(i,3)&y<axis_(i,4),x>axis_(i,1)&x<axis_(i,2))=0;

I_mask=I>1e-2;
I_mask(677:930,:)=1;
I_mask(1585:1600,214:245)=1;


% select
text_axis='';

for k=1:length(is);
i=is(k);

[I,x,y]=read_profile(date,n(i),zeros(1,4),0);

I(I_mask)=0;
% ratio=ratio0*sqrt(max(max(I)));
ratio=ratio0;

I_max=max(I');

i00=find(I_max==max(I_max));
i0=int32(mean(i00));

for Di=1:length(I_max)
[i1,i2]=get_Di(i0,Di,1,length(I_max));
if sum(I_max(i1:i2))>sum(I_max)*ratio
    break
end
end

I_max=max(I);
j00=find(I_max==max(I_max));
j0=int32(mean(j00));

for Dj=1:length(I_max)
[j1,j2]=get_Di(j0,Dj,1,length(I_max));
if sum(I_max(j1:j2))>sum(I_max)*ratio
    break
end
end

D=max(Di,Dj);
[i1,i2]=get_Di(i0,D,1,size(I,1));
[j1,j2]=get_Di(j0,D,1,size(I,2));

text_axis=[text_axis,sprintf('\naxis_(%d,:)=[%f,%f,%f,%f];',i,x(j1),x(j2),y(i1),y(i2))];
end

clipboard('copy',text_axis)

end



