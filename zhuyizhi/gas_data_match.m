function gas_data=gas_data_match(gas_idx,site_data,hour)

gas_data_temp=site_data(gas_idx);
gas_hour=hour(gas_idx);
%std_hour=[0:23];
gas_data=zeros(24,1);
 j=0;
for i=0:23
    k=i+1;
    str_i=num2str(i);
    hour_idx=find(strcmp(gas_hour,str_i), 1);
    if isempty(hour_idx)
        gas_data(k,1)=0;
        j=j+1;
    else
        gas_data(k,1)=gas_data_temp(k-j);
    end
end

