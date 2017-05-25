function sh = IrisFetch2SAC(fetchObject)
% RSAC reads the data from a binary SAC time series file
%
% format s = IrisFetch2SAC(fetchObject); Returns a structure!
% To see the data once you've read it, type plot(s.t,s.d)
%
% Charles J Ammon (Penn State) and George Randall (LANL)
%

% sh = sacacheader;
%
sh = sacheader();
sh.delta = 1.0/fetchObject.sampleRate;
sh.dt = sh.delta;
sh.b = 0.0;
sh.beg = sh.b;
sh.e = (fetchObject.sampleCount-1)*sh.delta;
sh.npts = fetchObject.sampleCount;
dvec = datevec(daten2datet(fetchObject.startTime));
doy = floor(datenum(fetchObject.startTime) - datenum(dvec(1),1,1)) + 1;
sh.nzyear = dvec(1);
sh.nzjday =    doy;
sh.nzhour = dvec(4);
sh.nzmin =  dvec(5);
sh.nzsec =  floor(dvec(6));
sh.nzmsec = 1000*(dvec(6) - sh.nz(5));
%
sh.kstnm = fetchObject.station;
sh.khole = fetchObject.location;
sh.kcmpnm = fetchObject.channel;           
sh.knetwk = fetchObject.network;
%
sh.user0 = fetchObject.sensitivity;
sh.kuser0 = fetchObject.sensitivityUnits;
%
sh.stla = fetchObject.latitude;
sh.stlo = fetchObject.longitude;
sh.stel = fetchObject.elevation;
%
sh.cmpaz = fetchObject.azimuth;
sh.cmpinc = fetchObject.dip;
%
sh.sacpz = fetchObject.sacpz;
%
sh.d = fetchObject.data;
%
sh.t = [sh.b:sh.delta:sh.b+sh.delta*(length(sh.d)-1)]';
% compute some values of the min,max,mean
sh.depmin = min(sh.d);
sh.depmax = max(sh.d);
sh.depmen = mean(sh.d);
sh.filename = ''; 
sh.mytype = 'SAC_STRUCTURE';
% for backward compatibility
sh.nz(1) = sh.nzyear ;
sh.nz(2) = sh.nzjday ;
sh.nz(3) = sh.nzhour ;
sh.nz(4) = sh.nzmin ;
sh.nz(5) = sh.nzsec ;
sh.nz(6) = sh.nzmsec ;
%
end
%