clear;
clc;
ozonesonde_file='F:\ozone\ozonesonde\test.csv';
ozone_profile_file='F:\ozone\test_result\no_soft_calibration__L0853-0853_X15-15';
oz_str=read_omi_result(ozone_profile_file);

% fid=fopen(ozone_profile_file);
% n_line=531;
% ozone_cell=cell(n_line,1);
% missing_data=-9999.0;
% for i=1:n_line
%    ozone_cell{i}=fgets(fid); 
% end
% while(i<n_line)
% i=1;
%    if(strncmp(ozone_cell{i},'Atmosphere',10));
%           lineChacter=length(ozone_cell{i}) ;
%    counter=0;
%    else
%        i=i+1;
%    end
% end

%ozonesonde_data=woudc_ozonesonde_read(ozonesonde_file);