%% 20230507
%% from 文档\实验室问题\LWFA数据分析.ftxt
%{
地址::Matlab\IP\read_IP_image.m
+[保存M函数](,read_IP_image)
测试:...
%}

function data0=read_IP_image(file_name,IP_type)

if nargin<2
    IP_type="MS";
end

data0=imread(file_name);
data0=double(data0);
if size(data0,1)==4000
    data0=data0(1:2:end,1:2:end);
end
data=data0/max(max(data0));

data_x=max(data);
data_y=max(data');
y_0=fix(mean(find(data_y==1)));
if y_0>1500 || y_0<=500
    y_0=1000;
end

x_d=1:10:2500;
y_d=y_0-500:10:y_0+500;

if mean(data_x(1:600))>mean(data_x(end-600:end))
    Im=data(y_d,x_d);
else
    Im=data(y_d,end+1-x_d);
end

surf(x_d,y_d,Im)
view([0,90])
axis equal
axis([min(x_d),max(x_d),min(y_d),max(y_d)])
shading interp
colormap('hot')

end




