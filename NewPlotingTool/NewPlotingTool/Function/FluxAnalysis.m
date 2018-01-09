clear;

%filename = 'D:\Car-MAX-DOAS\scd-res\20161216\Car-MAX-DOAS_NO2_O4(405-450nm)-LOK.dat'; %data file path
datafilename = '..\result\Car-MAX-DOAS_NO2_O4(405-450nm)-doasis.dat'; 
ellipsoid = almanac('earth','radius','meters','wgs84'); %the 

WindSpeed = 6.03; %averaged wind speed (m/s)
WindDirection = 156; %north=0, east=90, south=180, west=270
CL = 1.32; %ratio of NOx/NO2, e.g., 1.32
Clife = 1.18; %NOx life constant, e.g., 1.09-1.18
Clockwise = false; %driving direction
TimeLim = [{'00:00'},{'12:41'}]; %Time filter, only data with in the time range will be analysis
TimeLimNum = mod(datenum(TimeLim,'HH:MM'),1); %Time filter, only data with in the time range will be analysis
DateTimeFormat = 'yyyy-mm-dd HH:MM:SS'; % Time format of the data file
%DateTimeFormat = 'yyyy/mm/dd HH:MM';

%map settings
MapPath = '..\Map\Hefei\Level12\'; %location of map files
MapLog = [MapPath,'log.txt'];

LatLim =[31.6 32.1]; %latitude boundaries of the plot
LonLim =  [116.9 117.6]; %longitude boundaries of the plot
NumofTickX =8; %number of tick for the x axis
NumofTickY =6; %number of tick for the y axis

SaveBaseMap = false; %save the base map as separate file
DimMap = 75; %brightness of the base map (%), set it to -1 for gray scale map

%other settings
windfile = 'wind.dat'; %wind field file
factoryfile = 'factory.dat'; %factory location file

%end of settings-----------------------------------------------------------

%Read Map~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

fid = fopen(MapLog,'r');
Header = textscan(fid,'%s',1,'delimiter','\n','collectoutput',1);
Info = textscan(fid,'%s%f%f%f%f','collectoutput',0);
fclose(fid);

filename = Info{1};
LonWest = Info{2};
LonEast = Info{3};
LatNorth = Info{4};
LatSouth = Info{5};

% LonCombine = [LonWest,LonEast];
% LatCombine = [LatNorth,LatSouth];

InPlotRegion = find(LonEast>=min(LonLim) & LonWest<=max(LonLim) & LatNorth>=min(LatLim) & LatSouth<=max(LatLim));

LonU = unique(LonEast(InPlotRegion));
LatU = unique(LatNorth(InPlotRegion));

IMG = [];
for x = 1:length(LonU)
    IMGY = [];
    for y = 1:length(LatU)
        MapFilename = char(filename(LatNorth==LatU(y) & LonEast==LonU(x)));
        MapFilename =[MapPath,MapFilename(1:length(MapFilename)-1)];
        [IMGTemp,COLOR] = imread(MapFilename,'png');
        if y == 1
            IMGY=ind2rgb(IMGTemp,COLOR);
        else
            IMGY = cat(1,ind2rgb(IMGTemp,COLOR),IMGY);
        end
    end
    if x == 1
        IMG = IMGY;
    else
        IMG = cat(2,IMG,IMGY);
    end
end

x1 = 1;
y1 = 1;
x2 = size(IMG,2);
y2 = size(IMG,1);

Lat1 = max(LatNorth(InPlotRegion));
Lon1 = min(LonWest(InPlotRegion));
Lat2 = min(LatSouth(InPlotRegion));
Lon2 = max(LonEast(InPlotRegion));

if DimMap<0
    IMG = cat(3,mean(IMG,3),mean(IMG,3),mean(IMG,3));
else
    IMG = IMG*DimMap/100;
end

if SaveBaseMap 
    imwrite(IMG,[num2str(Lat1,'%.10f'),'-',num2str(Lat2,'%.10f'),'_',num2str(Lon1,'%.10f'),'-',num2str(Lon2,'%.10f'),'.tiff']);
end

%read wind file~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

fid = fopen(windfile,'r');
header = textscan(fid,'%s',1,'delimiter','\n');
data = textscan(fid,'%f%f%f%f','delimiter','\t','collectoutput',0);
fclose(fid);

WindLon = data{1};
WindLat = data{2};
Windx = data{3};
Windy = data{4};

