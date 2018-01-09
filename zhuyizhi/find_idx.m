function gases_idx=find_idx(type_data,gas_type)

type=gas_type;
idx=find(strcmp(type_data,type));
gases_idx=idx;