clear;
clc;
clf;
figure(1);
image_path='F:\ozone\to_zwq\20170821\';
file_name='F:\ozone\matlabcode\chinamap\bou2_4p.shp';
scd_file= 'F:\ozone\test_result\china_sites_20170821.txt';
out_path= 'F:\ozone\to_zwq\result\';
%read in boundary data
guojie=shaperead(file_name);
longi=[guojie(:).X];
lati=-[guojie(:).Y];

%get image path
img_path_list=dir(strcat(image_path,'*.png'));
img_num=length(img_path_list);
%gif_frame=zeros(img_num,1);
if img_num>0   
    for i=1:img_num
        clc;
        %get the image name
        clf;
        img_name=img_path_list(i).name;
        %get yaer,month,day,hour,minute 
        year_idx=8;
        year_length=3;
        month_length=2;
        day_length=2;
        hour_length=2;
        minute_length=2;
        year_str=img_name(year_idx:year_idx+year_length);
        month_str=img_name(year_idx+4:year_idx+4+month_length-1);
        day_str=img_name(year_idx+6:year_idx+6+day_length-1);
        hour_str=img_name(year_idx+8+1:year_idx+8+1+hour_length-1);
        minute_str=img_name(year_idx+9+2:year_idx+11+minute_length-1);
        
        %read in image and show on the figure 1
        I=imread(strcat(image_path,img_name));
       % imshow(I,'Xdata',[80,200],'Ydata',[-60,+60]);
        hold on;
        %
        axis on;
        %read in site data 
        hour_num=str2double(hour_str);
        pts_str=read_pts_data(scd_file,hour_num);
        pts_lati=-pts_str.lati;
        
        %plot(longi,lati,'y','LineWidth',1.0);
        hold on;
        
       % scatter(pts_str.longi,pts_lati,20,pts_str.scd,'filled');
        min_scd=min(pts_str.scd);
        max_scd=max(pts_str.scd);
        colormap(jet(256));
        cba=colorbar;
        caxis([0E16 0.2E3]);
        %colorbar(cba,'hide')
        
        axis([80,140,-54,-18]);
        axis off;
        
        out_name=[out_path,year_str,month_str,day_str,hour_str,minute_str,'.png'];
        
%         gif_frame=getframe(gcf);
%         im=frame2im(gif_frame);%制作gif文件，图像必须是index索引图像  
%         [I,map]=rgb2ind(im,256);  
%         if(i==1)
%            imwrite(I,map,'F:\ozone\to_zwq\test.gif','gif','DelayTime',0.2,'loopcount',inf);
%         else
%            imwrite(I,map,'F:\ozone\to_zwq\test.gif','gif','DelayTime',0.2,'WriteMode','append','loopcount',inf);
%         
        %print(1,'-dpng','-r1000',out_name);
%         end
    end
end







%set(gca,'ydir','reverse');
%axis([80,200,-60,60]);