%read factory location file~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

fid = fopen(factoryfile,'r');
header = textscan(fid,'%s',1,'delimiter','\n');
data = textscan(fid,'%f%f','delimiter','\t','collectoutput',0);
fclose(fid);

FactLon = data{1};
FactLat = data{2};

%read data file~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
fid = fopen(datafilename,'r');
header = textscan(fid,'%s',6,'delimiter','\n');
header = textscan(fid,'%s',103,'delimiter','\t');
data = textscan(fid,'%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s','delimiter','\t','collectoutput',0);
fclose(fid);

% for i = 1:103
%     disp([num2str(i), ' ', char(header{1}{i})]);
% end

DateStr = datestr(mean(datenum(data{91},DateTimeFormat)),'yyyy-mm-dd');

DateTime = mod((datenum(data{91},DateTimeFormat) + datenum(data{92},DateTimeFormat))/2,1);
MeasTime = (datenum(data{92},DateTimeFormat) - datenum(data{91},DateTimeFormat))*24*3600;

NO2DSCD = str2num(char(data{1}));
NO2DSCDerr = str2num(char(data{2}));

Lat = str2num(char(data{85}));
Lon = str2num(char(data{86}));

Elev = str2num(char(data{97}));
Elev(Elev>90)=180-Elev(Elev>90);
Ref = str2num(char(data{101}));

dist = zeros(size(Lat))./0;
for i = 1:length(Lat)-1
dist(i) = distance(Lat(i),Lon(i),Lat(i+1),Lon(i+1),ellipsoid);
end
dist(i+1)=0;

DateTimeD = conv2(DateTime,[1;-1],'same');
DateTimeD(length(DateTime)) = 0;

Speed = dist./(DateTimeD*24*3600);
dist = Speed.*MeasTime;

LonD = conv2(Lon,[1;-1],'same');
LonD(length(LonD)) = 0;
LatD = conv2(Lat,[1;-1],'same');
LatD(length(LatD)) = 0;
Angle = atan(LatD./LonD)./pi*180;
Angle(LonD<0)=Angle(LonD<0)+180;
Angle((Lat<0)&(LonD>0))=Angle((Lat<0)&(LonD>0))+360;
Angle=mod(450-Angle,360);

NO2VCD = NO2DSCD./(1./sin(Elev./180.*pi)-1); %DSCD to VCD, geometric approximation

RelWindDir = mod(360+180+WindDirection-Angle,360);

if Clockwise
    RelWindSpeed = -WindSpeed*sin(RelWindDir*pi/180);
else
    RelWindSpeed = WindSpeed*sin(RelWindDir*pi/180);
end

TimeBool = ((DateTime>=min(TimeLimNum))&(DateTime<=max(TimeLimNum)));

Flux = nansum(NO2VCD(TimeBool).*RelWindSpeed(TimeBool).*dist(TimeBool))*1E4; %mole/cm2 to mole/m2
Flux = Flux*CL*Clife;
disp(Flux);

%Convert Lat Lon~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

X = (x2-x1)/(Lon2-Lon1).*Lon + x1 - Lon1*(x2-x1)/(Lon2-Lon1);
Y = (y2-y1)/(Lat2-Lat1).*Lat + y1 - Lat1*(y2-y1)/(Lat2-Lat1);

WindX = (x2-x1)/(Lon2-Lon1).*WindLon + x1 - Lon1*(x2-x1)/(Lon2-Lon1);
WindY = (y2-y1)/(Lat2-Lat1).*WindLat + y1 - Lat1*(y2-y1)/(Lat2-Lat1);

FactX = (x2-x1)/(Lon2-Lon1).*FactLon + x1 - Lon1*(x2-x1)/(Lon2-Lon1);
FactY = (y2-y1)/(Lat2-Lat1).*FactLat + y1 - Lat1*(y2-y1)/(Lat2-Lat1);

%plot data~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

figure(1);
clf;
subplot(1,2,1);
imshow(IMG);
colormap(jet(256));
hold on;
Bool = (Elev<35)&TimeBool;
scatter(X(Bool),Y(Bool),500,NO2VCD(Bool),'.');
scatter(FactX,FactY,50,'o','k','markerfacecolor','w');
quiver(WindX,WindY,Windx,Windy,'color','k','linewidth',2);
hold off;
axis on;
axis equal;

