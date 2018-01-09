colormap(jet(256));
cba=colorbar;
t=get(cba,'Yticklabel');
t=strcat(t,'DU');
set(cba,'Yticklabel',t);
caxis([0 60]);
axis([70,150,-20,70]);