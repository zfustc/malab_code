function site_data=site_match(header,site_name,all_site_data)

site_idx=find(strcmp(header,site_name))-3;
site_data=all_site_data(:,site_idx);