cbar = colorbar;
caxis([0E16 6E16]);

xlim(sort((x2-x1)/(Lon2-Lon1).*LonLim + x1 - Lon1*(x2-x1)/(Lon2-Lon1)));
ylim(sort((y2-y1)/(Lat2-Lat1).*LatLim + y1 - Lat1*(y2-y1)/(Lat2-Lat1)));
%fix x and y tick
LonTick = linspace(min((x2-x1)/(Lon2-Lon1).*LonLim + x1 - Lon1*(x2-x1)/(Lon2-Lon1)),max((x2-x1)/(Lon2-Lon1).*LonLim + x1 - Lon1*(x2-x1)/(Lon2-Lon1)),NumofTickX);
LatTick = linspace(min((y2-y1)/(Lat2-Lat1).*LatLim + y1 - Lat1*(y2-y1)/(Lat2-Lat1)),max((y2-y1)/(Lat2-Lat1).*LatLim + y1 - Lat1*(y2-y1)/(Lat2-Lat1)),NumofTickY);
set(gca,'xtick',LonTick);
set(gca,'ytick',LatTick);
set(gca,'xticklabel',get(gca,'xtick').*(Lon2-Lon1)/(x2-x1) + Lon1 - x1*(Lon2-Lon1)/(x2-x1));
set(gca,'yticklabel',get(gca,'ytick').*(Lat2-Lat1)/(y2-y1) + Lat1 - x1*(Lat2-Lat1)/(y2-y1));

title([DateStr,' ',char(TimeLim{1}),' - ',char(TimeLim{2}),' UTC 30^o&150^o'],'fontsize',20);%&150^o
xlabel('Longitude','fontsize',20);
ylabel('Latitude','fontsize',20);
ylabel(cbar,'NO_2 VCD (molec/cm^2)','fontsize',20);
set(gca,'fontsize',14);
grid on;
box on;

subplot(1,2,2);
imshow(IMG);
colormap(jet(256));
hold on;
Bool = (Elev>35)&TimeBool;
scatter(X(Bool),Y(Bool),500,NO2VCD(Bool),'.');
scatter(FactX,FactY,50,'o','k','markerfacecolor','w');
quiver(WindX,WindY,Windx,Windy,'color','k','linewidth',2);
hold off;
axis on;
axis equal;

cbar = colorbar;
caxis([0 6E16]);

xlim(sort((x2-x1)/(Lon2-Lon1).*LonLim + x1 - Lon1*(x2-x1)/(Lon2-Lon1)));
ylim(sort((y2-y1)/(Lat2-Lat1).*LatLim + y1 - Lat1*(y2-y1)/(Lat2-Lat1)));
%fix x and y tick
LonTick = linspace(min((x2-x1)/(Lon2-Lon1).*LonLim + x1 - Lon1*(x2-x1)/(Lon2-Lon1)),max((x2-x1)/(Lon2-Lon1).*LonLim + x1 - Lon1*(x2-x1)/(Lon2-Lon1)),NumofTickX);
LatTick = linspace(min((y2-y1)/(Lat2-Lat1).*LatLim + y1 - Lat1*(y2-y1)/(Lat2-Lat1)),max((y2-y1)/(Lat2-Lat1).*LatLim + y1 - Lat1*(y2-y1)/(Lat2-Lat1)),NumofTickY);
set(gca,'xtick',LonTick);
set(gca,'ytick',LatTick);
set(gca,'xticklabel',get(gca,'xtick').*(Lon2-Lon1)/(x2-x1) + Lon1 - x1*(Lon2-Lon1)/(x2-x1));
set(gca,'yticklabel',get(gca,'ytick').*(Lat2-Lat1)/(y2-y1) + Lat1 - x1*(Lat2-Lat1)/(y2-y1));

title([DateStr,' ',char(TimeLim{1}),' - ',char(TimeLim{2}),' UTC 150^o'],'fontsize',20);
xlabel('Longitude','fontsize',20);
ylabel('Latitude','fontsize',20);
ylabel(cbar,'NO_2 VCD (molec/cm^2)','fontsize',20);
set(gca,'fontsize',14);
grid on;
box on;

