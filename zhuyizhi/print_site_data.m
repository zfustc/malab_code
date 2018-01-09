function print_site_data(str_data,out_path,date)

fid=fopen(out_path,'a');
if strcmp(date,'20161220')
    fprintf(fid,'%s\t','times');
    fprintf(fid,'%s\t','pm2.5');
    fprintf(fid,'%s\t','pm10');
    fprintf(fid,'%s\t','co');
    fprintf(fid,'%s\t','no2');
    fprintf(fid,'%s\t','so2');
    fprintf(fid,'%s\n','o3');
    
end
for i=1:24
    fprintf(fid,'%d\t',i-1);
    fprintf(fid,'%f\t',str_data.pm25_data(i));
    fprintf(fid,'%f\t',str_data.pm10_data(i));
    fprintf(fid,'%f\t',str_data.co_data(i));
    fprintf(fid,'%f\t',str_data.no2_data(i));
    fprintf(fid,'%f\t',str_data.so2_data(i));
    fprintf(fid,'%f\n',str_data.o3_data(i));
    
end
fclose(fid);