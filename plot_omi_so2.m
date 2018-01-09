clear;
clc;
clf;
 
% file_name='F:\ozone\matlabcode\chinamap\bou2_4l.shp';

%----------------------------------
%plot map
%----------------------------------
test_fill;
hold on;

 filename = 'F:\ozone\toxcz\OMI-Aura_L2-OMSO2_2007m0205t0451-o13615_v003-2016m0616t125809.he5';%num 3 orbit every day
 info=h5info(filename);
 data_set_tro3='/HDFEOS/SWATHS/OMI Total Column Amount SO2/Data Fields/ColumnAmountSO2_PBL';
 
 %------------------
 %Geolocation fields
 %-------------------
 
 %attributes
  ozprof_groups='/HDFEOS/SWATHS/OMI Total Column Amount SO2';
%   nYbin=h5readatt(filename,ozprof_groups,'nYbin');
 
 geo_fields=[ozprof_groups,'/Geolocation Fields'];
 data_set_longi=[geo_fields,'/Longitude'];
 data_set_lati=[geo_fields,'/Latitude'];
%  file_attribute_set='/HDFEOS/ADDITONAL/FILE_ATTRIBUTES';
%  file_attribute=h5readatt(file_name,file_attribute_set,'ProcessingControls');
 
 
 tro_total_oz=h5read(filename,data_set_tro3);
 lati=h5read(filename,data_set_lati);
 longi=h5read(filename,data_set_longi);
%  
 missing_value=h5readatt(filename,data_set_tro3,'MissingValue');
 units=h5readatt(filename,data_set_tro3,'Units');
 fill_value=h5readatt(filename,data_set_tro3,'_FillValue');
 
 %read in boundary data
% guojie=shaperead(file_name);
% longi_guojie=[guojie(:).X];
% lati_guojie=[guojie(:).Y];
% 
%  plot(longi_guojie,lati_guojie,'r','LineWidth',1.0);


hold on;

max_lines=60;
max_cloumns=1643;

%  
 for i=1077:1462-1
     for j=50:max_lines-1
        
        plongi=[longi(j,i),longi(j,i+1),longi(j+1,i+1),longi(j+1,i)];
        plati =[lati(j,i),lati(j,i+1),lati(j+1,i+1),lati(j+1,i)];
        tro_oz=mean(mean(tro_total_oz(j:j+1,i:i+1)));
        %-----------------
        %find out unfitted pixels
        %-----------------
        unfitted_idx=find(tro_total_oz(j:j+1,i:i+1)==missing_value);
        
         if length(unfitted_idx)<1
            H_F1=fill(plongi,plati,tro_oz);
            set(H_F1,{'LineStyle'},{'none'}) %设置颜色和线宽
         end
        hold on;
     end
 end
% mesh(longi,lati,tro_total_oz,'LineWidth',6);

%  
% for i=1:29
%    fill(longi(i:i+1,:),lati(i:i+1,:),tro_total_oz(i:i+1,:)) 
% end
% surf(longi,lati,tro_total_oz);

colormap(jet(256));
cba=colorbar;
set(get(cba,'Title'),'string','DU');
% t=get(cba,'Yticklabel');
% t=strcat(t,'DU');
% set(cba,'Yticklabel',t);
caxis([-0.4 4]);
axis([70,140,0,70]);

out_name='F:\ozone\toxcz\SO2_vcd_omi.png';
saveas(gca,out_name,'png');
% print(1,'-r300','-dpng',out_name);
 
%  output_filename='F:\ozone\test_result\liux_data_orbit3_oz.txt';
%  write_data(output_filename,tro_total_oz);

 
 