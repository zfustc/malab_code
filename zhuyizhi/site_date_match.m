clear;
clc;
file_folder='C:\Users\dell\Desktop\201612_sitedata\1220_1231';
dirs_temp=dir(file_folder);
site_date_dirs=dirs_temp(3:end);
n=length(site_date_dirs);
for i=1:n
    filename=[file_folder,'\',site_date_dirs(i).name];
    site_data(filename);
    
end