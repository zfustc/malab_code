clear;
clc;
% worldmap([25,30],[105,115]);
file_name='F:\ozone\matlabcode\chinamap\bou2_4l.shp';
%pre_encoding=slCharacterEncoding('GBK');
% a='安徽省';



guojie=shaperead(file_name);
%name_province=guojie(1).NAME;

%guojie_anhui=shaperead(file_name,'UseGeoCoords', true,'Selector',{@(v1) strcmp(v1,a),'NAME'});
%guojie=shaperead(file_name);
gs=geoshow(guojie,'color','red');
% bou1_4lx=[guojie(:).X];%提取经度信息
% bou1_4ly=[guojie(:).Y];%提取纬度信息
% plot(bou1_4lx,bou1_4ly,'-r','LineWidth',1.2)%绘国界