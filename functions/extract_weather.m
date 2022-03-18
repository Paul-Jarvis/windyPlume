function[netCDF] = extract_weather(windFile,b, geopotFile, vent_lat, ...
    vent_long)

%% read in the netCDF file

z = ncread(geopotFile,'z');
time = ncread(windFile,'time');
%pres = ncread(geopotFile,'level');
%temp = ncread(filename,'t');
u = ncread(windFile,'u');
v = ncread(windFile,'v');
%r_h = ncread(filename,'r');
lat = ncread(geopotFile, 'latitude');
long = ncread(geopotFile, 'longitude');

z = z./9.80665;

%% convert time I want to days after 01/01/1900

start_time = datenum([1900 01 01 0 0 0]);

end_time = datenum(b);%[year month day hour minute second]); 

time_want = (end_time - start_time)*24;%no of hours after 1900/01/01 00:00:0

time = double(time);

if time_want > time(end) || time_want < time(1)
    disp('error with the selected')
    return
end
    
%% select data for the time I want
[row_t] = find(time == round(time_want)); % Select time in the 4D matrix
[row_lat] = find(lat == vent_lat); % Select latitude in the 4D matrix
[row_long] = find(long == vent_long); % Select longitude in the 4D matrix

z = z(row_long,row_lat,:,row_t);
u = u(row_long,row_lat,:,row_t);
v = v(row_long,row_lat,:,row_t);

%temp = squeeze(temp);
z = squeeze(z);
u = squeeze(u);
v = squeeze(v);
%r_h = squeeze(r_h);

%temp = temp';
z = z';
u = u';
v = v';
%r_h = r_h';

%temp_intep = interp1(time,temp,time_want,'linear');
%z_intep = interp1(time,z,time_want,'linear');
%u_wind = interp1(time,u,time_want);
%v_wind = interp1(time,v,time_want);
%r_h_intep = interp1(time,r_h,time_want);


% %plot up to test we are interperateing correctly
% i = 1;
% while i <= 37
%     plot(time,temp(:,i))
%     hold on
%     scatter(time_want,temp_intep(i))
%     i = i + 1;
% end


%netCDF.temp = temp_intep;
netCDF.u = u;
netCDF.v = v;
netCDF.z = z;
%netCDF.temp = temp_intep;
%netCDF.rh = r_h_intep/100;

%netCDF.P = double(pres*100);
%netCDF.P  = netCDF.P';
netCDF.V_a = sqrt(u.^2+v.^2);
%netCDF.rho_da = netCDF.P/287./netCDF.temp;
%netCDF.rho_va = netCDF.P/461./netCDF.temp;

%%test we are converting pressure correctly
%plot(netCDF.P,netCDF.z)

 end





