clear;
clc;

filename_1='C:\Users\dell\Desktop\yizhi\201612_sitedata\output\output_1001a_beijing.txt';
site_data_str=importdata(filename_1);
site_data=site_data_str.data;
%site_time=site_data(9:288,1);
site_time=0:279;
site_pm25=site_data(9:288,2);
site_pm10=site_data(9:288,3);
site_co=site_data(9:288,4);
site_no2=site_data(9:288,5);
site_so2=site_data(9:288,6);
site_o3=site_data(9:288,7);

%plot(pm25_time,site_pm25,'-b.');

wrf_chem_name='C:\Users\dell\Desktop\yizhi\201612_sitedata\wrf_data\1001a_beijing.xlsx';
wrf_chem_data_str=importdata(wrf_chem_name);
wrf_time=0:279;
wrf_data=wrf_chem_data_str.data;
wrf_pm25=wrf_data(1:280,7);
wrf_pm10=wrf_data(1:280,8);
wrf_co=wrf_data(1:280,9);
wrf_no2=wrf_data(1:280,10);
wrf_so2=wrf_data(1:280,11);
wrf_o3=wrf_data(1:280,12);

pm25_idx_nan=find(site_pm25==0);
site_pm25(pm25_idx_nan)=[];
pm25_time=site_time;
pm25_time(pm25_idx_nan)=[];
wrf_pm25(pm25_idx_nan)=[];

pm10_idx_nan=find(site_pm10==0);
site_pm10(pm10_idx_nan)=[];
pm10_time=site_time;
pm10_time(pm10_idx_nan)=[];
wrf_pm10(pm10_idx_nan)=[];

co_idx_nan=find(site_co==0);
site_co(co_idx_nan)=[];
co_time=site_time;
co_time(co_idx_nan)=[];
wrf_co(co_idx_nan)=[];

no2_idx_nan=find(site_no2==0);
site_no2(no2_idx_nan)=[];
no2_time=site_time;
no2_time(no2_idx_nan)=[];
wrf_no2(no2_idx_nan)=[];

so2_idx_nan=find(site_so2==0);
site_so2(so2_idx_nan)=[];
so2_time=site_time;
so2_time(so2_idx_nan)=[];
wrf_so2(so2_idx_nan)=[];

o3_idx_nan=find(site_o3==0);
site_o3(o3_idx_nan)=[];
o3_time=site_time;
o3_time(o3_idx_nan)=[];
wrf_o3(o3_idx_nan)=[];

subplot(4,1,1);
[ax,h1,h2]=plotyy(pm25_time,site_pm25,pm25_time,wrf_pm25);
set(ax(1),'ylim',[0,1000],'ytick',0:200:1000);
set(h1,'marker','*');
set(h1,'color','b');
set(ax(2),'ylim',[0,1000],'ytick',0:200:1000);
set(h2,'marker','*');
set(h2,'color','r');
title('pm2.5')
% a=plot(pm25_time,site_pm25,'-b*');
% legend('site-pm2.5');
% title('pm25 site');
% subplot(6,2,2);
% b=plot(pm25_time,wrf_pm25,'-r*');
% legend('wrf-pm2.5');
% title('pm25 wrf');

% 
% subplot(6,1,2);
% a=plot(pm10_time,site_pm10,'b*');
% hold on;
% b=plot(pm10_time,wrf_pm10,'r*');
% legend([a,b],'site-pm10','wrf-pm10');
% title('pm10 comparison');
% xlabel('hour');
% ylabel('concentration');
% 
% subplot(6,1,3);
% a=plot(co_time,site_co,'b*');
% hold on;
% b=plot(co_time,wrf_co./10.0,'r*');
% legend([a,b],'site-co','wrf-co');
% title('co comparison');
% xlabel('hour');
% ylabel('concentration');
% 
% subplot(6,1,4);
% a=plot(no2_time,site_no2,'b*');
% hold on;
% b=plot(no2_time,wrf_no2,'r*');
% legend([a,b],'site-no2','wrf-no2');
% title('no2 comparison');
% xlabel('hour');
% ylabel('concentration');
% 
% subplot(6,1,5);
% a=plot(so2_time,site_so2,'b*');
% hold on;
% b=plot(so2_time,wrf_so2,'r*');
% legend([a,b],'site-so2','wrf-so2');
% title('so2 comparison');
% xlabel('hour');
% ylabel('concentration');
% 
% subplot(6,1,6);
% a=plot(o3_time,site_o3,'b*');
% hold on;
% b=plot(o3_time,wrf_o3,'r*');
% legend([a,b],'site-o3','wrf-o3');
% title('o3 comparison');
xlabel('hour');
% ylabel('concentration');

set(gca,'XTickLabel',{'12-20 ';'12-21';'12-22';'12-23';'12-24 ';'12-25';'12-26 ';'12-27 ';'12-28';'12-29';'12-30';'12-31'});





