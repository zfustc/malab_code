function site_data(filename)
% filename_1='C:\Users\dell\Desktop\201612_sitedata\1220_1231\china_sites_20161220.csv';
data_str=importdata(filename);
data=data_str.data;
text_data=data_str.textdata;
%header=cell2mat(text_data(1,:));
header=text_data(1,:);
%header_array=reshape(header,1,1500);
date=text_data(2:end,1);
str_date=date(1);
hour=text_data(2:end,2);
%hour_array=cell2mat(hour');
type=text_data(2:end,3);
a= isnan(data);
data(a)=0;

%site_data 1001A 1002A 1009A 1015A 1034A 1037A 1056A 1057A 1070A 9个
data_1001a=site_match(header,'1001A',data);%北京
data_1002a=site_match(header,'1002A',data);%定陵
data_1009a=site_match(header,'1009A',data);%怀柔镇
data_1015a=site_match(header,'1015A',data);%天津
data_1034a=site_match(header,'1034A',data);%石家庄
data_1037a=site_match(header,'1037A',data);%唐山
data_1056a=site_match(header,'1056A',data);%保定
data_1057a=site_match(header,'1057A',data);%张家口
data_1070a=site_match(header,'1070A',data);%廊坊



gas_idx.pm25_idx=find_idx(type,'PM2.5');
gas_idx.pm10_idx=find_idx(type,'PM10');
gas_idx.co_idx=find_idx(type,'CO');
gas_idx.no2_idx=find_idx(type,'NO2');
gas_idx.so2_idx=find_idx(type,'SO2');
gas_idx.o3_idx=find_idx(type,'O3');
%hcho_idx=find_idx(type,'');

% pm25_data=gas_data_match(pm25_idx,data_1001a,hour);
% pm10_1001a_data=gas_data_match(pm10_idx,data_1001a,hour);
% co_1001a_data=gas_data_match(co_idx,data_1001a,hour);
% no2_1001a_data=gas_data_match(no2_idx,data_1001a,hour);
% so2_1001a_data=gas_data_match(so2_idx,data_1001a,hour);
% o3_1001a_data=gas_data_match(o3_idx,data_1001a,hour);

str_data_1001a=site_str(gas_idx,data_1001a,hour);
str_data_1002a=site_str(gas_idx,data_1002a,hour);
str_data_1009a=site_str(gas_idx,data_1009a,hour);
str_data_1015a=site_str(gas_idx,data_1015a,hour);
str_data_1034a=site_str(gas_idx,data_1034a,hour);
str_data_1037a=site_str(gas_idx,data_1037a,hour);
str_data_1056a=site_str(gas_idx,data_1056a,hour);
str_data_1057a=site_str(gas_idx,data_1057a,hour);
str_data_1070a=site_str(gas_idx,data_1070a,hour);

outpath_1001a='C:\Users\dell\Desktop\201612_sitedata\output\output_1001a_beijing.txt';
outpath_1002a='C:\Users\dell\Desktop\201612_sitedata\output\output_1002a_dingling.txt';
outpath_1009a='C:\Users\dell\Desktop\201612_sitedata\output\output_1009a_huairou.txt';
outpath_1015a='C:\Users\dell\Desktop\201612_sitedata\output\output_1015a_tianjin.txt';
outpath_1034a='C:\Users\dell\Desktop\201612_sitedata\output\output_1034a_shijiazhuang.txt';
outpath_1037a='C:\Users\dell\Desktop\201612_sitedata\output\output_1037a_tangshan.txt';
outpath_1056a='C:\Users\dell\Desktop\201612_sitedata\output\output_1056a_baoding.txt';
outpath_1057a='C:\Users\dell\Desktop\201612_sitedata\output\output_1057a_zhangjiakou.txt';
outpath_1070a='C:\Users\dell\Desktop\201612_sitedata\output\output_1070a_langfang.txt';

print_site_data(str_data_1001a,outpath_1001a,str_date);
print_site_data(str_data_1002a,outpath_1002a,str_date);
print_site_data(str_data_1009a,outpath_1009a,str_date);
print_site_data(str_data_1015a,outpath_1015a,str_date);
print_site_data(str_data_1034a,outpath_1034a,str_date);
print_site_data(str_data_1037a,outpath_1037a,str_date);
print_site_data(str_data_1056a,outpath_1056a,str_date);
print_site_data(str_data_1057a,outpath_1057a,str_date);
print_site_data(str_data_1070a,outpath_1070a,str_date);



