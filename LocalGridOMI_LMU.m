function LocalGridOMI_LMU()

DataDirectory = 'Z:\NASA_OMI\OMNO2.003\level2\';
CornerDirectory = 'Z:\NASA_OMI\OMPIXCOR.003\level2\';
SavePath = 'Z:\NASA_OMI\Level 3\Shanghai\';

startdate = '01/01/2009'; %dd/mm/yyyy
enddate = '01/01/2009'; %dd/mm/yyyy

Header = 'OMI_NO2_Shanghai_0.02_';

LonLim = [118.5 123.5];
LatLim = [29.5 33.5];
Resolution = 0.02;

[TLAT, TLON, TLATG, TLONG] = GridCell(LonLim, LatLim, Resolution);

RegionCornerLat = [max(TLATG(:)) max(TLATG(:)) min(TLATG(:)) min(TLATG(:))];
RegionCornerLon = [max(TLONG(:)) min(TLONG(:)) min(TLONG(:)) max(TLONG(:))];

% if exist(SavePath) == 0
%     mkdir(SavePath);
% end

date = startdate;

if datenum(startdate, 'dd/mm/yyyy') <= datenum(enddate, 'dd/mm/yyyy')
    Vector = [datenum(startdate, 'dd/mm/yyyy'):1:datenum(enddate, 'dd/mm/yyyy')];
elseif datenum(startdate, 'dd/mm/yyyy') > datenum(enddate, 'dd/mm/yyyy')
    Vector = [datenum(startdate, 'dd/mm/yyyy'):-1:datenum(enddate, 'dd/mm/yyyy')];
end

for XX = Vector
    
    tic
    
    date = datestr(XX, 'dd/mm/yyyy');

    disp(date);
    [Data_filename, Corner_filename, TF] = CheckOMIhdf5(DataDirectory, CornerDirectory, date);
    
    if TF == 1
    
    TropNO2VCD = zeros(size(TLAT));
    TropNO2ERROR = zeros(size(TLAT));
    TotalNO2VCD = zeros(size(TLAT));
    TotalNO2ERROR = zeros(size(TLAT));
    CLOUDFRACTION = zeros(size(TLAT));
    WEIGHT = zeros(size(TLAT));
    POINT = zeros(size(TLAT));
    
    NumberOfFile = max(size(Data_filename));
    
    for k = 1:NumberOfFile
        disp(char(Data_filename(k)));
        disp(char(Corner_filename(k)));
        [Latitude, Longitude, Time, TropVCD, TropError, TotalVCD, TotalError, CloudFraction, CloudRadianceFraction, VcdQualityFlags, XTrackQualityFlags, Area, CornerLatitude, CornerLongitude, SAA, SZA, VAA, VZA, TR] = ReadOMIhdf5(char(Data_filename{k}),char(Corner_filename{k}));
        s = size(TropVCD);
        for j = 1:s(2)
            for i = 1:s(1)
                if (XTrackQualityFlags(i, j) == 0) && (mod(VcdQualityFlags(i, j),2) == 0)
                    InRegion = sum(sum(inpolygon(CornerLongitude(i, j, :), CornerLatitude(i, j, :), RegionCornerLon, RegionCornerLat))) + sum(sum(inpolygon(RegionCornerLon, RegionCornerLat, CornerLongitude(i, j, :), CornerLatitude(i, j, :))));
                    if InRegion >=1;
                        InTarget = sum(inpolygon(TLONG, TLATG, CornerLongitude(i, j, :), CornerLatitude(i, j, :)),3);
                        D = sqrt((Longitude(i, j) - TLON).^2 + (Latitude(i, j) - TLAT).^2);

                        Bool = (InTarget>=1 & D<=5);

                        if sum(Bool(:)) >=1 && ~isnan(TropVCD(i, j)) && TropVCD(i, j) >= 0 && ~isnan(TotalVCD(i, j)) && TotalVCD(i, j) >= 0 && CloudRadianceFraction(i, j) >= 0
                            PixelSize = Area(i);

                            Weight =  1/(PixelSize*(1+3*(double(CloudRadianceFraction(i, j))./1000))^2);
                            TropNO2VCD(find(Bool)) = TropNO2VCD(find(Bool)) + TropVCD(i, j)*Weight;
                            TropNO2ERROR(find(Bool)) = TropNO2ERROR(find(Bool)) + (TropError(i, j)*Weight)^2;
                            TotalNO2VCD(find(Bool)) = TotalNO2VCD(find(Bool)) + TotalVCD(i, j)*Weight;
                            TotalNO2ERROR(find(Bool)) = TotalNO2ERROR(find(Bool)) + (TotalError(i, j)*Weight)^2;
                            CLOUDFRACTION(find(Bool)) = CLOUDFRACTION(find(Bool)) + (double(CloudRadianceFraction(i, j))./1000)*Weight;
                            WEIGHT(find(Bool)) = WEIGHT(find(Bool)) + Weight;
                            POINT(find(Bool)) = POINT(find(Bool)) + 1;

                        end
                    end
                end
            end
        end
    end
    
    TropNO2VCD = TropNO2VCD./WEIGHT;
    TropNO2ERROR = sqrt(TropNO2ERROR)./WEIGHT;
    TotalNO2VCD = TotalNO2VCD./WEIGHT;
    TotalNO2ERROR = sqrt(TotalNO2ERROR)./WEIGHT;
    CLOUDFRACTION = CLOUDFRACTION./WEIGHT;
    