figure(2);
clf;
subplot(1,2,1);
imshow(IMG);
colormap(jet(256));
hold on;
Bool = (Elev<90)&TimeBool;
scatter(X(Bool),Y(Bool),1000,Angle(Bool),'.');
scatter(FactX,FactY,50,'o','k','markerfacecolor','w');
quiver(WindX,WindY,Windx,Windy,'color','k','linewidth',2);
hold off;
axis on;
axis equal;

cbar = colorbar;
caxis([0 360]);

xlim(sort((x2-x1)/(Lon2-Lon1).*LonLim + x1 - Lon1*(x2-x1)/(Lon2-Lon1)));
ylim(sort((y2-y1)/(Lat2-Lat1).*LatLim + y1 - Lat1*(y2-y1)/(Lat2-Lat1)));
%fix x and y tick
LonTick = linspace(min((x2-x1)/(Lon2-Lon1).*LonLim + x1 - Lon1*(x2-x1)/(Lon2-Lon1)),max((x2-x1)/(Lon2-Lon1).*LonLim + x1 - Lon1*(x2-x1)/(Lon2-Lon1)),NumofTickX);
LatTick = linspace(min((y2-y1)/(Lat2-Lat1).*LatLim + y1 - Lat1*(y2-y1)/(Lat2-Lat1)),max((y2-y1)/(Lat2-Lat1).*LatLim + y1 - Lat1*(y2-y1)/(Lat2-Lat1)),NumofTickY);
set(gca,'xtick',LonTick);
set(gca,'ytick',LatTick);
set(gca,'xticklabel',get(gca,'xtick').*(Lon2-Lon1)/(x2-x1) + Lon1 - x1*(Lon2-Lon1)/(x2-x1));
set(gca,'yticklabel',get(gca,'ytick').*(Lat2-Lat1)/(y2-y1) + Lat1 - x1*(Lat2-Lat1)/(y2-y1));

title([DateStr,' ',char(TimeLim{1}),' to ',char(TimeLim{2})],'fontsize',20);
xlabel('Longitude','fontsize',20);
ylabel('Latitude','fontsize',20);
ylabel(cbar,'Driving Direction','fontsize',20);
set(gca,'fontsize',14);
grid on;
box on;

subplot(1,2,2);
imshow(IMG);
colormap(jet(256));
hold on;
Bool = (Elev<90)&TimeBool;
scatter(X(Bool),Y(Bool),1000,Speed(Bool),'.');
scatter(FactX,FactY,50,'o','k','markerfacecolor','w');
quiver(WindX,WindY,Windx,Windy,'color','k','linewidth',2);
hold off;
axis on;
axis equal;

cbar = colorbar;
caxis([0 30]);

xlim(sort((x2-x1)/(Lon2-Lon1).*LonLim + x1 - Lon1*(x2-x1)/(Lon2-Lon1)));
ylim(sort((y2-y1)/(Lat2-Lat1).*LatLim + y1 - Lat1*(y2-y1)/(Lat2-Lat1)));
%fix x and y tick
LonTick = linspace(min((x2-x1)/(Lon2-Lon1).*LonLim + x1 - Lon1*(x2-x1)/(Lon2-Lon1)),max((x2-x1)/(Lon2-Lon1).*LonLim + x1 - Lon1*(x2-x1)/(Lon2-Lon1)),NumofTickX);
LatTick = linspace(min((y2-y1)/(Lat2-Lat1).*LatLim + y1 - Lat1*(y2-y1)/(Lat2-Lat1)),max((y2-y1)/(Lat2-Lat1).*LatLim + y1 - Lat1*(y2-y1)/(Lat2-Lat1)),NumofTickY);
set(gca,'xtick',LonTick);
set(gca,'ytick',LatTick);
set(gca,'xticklabel',get(gca,'xtick').*(Lon2-Lon1)/(x2-x1) + Lon1 - x1*(Lon2-Lon1)/(x2-x1));
set(gca,'yticklabel',get(gca,'ytick').*(Lat2-Lat1)/(y2-y1) + Lat1 - x1*(Lat2-Lat1)/(y2-y1));

title([DateStr,' ',char(TimeLim{1}),' to ',char(TimeLim{2})],'fontsize',20);
xlabel('Longitude','fontsize',20);
ylabel('Latitude','fontsize',20);
ylabel(cbar,'Driving Speed (m/s)','fontsize',20);
set(gca,'fontsize',14);
grid on;
box on;

