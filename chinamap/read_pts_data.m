function pts_str=read_pts_data(filename,hour)
% ����ɢ��ͼ����
%���룺�ļ���
%      Сʱ��
%����ֵ��structure(lati,longi,scd)
pts_data=importdata(filename);
pts_str.lati=pts_data(:,1);
pts_str.longi=pts_data(:,2);
pts_str.scd=pts_data(:,hour+3);
