clear;
clc;

missing_value=-999;

omi_L1_file='F:\ozone\test_result\OMI-Aura_L1-OML1BRUG_2006m0714t0449-o10615_v003-2011m0121t222604-p1.he4';
liu_L2_file='F:\ozone\avdc_999999_20171012T073800-7178591\OMI-Aura_L2-PROFOZ_2006m0714t0449-o10615_v003-2010m0831t205300.he5';

%-------------------------------------------------------
%read in sza,saa,vza,vaa from omi l1 file
%-------------------------------------------------------
sza_set='/Earth UV-1 Swath/Geolocation Fields/SolarZenithAngle';
saa_set='/Earth UV-1 Swath/Geolocation Fields/SolarAzimuthAngle';
vza_set='/Earth UV-1 Swath/Geolocation Fields/ViewingZenithAngle';
vaa_set='/Earth UV-1 Swath/Geolocation Fields/ViewingAzimuthAngle';
lati_set='/Earth UV-1 Swath/Geolocation Fields/Latitude';
longi_set='/Earth UV-1 Swath/Geolocation Fields/Longitude';

L1_sza=hdfread(omi_L1_file,sza_set);
L1_saa=hdfread(omi_L1_file,saa_set);
L1_vza=hdfread(omi_L1_file,vza_set);
L1_vaa=hdfread(omi_L1_file,vaa_set);
L1_lati=hdfread(omi_L1_file,lati_set);
L1_longi=hdfread(omi_L1_file,longi_set);


%--------------------------------------------------------
%read in sza,saa,vza,vaa from omi l2 file
%--------------------------------------------------------
L2_sza_set='/HDFEOS/SWATHS/OMI Vertical Ozone Profile/Geolocation Fields/SolarZenithAngle';
L2_vza_set='/HDFEOS/SWATHS/OMI Vertical Ozone Profile/Geolocation Fields/ViewingZenithAngle';
L2_raa_set='/HDFEOS/SWATHS/OMI Vertical Ozone Profile/Geolocation Fields/RelativeAzimuthAngle';
 ozprof_groups='/HDFEOS/SWATHS/OMI Vertical Ozone Profile';

 
 geo_fields=[ozprof_groups,'/Geolocation Fields'];
 data_set_longi=[geo_fields,'/Longitude'];
 data_set_lati=[geo_fields,'/Latitude'];

L2_sza=h5read(liu_L2_file,L2_sza_set);
L2_vza=h5read(liu_L2_file,L2_vza_set);
L2_raa=h5read(liu_L2_file,L2_raa_set);
L2_lati=h5read(liu_L2_file,data_set_lati);
L2_longi=h5read(liu_L2_file,data_set_longi);

%------------------------------------------
%plot map
%------------------------------------------
figure(1);
test_fill;
hold on;

% max_lines=30;
% max_cloumns=1644;
% L1_longi=L1_longi';
% L1_lati=L1_lati';
% L1_sza=L1_sza';
% %  
%  for i=1:max_cloumns-1
%      for j=1:max_lines-1
%         
%         plongi=[L1_longi(j,i),L1_longi(j,i+1),L1_longi(j+1,i+1),L1_longi(j+1,i)];
%         plati =[L1_lati(j,i),L1_lati(j,i+1),L1_lati(j+1,i+1),L1_lati(j+1,i)];
%         temp_L1_sza=mean(mean(L1_sza(j:j+1,i:i+1)));
%         %-----------------
%         %find out unfitted pixels
%         %-----------------
%         unfitted_idx=find(L1_sza(j:j+1,i:i+1)==missing_value);
%         
%          if length(unfitted_idx)<1
%             H_F1=fill(plongi,plati,temp_L1_sza);
%             set(H_F1,{'LineStyle'},{'none'}) %设置颜色和线宽
%          end
%         hold on;
%      end
%  end
 

max_lines=30;
max_cloumns=411;
% L1_longi=L1_longi';
% L1_lati=L1_lati';
% L1_sza=L1_sza';
%  
 for i=1:max_cloumns-1
     for j=1:max_lines-1
        
        plongi=[L2_longi(j,i),L2_longi(j,i+1),L2_longi(j+1,i+1),L2_longi(j+1,i)];
        plati =[L2_lati(j,i),L2_lati(j,i+1),L2_lati(j+1,i+1),L2_lati(j+1,i)];
        temp_L2_sza=mean(mean(L2_sza(j:j+1,i:i+1)));
        %-----------------
        %find out unfitted pixels
        %-----------------
        unfitted_idx=find(L2_sza(j:j+1,i:i+1)==missing_value);
        
         if length(unfitted_idx)<1
            H_F1=fill(plongi,plati,temp_L2_sza);
            set(H_F1,{'LineStyle'},{'none'}) %设置颜色和线宽
         end
        hold on;
     end
 end
 colormap(jet(256));
 cba=colorbar;
 set(get(cba,'Title'),'string','°');
 % t=strcat(t,'DU');
 caxis([0 90]);
 axis([70,150,-20,70]);
 
 out_name='F:\ozone\test_result\L2_sza.png';
 saveas(gca,out_name,'png');









