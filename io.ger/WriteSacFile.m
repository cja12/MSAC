function ok = WriteSacFile( sh, file, pathname )
% WriteSacFile writes the data from a binary SAC time series file
%
% format wsac(sh,['file']); "sh" is a SAC structure!
% To see the data once you've read it, type plot(sh.t,sh.d)
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
   fwrite(fid, sh.delta, 'float');
   fwrite(fid, sh.depmin, 'float');
   fwrite(fid, sh.depmax, 'float');
   fwrite(fid, sh.scale, 'float');
   fwrite(fid, sh.odelta, 'float');    
   fwrite(fid, sh.b, 'float');
   fwrite(fid, sh.e, 'float');
   fwrite(fid, sh.o, 'float');
   fwrite(fid, sh.a, 'float');
   fwrite(fid, sh.fmt, 'float'); 
   fwrite(fid, sh.t0, 'float');
   fwrite(fid, sh.t1, 'float');
   fwrite(fid, sh.t2, 'float');
   fwrite(fid, sh.t3, 'float');
   fwrite(fid, sh.t4, 'float');        
   fwrite(fid, sh.t5, 'float');
   fwrite(fid, sh.t6, 'float');
   fwrite(fid, sh.t7, 'float');
   fwrite(fid, sh.t8, 'float');
   fwrite(fid, sh.t9, 'float');        
   fwrite(fid, sh.f, 'float');
   fwrite(fid, sh.resp0, 'float');
   fwrite(fid, sh.resp1, 'float');
   fwrite(fid, sh.resp2, 'float');
   fwrite(fid, sh.resp3, 'float');     
   fwrite(fid, sh.resp4, 'float');
   fwrite(fid, sh.resp5, 'float');
   fwrite(fid, sh.resp6, 'float');
   fwrite(fid, sh.resp7, 'float');
   fwrite(fid, sh.resp8, 'float');     
   fwrite(fid, sh.resp9, 'float');
   fwrite(fid, sh.stla, 'float');
   fwrite(fid, sh.stlo, 'float');
   fwrite(fid, sh.stel, 'float');
   fwrite(fid, sh.stdp, 'float');      
   fwrite(fid, sh.evla, 'float');
   fwrite(fid, sh.evlo, 'float');
   fwrite(fid, sh.evel, 'float');
   fwrite(fid, sh.evdp, 'float');
   fwrite(fid, sh.mag, 'float');   
   fwrite(fid, sh.user0, 'float');
   fwrite(fid, sh.user1, 'float');
   fwrite(fid, sh.user2, 'float');
   fwrite(fid, sh.user3, 'float');
   fwrite(fid, sh.user4, 'float');     
   fwrite(fid, sh.user5, 'float');
   fwrite(fid, sh.user6, 'float');
   fwrite(fid, sh.user7, 'float');
   fwrite(fid, sh.user8, 'float');
   fwrite(fid, sh.user9, 'float');     
   fwrite(fid, sh.dist, 'float');
   fwrite(fid, sh.az, 'float');
   fwrite(fid, sh.baz, 'float');
   fwrite(fid, sh.gcarc, 'float');
   fwrite(fid, sh.sb, 'float'); 
   fwrite(fid, sh.sdelta, 'float');
   fwrite(fid, sh.depmen, 'float');
   fwrite(fid, sh.cmpaz, 'float');
   fwrite(fid, sh.cmpinc, 'float');
   fwrite(fid, sh.xminimum, 'float');   
   fwrite(fid, sh.xmaximum, 'float');
   fwrite(fid, sh.yminimum, 'float');
   fwrite(fid, sh.ymaximum, 'float');
   fwrite(fid, sh.unused6, 'float');
   fwrite(fid, sh.unused7, 'float');   
   fwrite(fid, sh.unused8, 'float');
   fwrite(fid, sh.unused9, 'float');
   fwrite(fid, sh.unused10, 'float');
   fwrite(fid, sh.unused11, 'float');
   fwrite(fid, sh.unused12, 'float');  
   %
   % Ints
   %
   fwrite(fid, sh.nzyear, 'int');
   fwrite(fid, sh.nzjday, 'int');
   fwrite(fid, sh.nzhour, 'int');
   fwrite(fid, sh.nzmin, 'int');
   fwrite(fid, sh.nzsec, 'int');     
   fwrite(fid, sh.nzmsec, 'int');
   fwrite(fid, sh.nvhdr, 'int');
   fwrite(fid, sh.norid, 'int');
   fwrite(fid, sh.nevid, 'int');
   fwrite(fid, sh.npts, 'int');      
   fwrite(fid, sh.nspts, 'int');
   fwrite(fid, sh.nwfid, 'int');
   fwrite(fid, sh.nxsize, 'int');
   fwrite(fid, sh.nysize, 'int');
   fwrite(fid, sh.unused15, 'int');  
   fwrite(fid, sh.iftype, 'int');
   fwrite(fid, sh.idep, 'int');
   fwrite(fid, sh.iztype, 'int');
   fwrite(fid, sh.unused16, 'int');
   fwrite(fid, sh.iinst, 'int');     
   fwrite(fid, sh.istreg, 'int');
   fwrite(fid, sh.ievreg, 'int');
   fwrite(fid, sh.ievtyp, 'int');
   fwrite(fid, sh.iqual, 'int');
   fwrite(fid, sh.isynth, 'int');    
   fwrite(fid, sh.magtype, 'int');
   fwrite(fid, sh.magsrc, 'int');
   fwrite(fid, sh.unused19, 'int');
   fwrite(fid, sh.unused20, 'int');
   fwrite(fid, sh.unused21, 'int');  
   fwrite(fid, sh.unused22, 'int');
   fwrite(fid, sh.unused23, 'int');
   fwrite(fid, sh.unused24, 'int');
   fwrite(fid, sh.unused25, 'int');
   fwrite(fid, sh.unused26, 'int');  
   fwrite(fid, sh.leven, 'int');
   fwrite(fid, sh.lpspol, 'int');
   fwrite(fid, sh.lovrok, 'int');
   fwrite(fid, sh.lcalda, 'int');
   fwrite(fid, sh.unused27, 'int');  
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
   fwrite(fid, sh.d(1:sh.npts), 'float'); 
   %
   st = fclose(fid);     
else
  disp(['Error reading file ', file]);
   st = fclose(fid);     
  return
end

