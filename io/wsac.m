function ok = wsac( sh, file, pathname )
% WriteSacFile writes the data from a binary SAC time series file
%
% format wsac(sh,['file']); "sh" is a SAC structure!
% To see the data once you've read it, type plot(sh.t,sh.d)
%
% Charles J Ammon (Penn State) and George Randall (LANL)
%

ok = 1;
%
if nargin < 2
	[file, pathname] = uiputfile('*', 'Name the SAC file', 10, 10);
	if file == 0                          % cancel chosen in uigetfile
		return;
	end
	if isunix
	  eval(['cd ' pathname]); 
	else
		cd(pathname);
	end
%
elseif nargin > 2
  	if s                                  % error return from cd
    	disp('Usage: wsac(s, filename, pathname)');
    	disp(['       pathname: ', pathname]);
    	return
  	end
end
%
fid = fopen(file, 'w');
if ( fid > 0 )
   %
   % Write sh.struct SacHeader  
   %
   % Reload for compatibility with old version
   %
   sh.depmin = min(sh.d);
   sh.depmax = max(sh.d);
   sh.depmen = mean(sh.d);

   sh.t0  =  sh.picks(1)  ;
   sh.t1  =  sh.picks(2)  ;
   sh.t2  =  sh.picks(3)  ;
   sh.t3  =  sh.picks(4)  ;
   sh.t4  =  sh.picks(5)  ;
   sh.t5  =  sh.picks(6)  ;
   sh.t6  =  sh.picks(7)  ;
   sh.t7  =  sh.picks(8)  ;
   sh.t8  =  sh.picks(9)  ;
   sh.t9  =  sh.picks(10)  ;
   %
   sh.nzyear  =  sh.nz(1)  ;
   sh.nzjday  =  sh.nz(2)  ;
   sh.nzhour  =  sh.nz(3)  ;
   sh.nzmin  =  sh.nz(4)  ;
   sh.nzsec  =  sh.nz(5)  ;
   sh.nzmsec  =  sh.nz(6)  ;
   %
   sh.user0  =  sh.user(1)  ;
   sh.user1  =  sh.user(2)  ;
   sh.user2  =  sh.user(3)  ;
   sh.user3  =  sh.user(4)  ;
   sh.user4  =  sh.user(5)  ;
   sh.user5  =  sh.user(6)  ;
   sh.user6  =  sh.user(7)  ;
   sh.user7  =  sh.user(8)  ;
   sh.user8  =  sh.user(9)  ;
   sh.user9  =  sh.user(10)  ;
   %
   sh.b = sh.beg ;
   sh.delta = sh.dt ;
   %
   % Floats
   %                  
   fwrite(fid, sh.delta, 'float32');
   fwrite(fid, sh.depmin, 'float32');
   fwrite(fid, sh.depmax, 'float32');
   fwrite(fid, sh.scale, 'float32');
   fwrite(fid, sh.odelta, 'float32');    
   fwrite(fid, sh.b, 'float32');
   fwrite(fid, sh.e, 'float32');
   fwrite(fid, sh.o, 'float32');
   fwrite(fid, sh.a, 'float32');
   fwrite(fid, sh.fmt, 'float32'); 
   fwrite(fid, sh.t0, 'float32');
   fwrite(fid, sh.t1, 'float32');
   fwrite(fid, sh.t2, 'float32');
   fwrite(fid, sh.t3, 'float32');
   fwrite(fid, sh.t4, 'float32');        
   fwrite(fid, sh.t5, 'float32');
   fwrite(fid, sh.t6, 'float32');
   fwrite(fid, sh.t7, 'float32');
   fwrite(fid, sh.t8, 'float32');
   fwrite(fid, sh.t9, 'float32');        
   fwrite(fid, sh.f, 'float32');
   fwrite(fid, sh.resp0, 'float32');
   fwrite(fid, sh.resp1, 'float32');
   fwrite(fid, sh.resp2, 'float32');
   fwrite(fid, sh.resp3, 'float32');     
   fwrite(fid, sh.resp4, 'float32');
   fwrite(fid, sh.resp5, 'float32');
   fwrite(fid, sh.resp6, 'float32');
   fwrite(fid, sh.resp7, 'float32');
   fwrite(fid, sh.resp8, 'float32');     
   fwrite(fid, sh.resp9, 'float32');
   fwrite(fid, sh.stla, 'float32');
   fwrite(fid, sh.stlo, 'float32');
   fwrite(fid, sh.stel, 'float32');
   fwrite(fid, sh.stdp, 'float32');      
   fwrite(fid, sh.evla, 'float32');
   fwrite(fid, sh.evlo, 'float32');
   fwrite(fid, sh.evel, 'float32');
   fwrite(fid, sh.evdp, 'float32');
   fwrite(fid, sh.mag, 'float32');   
   fwrite(fid, sh.user0, 'float32');
   fwrite(fid, sh.user1, 'float32');
   fwrite(fid, sh.user2, 'float32');
   fwrite(fid, sh.user3, 'float32');
   fwrite(fid, sh.user4, 'float32');     
   fwrite(fid, sh.user5, 'float32');
   fwrite(fid, sh.user6, 'float32');
   fwrite(fid, sh.user7, 'float32');
   fwrite(fid, sh.user8, 'float32');
   fwrite(fid, sh.user9, 'float32');     
   fwrite(fid, sh.dist, 'float32');
   fwrite(fid, sh.az, 'float32');
   fwrite(fid, sh.baz, 'float32');
   fwrite(fid, sh.gcarc, 'float32');
   fwrite(fid, sh.sb, 'float32'); 
   fwrite(fid, sh.sdelta, 'float32');
   fwrite(fid, sh.depmen, 'float32');
   fwrite(fid, sh.cmpaz, 'float32');
   fwrite(fid, sh.cmpinc, 'float32');
   fwrite(fid, sh.xminimum, 'float32');   
   fwrite(fid, sh.xmaximum, 'float32');
   fwrite(fid, sh.yminimum, 'float32');
   fwrite(fid, sh.ymaximum, 'float32');
   fwrite(fid, sh.unused6, 'float32');
   fwrite(fid, sh.unused7, 'float32');   
   fwrite(fid, sh.unused8, 'float32');
   fwrite(fid, sh.unused9, 'float32');
   fwrite(fid, sh.unused10, 'float32');
   fwrite(fid, sh.unused11, 'float32');
   fwrite(fid, sh.unused12, 'float32');  
   %
   % Ints
   %
   fwrite(fid, sh.nzyear, 'int32');
   fwrite(fid, sh.nzjday, 'int32');
   fwrite(fid, sh.nzhour, 'int32');
   fwrite(fid, sh.nzmin, 'int32');
   fwrite(fid, sh.nzsec, 'int32');     
   fwrite(fid, sh.nzmsec, 'int32');
   fwrite(fid, sh.nvhdr, 'int32');
   fwrite(fid, sh.norid, 'int32');
   fwrite(fid, sh.nevid, 'int32');
   fwrite(fid, sh.npts, 'int32');      
   fwrite(fid, sh.nspts, 'int32');
   fwrite(fid, sh.nwfid, 'int32');
   fwrite(fid, sh.nxsize, 'int32');
   fwrite(fid, sh.nysize, 'int32');
   fwrite(fid, sh.unused15, 'int32');  
   fwrite(fid, sh.iftype, 'int32');
   fwrite(fid, sh.idep, 'int32');
   fwrite(fid, sh.iztype, 'int32');
   fwrite(fid, sh.unused16, 'int32');
   fwrite(fid, sh.iinst, 'int32');     
   fwrite(fid, sh.istreg, 'int32');
   fwrite(fid, sh.ievreg, 'int32');
   fwrite(fid, sh.ievtyp, 'int32');
   fwrite(fid, sh.iqual, 'int32');
   fwrite(fid, sh.isynth, 'int32');    
   fwrite(fid, sh.magtype, 'int32');
   fwrite(fid, sh.magsrc, 'int32');
   fwrite(fid, sh.unused19, 'int32');
   fwrite(fid, sh.unused20, 'int32');
   fwrite(fid, sh.unused21, 'int32');  
   fwrite(fid, sh.unused22, 'int32');
   fwrite(fid, sh.unused23, 'int32');
   fwrite(fid, sh.unused24, 'int32');
   fwrite(fid, sh.unused25, 'int32');
   fwrite(fid, sh.unused26, 'int32');  
   fwrite(fid, sh.leven, 'int32');
   fwrite(fid, sh.lpspol, 'int32');
   fwrite(fid, sh.lovrok, 'int32');
   fwrite(fid, sh.lcalda, 'int32');
   fwrite(fid, sh.unused27, 'int32');  
   %
   % Strings
   %
   fprintf(fid,sprintf('%-8.8s',sh.kstnm),'char');
   fprintf(fid,sprintf('%-16.16s',sh.kevnm),'char');         
   fprintf(fid,sprintf('%-8.8s',sh.khole),'char');
   fprintf(fid,sprintf('%-8.8s',sh.ko),'char');
   fprintf(fid,sprintf('%-8.8s',sh.ka),'char');               
   fprintf(fid,sprintf('%-8.8s',sh.kt0),'char');
   fprintf(fid,sprintf('%-8.8s',sh.kt1),'char');
   fprintf(fid,sprintf('%-8.8s',sh.kt2),'char');              
   fprintf(fid,sprintf('%-8.8s',sh.kt3),'char');
   fprintf(fid,sprintf('%-8.8s',sh.kt4),'char');
   fprintf(fid,sprintf('%-8.8s',sh.kt5),'char');              
   fprintf(fid,sprintf('%-8.8s',sh.kt6),'char');
   fprintf(fid,sprintf('%-8.8s',sh.kt7),'char');
   fprintf(fid,sprintf('%-8.8s',sh.kt8),'char');              
   fprintf(fid,sprintf('%-8.8s',sh.kt9),'char');
   fprintf(fid,sprintf('%-8.8s',sh.kf),'char');
   fprintf(fid,sprintf('%-8.8s',sh.kuser0),'char');           
   fprintf(fid,sprintf('%-8.8s',sh.kuser1),'char');
   fprintf(fid,sprintf('%-8.8s',sh.kuser2),'char');
   fprintf(fid,sprintf('%-8.8s',sh.kcmpnm),'char');           
   fprintf(fid,sprintf('%-8.8s',sh.knetwk),'char');
   fprintf(fid,sprintf('%-8.8s',sh.kdatrd),'char');
   fprintf(fid,sprintf('%-8.8s',sh.kinst),'char');            
   %
   %
   %
   % write in the floating point values
   %
   fwrite(fid, sh.d(1:sh.npts), 'float32'); 
   %
   st = fclose(fid);     
else
  disp(['Error reading file ', file]);
   st = fclose(fid);     
  return
end

