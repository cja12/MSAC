function [ thePeriod, theAmp ] = mag(s_in,outfile)
%
% picking function for SAC structures
%   resembles SAC's PPK with much fewer options
% 
% if you are picking times the time picks are
%   stored in the SAC structure that is returned by
%   this call, the original file is NOT CHANGED.
%
%   q = quick the picking process
%   l = list the x and y values
%   z = adjust times so that the cursor becomes the
%       zero.
%   a = the cursor becomes the p arrival time pick
%   x = enter twice (left then right) to zoom
%   o = zoom back out
%

%
s = s_in;
%
thePeriod = -999;
theAmp = -999;
tzoom = 0;
iview = 1;
lf(iview) = s.beg;
rt(iview) = s.e;
%
pmeas = 0;
t1 = 0;
t2 = 0;
quality = 0;
%
hold off;
disp(sprintf('Working on file: %s',s_in.filename))
plot(s.t, s.d,'k-');
hold on;
brl = s.dist/4.0;
brr = s.dist * 1/2.75;
brt=abs(s.depmax);
brb=abs(s.depmin);
if(brb <= brt) 
    brb = -brt;
else
    brb = -brb;
end
rx = [brl,brl,brr,brr,brl];
ry = [brb,brt,brt,brb,brb];
plot(rx,ry,'k--');
title(s.filename);
grid on
xlabel('Time (Seconds)','Fontname','Helvetica','Fontsize',14);
%
ok = 1;
while (ok == 1)
	%
	[x,y,button] = ginput(1);
	%
	if(~isempty(button))
		
		if(lower(button(1)) == double('q') || lower(button(1)) == double('n'))
			ok = -1;
			break;
		elseif(button(1) == double('a'))
			theAmp = abs(y);
            quality = 1.0;
			disp(sprintf('Absolute Amplitude = %0.5g Quality = A', abs(y)));
		elseif(button(1) == double('b'))
			theAmp = abs(y);
            quality = 0.67;
			disp(sprintf('Absolute Amplitude = %0.5g Quality = B', abs(y)));
		elseif(button(1) == double('c'))
			theAmp = abs(y);
            quality = 0.33;
			disp(sprintf('Absolute Amplitude = %0.5g Quality = C', abs(y)));
		elseif(button(1) == double('x'))
			if(tzoom == 1)
				rt(iview) = x;
				if(rt(iview) < lf(iview))
					tmp = rt(iview);
					rt(iview) = lf(iview);
					lf(iview) = tmp;
				end
				sxlim([lf(iview) rt(iview)]);
				tzoom = 0;
			else
				iview = iview + 1;
				lf(iview) = x;
				tzoom = 1;
			end
		elseif(button(1) == double('o'))
			if(iview > 1)
				iview = iview - 1;
				if(iview > 0)
					sxlim([lf(iview) rt(iview)]);
				else
					iview = 1
				end
			end
			
			          
        elseif(button(1) == double('p'))
			if(pmeas == 1)
				t2 = x;
				thePeriod = abs(t2-t1);
			    disp(sprintf('Period: %f',thePeriod));
				pmeas = 0;
			else
				t1 = x;
				pmeas = 1;
			end
		else			[x,y, button(1), char(button(1))];
		end
	end
end
if(theAmp > 0)
    if(thePeriod > 0)
        mag = log10(1e6*theAmp/thePeriod) + s_in.gcarc/100 + 5.9;
        mag = log10(1e6*theAmp/thePeriod) + log10(s_in.gcarc)/3 + log10(sin(s_in.gcarc*3.14/180))/2 +0.0046*s_in.gcarc + 5.37;
        count = fprintf(outfile,'%s %.1f %.1f %.2f %.3e %.3f\n',s_in.kstnm,s_in.az,s_in.gcarc,thePeriod, theAmp, quality);
        mystring = sprintf('Just added entry: %s %.1f %.1f %.2f %.3e %.3f %.2f\n',s_in.kstnm,s_in.az,s_in.gcarc,thePeriod, theAmp,quality,0.0);
        disp(mystring)
    end
end