figure(3);
clf;
subplot(1,2,1);
imshow(IMG);
colormap(jet(256));
hold on;
Bool = (Elev<90)&TimeBool;
scatter(X(Bool),Y(Bool),1000,RelWindDir(Bool),'.');
scatter(FactX,FactY,50,'o','k','markerfacecolor','w');
quiver(WindX,WindY,Windx,Windy,'color','k','linewidth',2);
hold off;
axis on;
axis equal;

cbar = colorbar;
caxis([0 360]);

xlim(sort((x2-x1)/(Lon2-Lon1).*LonLim + x1 - Lon1*(x2-x1)/(Lon2-Lon1)));
ylim(sort((y2-y1)/(Lat2-Lat1).*LatLim + y1 - Lat1*(y2-y1)/(Lat2-Lat1)));
%fix x and y tick
LonTick = linspace(min((x2-x1)/(Lon2-Lon1).*LonLim + x1 - Lon1*(x2-x1)/(Lon2-Lon1)),max((x2-x1)/(Lon2-Lon1).*LonLim + x1 - Lon1*(x2-x1)/(Lon2-Lon1)),NumofTickX);
LatTick = linspace(min((y2-y1)/(Lat2-Lat1).*LatLim + y1 - Lat1*(y2-y1)/(Lat2-Lat1)),max((y2-y1)/(Lat2-Lat1).*LatLim + y1 - Lat1*(y2-y1)/(Lat2-Lat1)),NumofTickY);
set(gca,'xtick',LonTick);
set(gca,'ytick',LatTick);
set(gca,'xticklabel',get(gca,'xtick').*(Lon2-Lon1)/(x2-x1) + Lon1 - x1*(Lon2-Lon1)/(x2-x1));
set(gca,'yticklabel',get(gca,'ytick').*(Lat2-Lat1)/(y2-y1) + Lat1 - x1*(Lat2-Lat1)/(y2-y1));

title([DateStr,' ',char(TimeLim{1}),' to ',char(TimeLim{2})],'fontsize',20);
xlabel('Longitude','fontsize',20);
ylabel('Latitude','fontsize',20);
ylabel(cbar,'Relative Wind Direction','fontsize',20);
set(gca,'fontsize',14);
grid on;
box on;

subplot(1,2,2);
imshow(IMG);
colormap(jet(256));
hold on;
Bool = (Elev<90)&TimeBool;
scatter(X(Bool),Y(Bool),1000,RelWindSpeed(Bool),'.');
scatter(FactX,FactY,50,'o','k','markerfacecolor','w');
quiver(WindX,WindY,Windx,Windy,'color','k','linewidth',2);
hold off;
axis on;
axis equal;

cbar = colorbar;
caxis([-5 5]);

xlim(sort((x2-x1)/(Lon2-Lon1).*LonLim + x1 - Lon1*(x2-x1)/(Lon2-Lon1)));
ylim(sort((y2-y1)/(Lat2-Lat1).*LatLim + y1 - Lat1*(y2-y1)/(Lat2-Lat1)));
%fix x and y tick
LonTick = linspace(min((x2-x1)/(Lon2-Lon1).*LonLim + x1 - Lon1*(x2-x1)/(Lon2-Lon1)),max((x2-x1)/(Lon2-Lon1).*LonLim + x1 - Lon1*(x2-x1)/(Lon2-Lon1)),NumofTickX);
LatTick = linspace(min((y2-y1)/(Lat2-Lat1).*LatLim + y1 - Lat1*(y2-y1)/(Lat2-Lat1)),max((y2-y1)/(Lat2-Lat1).*LatLim + y1 - Lat1*(y2-y1)/(Lat2-Lat1)),NumofTickY);
set(gca,'xtick',LonTick);
set(gca,'ytick',LatTick);
set(gca,'xticklabel',get(gca,'xtick').*(Lon2-Lon1)/(x2-x1) + Lon1 - x1*(Lon2-Lon1)/(x2-x1));
set(gca,'yticklabel',get(gca,'ytick').*(Lat2-Lat1)/(y2-y1) + Lat1 - x1*(Lat2-Lat1)/(y2-y1));

title([DateStr,' ',char(TimeLim{1}),' to ',char(TimeLim{2})],'fontsize',20);
xlabel('Longitude','fontsize',20);
ylabel('Latitude','fontsize',20);
ylabel(cbar,'Relative Wind Speed (m/s)','fontsize',20);
set(gca,'fontsize',14);
grid on;
box on;

