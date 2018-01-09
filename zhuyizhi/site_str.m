function site_str_data=site_str(gas_idx,site_data,hour)

site_str_data.pm25_data=gas_data_match(gas_idx.pm25_idx,site_data,hour);
site_str_data.pm10_data=gas_data_match(gas_idx.pm10_idx,site_data,hour);
site_str_data.co_data=gas_data_match(gas_idx.co_idx,site_data,hour);
site_str_data.no2_data=gas_data_match(gas_idx.no2_idx,site_data,hour);
site_str_data.so2_data=gas_data_match(gas_idx.so2_idx,site_data,hour);
site_str_data.o3_data=gas_data_match(gas_idx.o3_idx,site_data,hour);