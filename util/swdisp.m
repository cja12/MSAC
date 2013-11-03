function swdisp(s_in)
%
% function to measure dispersion used in peak-and-trough method
%   for ammon's seismo laboratory exercises.
%
% based on picking function for SAC structures
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
%   p = to select the peak or trough for computation
%   x = enter twice (left then right) to zoom
%   o = zoom back out
%

%
s = s_in;
nmeas = 0;
%
filename = input('Please enter the filename for storing the results: ', 's' );
fid = fopen(filename,'w');

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
%
figure(1);
p1sac(s);
%
ok = 1;
while (ok == 1)
	%
	[x,y,button] = ginput(1);
	%
	if(~isempty(button))
		
		if(lower(button(1)) == double('q'))
			ok = -1;
			break;
		elseif(button(1) == double('a'))
			theAmp = abs(y);
			disp(sprintf('Absolute Amplitude = %0.5g', abs(y)));
		elseif(button(1) == double('x'))
			if(tzoom == 1)
				rt(iview) = x;
				if(rt(iview) > lf(iview))
					sxlim([lf(iview) rt(iview)]);
					tzoom = 0;
				end
			else
				iview = iview + 1;
				lf(iview) = x;
				tzoom = 1;
			end
		elseif(button(1) == double('>'))
			dx = 0.25 * (rt(iview) - lf(iview));
            sxlim([lf(iview)+dx, rt(iview)+dx]);
            iview = iview + 1;
            rt(iview) = rt(iview-1)+dx;
            lf(iview) = lf(iview-1)+dx;
        elseif(button(1) == double('<'))
			dx = 0.25 * (rt(iview) - lf(iview));
            sxlim([lf(iview)-dx, rt(iview)-dx]);
            iview = iview + 1;
            rt(iview) = rt(iview-1)-dx;
            lf(iview) = lf(iview-1)-dx;
		elseif(button(1) == double('o'))
			if(iview > 1)
				iview = iview - 1;
				sxlim([lf(iview) rt(iview)]);
			end
			
		elseif(button(1) == double('p'))
			if(pmeas == 1)
				t2 = x;
				thePeriod = abs(t2-t1);
                theGvel = s_in.dist/(0.5*(t1+t2));
			    nmeas = nmeas + 1;
                disp(sprintf('Period (s), Group Velocity (km/s): %.2f %.2f',thePeriod, theGvel));
                xmeas(nmeas) = thePeriod; ymeas(nmeas) = theGvel; 
                fprintf(fid,'%.3f %.3f\n',thePeriod, theGvel);
                figure(2); 
                plot(xmeas(1:nmeas),ymeas(1:nmeas),'ko');xlim([0,75]);ylim([1.5,5.5]);
                xlabel('Period (s)');ylabel('Group velocity (km/s)');
                %
                figure(1);
                
				pmeas = 0;
			else
				t1 = x;
				pmeas = 1;
                disp('pick another period')
			end
		else
			[x,y, button(1), char(button(1))];
		end
	end
end
%
fclose(fid);