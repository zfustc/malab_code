function pts_str=read_pts_data(filename,hour)
% 读入散点图数据
%输入：文件名
%      小时数
%返回值：structure(lati,longi,scd)
pts_data=importdata(filename);
pts_str.lati=pts_data(:,1);
pts_str.longi=pts_data(:,2);
pts_str.scd=pts_data(:,hour+3);
