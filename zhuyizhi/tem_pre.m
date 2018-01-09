clear;
clc;
file_folder='C:\Users\dell\Desktop\201612_sitedata\tem_pre\';
dirs_temp=dir(file_folder);
dirs=dirs_temp(3:end);
n=length(dirs);
co_factor=zeros(1,24);
no2_factor=zeros(1,24);
so2_factor=zeros(1,24);
o3_factors=zeros(1,24);
co_mass=
for i=1:n
    filename=[file_folder,dirs(i).name];
    str_data=importdata(filename);
    tem=str_data.data(1,6);
    pre=str_data.data(1,4);
end