%     Path1 = [SavePath, 'MAT\', datestr(datenum(date, 'dd/mm/yyyy'), 'yyyy'), '\', datestr(datenum(date, 'dd/mm/yyyy'), 'mm'), '\'];
    Path2 = [SavePath, 'HDF5\', datestr(datenum(date, 'dd/mm/yyyy'), 'yyyy'), '\', datestr(datenum(date, 'dd/mm/yyyy'), 'mm'), '\'];
%     if ~exist(Path1)
%         mkdir(Path1);
%     end
    if ~exist(Path2)
        mkdir(Path2);
    end

%     save([Path1, Header, datestr(datenum(date, 'dd/mm/yyyy'), 'yyyy-mm-dd'), '.mat'], 'TropNO2VCD', 'TropNO2ERROR', 'TotalNO2VCD', 'TotalNO2ERROR', 'CLOUDFRACTION', 'WEIGHT', 'POINT', 'TLAT', 'TLON');
    hdf5write([Path2, Header, datestr(datenum(date, 'dd/mm/yyyy'), 'yyyy-mm-dd'), '.h5'], '/Latitude', TLAT, '/Longitude', TLON, '/Trop NO2 VCD', TropNO2VCD, '/Trop NO2 VCD ERROR', TropNO2ERROR, '/Total NO2 VCD', TotalNO2VCD, '/Total NO2 VCD ERROR', TotalNO2ERROR, '/Cloud Fraction', CLOUDFRACTION, 'Weight', WEIGHT, '/Number of Data', POINT);

    end

    toc
    
end


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function [TLAT, TLON, TLATG, TLONG] = GridCell(LonLim, LatLim, Resolution)

[TLAT, TLON] = meshgrid([LatLim(1)+Resolution/2:Resolution:LatLim(2)-Resolution/2], [LonLim(1)+Resolution/2:Resolution:LonLim(2)-Resolution/2]);
TLAT = round(TLAT*1000)/1000;
TLON = round(TLON*1000)/1000;

TLATC1 = TLAT+Resolution/2;
TLATC2 = TLAT+Resolution/2;
TLATC3 = TLAT-Resolution/2;
TLATC4 = TLAT-Resolution/2;

TLONC1 = TLON+Resolution/2;
TLONC2 = TLON+Resolution/2;
TLONC3 = TLON-Resolution/2;
TLONC4 = TLON-Resolution/2;

TLATG = cat(3, TLAT, TLATC1, TLATC2, TLATC3, TLATC4);
TLONG = cat(3, TLON, TLONC1, TLONC2, TLONC3, TLONC4);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


function [Data_filename, Corner_filename, TF] = CheckOMIhdf5(DataDirectory, CornerDirectory, date)

DateOfYear = num2str(datenum(date, 'dd/mm/yyyy') - datenum(datestr(datenum(date, 'dd/mm/yyyy'), 'yyyy'), 'yyyy')+1);


if length(DateOfYear) == 1
    DataFilePath = [DataDirectory, datestr(datenum(date, 'dd/mm/yyyy'), 'yyyy'), '\00', DateOfYear, '\'];
    CornerFilePath = [CornerDirectory, datestr(datenum(date, 'dd/mm/yyyy'), 'yyyy'), '\00', DateOfYear, '\'];
elseif length(DateOfYear) == 2
    DataFilePath = [DataDirectory, datestr(datenum(date, 'dd/mm/yyyy'), 'yyyy'), '\0', DateOfYear, '\'];
    CornerFilePath = [CornerDirectory, datestr(datenum(date, 'dd/mm/yyyy'), 'yyyy'), '\0', DateOfYear, '\'];
elseif length(DateOfYear) == 3
    DataFilePath = [DataDirectory, datestr(datenum(date, 'dd/mm/yyyy'), 'yyyy'), '\', DateOfYear, '\'];
    CornerFilePath = [CornerDirectory, datestr(datenum(date, 'dd/mm/yyyy'), 'yyyy'), '\', DateOfYear, '\'];
end

DataFileList = ls(DataFilePath);
CornerFileList = ls(CornerFilePath);

Count = 0;
for i = 1:size(DataFileList, 1)
    if sum(DataFileList(:, 15) == 'N') == sum(CornerFileList(:, 15) == 'P')
        if DataFileList(i, 15) == 'N'
            Count = Count + 1;
            Data_filename{Count} = [DataFilePath, DataFileList(i,:)];
            for j = 1:size(CornerFileList, 1)
                if (CornerFileList(j, 15) == 'P' & sum(DataFileList(i,35:39) == CornerFileList(j,38:42)) == 5)
                    Corner_filename{Count} = [CornerFilePath, CornerFileList(j,:)];
                end
            end
        end
    else
        disp('Data files & Corner files mismatch');    
    end
end

if ~exist('Data_filename') || ~exist('Corner_filename') 
    Data_filename = -9E99;
    Corner_filename = -9E99;
    TF = 0;
else
    TF = 1;
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function [Latitude, Longitude, Time, TropVCD, TropError, TotalVCD, TotalError, CloudFraction, CloudRadianceFraction, VcdQualityFlags, XTrackQualityFlags, Area, CornerLatitude, CornerLongitude, SAA, SZA, VAA, VZA, TR] = ReadOMIhdf5(Data_filename,Corner_filename)

Latitude = hdf5read(Data_filename, 'HDFEOS/SWATHS/ColumnAmountNO2/Geolocation Fields/Latitude');
Longitude = hdf5read(Data_filename, 'HDFEOS/SWATHS/ColumnAmountNO2/Geolocation Fields/Longitude');

Time = hdf5read(Data_filename, 'HDFEOS/SWATHS/ColumnAmountNO2/Geolocation Fields/Time');

TropVCD = hdf5read(Data_filename, 'HDFEOS/SWATHS/ColumnAmountNO2/Data Fields/ColumnAmountNO2Trop');
TropError = hdf5read(Data_filename, 'HDFEOS/SWATHS/ColumnAmountNO2/Data Fields/ColumnAmountNO2TropStd');

TotalVCD = hdf5read(Data_filename, 'HDFEOS/SWATHS/ColumnAmountNO2/Data Fields/ColumnAmountNO2');
TotalError = hdf5read(Data_filename, 'HDFEOS/SWATHS/ColumnAmountNO2/Data Fields/ColumnAmountNO2Std');

CloudFraction = hdf5read(Data_filename, 'HDFEOS/SWATHS/ColumnAmountNO2/Data Fields/CloudFraction');
CloudRadianceFraction = hdf5read(Data_filename, 'HDFEOS/SWATHS/ColumnAmountNO2/Data Fields/CloudRadianceFraction');

VcdQualityFlags = hdf5read(Data_filename, 'HDFEOS/SWATHS/ColumnAmountNO2/Data Fields/VcdQualityFlags');
% fileinfo = hdf5info(Data_filename);
% if length(char(fileinfo.GroupHierarchy.Groups(1,1).Groups(1,2).Groups.Groups(1,1).Datasets(67).Name)) == 61
    XTrackQualityFlags = hdf5read(Data_filename, 'HDFEOS/SWATHS/ColumnAmountNO2/Data Fields/XTrackQualityFlags');
% else
%     XTrackQualityFlags = zeros(size(VcdQualityFlags));
% end

Area = hdf5read(Corner_filename, 'HDFEOS/SWATHS/OMI Ground Pixel Corners VIS/Data Fields/FoV75Area');
CornerLatitude = hdf5read(Corner_filename, 'HDFEOS/SWATHS/OMI Ground Pixel Corners VIS/Data Fields/FoV75CornerLatitude');
CornerLongitude = hdf5read(Corner_filename, 'HDFEOS/SWATHS/OMI Ground Pixel Corners VIS/Data Fields/FoV75CornerLongitude');

SAA = hdf5read(Data_filename, 'HDFEOS/SWATHS/ColumnAmountNO2/Geolocation Fields/SolarAzimuthAngle');
SZA = hdf5read(Data_filename, 'HDFEOS/SWATHS/ColumnAmountNO2/Geolocation Fields/SolarZenithAngle');
VAA = hdf5read(Data_filename, 'HDFEOS/SWATHS/ColumnAmountNO2/Geolocation Fields/ViewingAzimuthAngle');
VZA = hdf5read(Data_filename, 'HDFEOS/SWATHS/ColumnAmountNO2/Geolocation Fields/ViewingZenithAngle');
TR = hdf5read(Data_filename, 'HDFEOS/SWATHS/ColumnAmountNO2/Data Fields/TerrainReflectivity');

