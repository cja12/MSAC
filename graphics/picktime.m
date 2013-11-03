function [ s ] = picktime(s_in,outfile)
%
% picking function for SAC structures
%   resembles SAC's PPK with much fewer options
% 
% if you are picking times the time picks are
%   stored in the SAC structure that is returned by
%   this call, the original file is NOT CHANGED.
%
%   q = quit the picking process
%   l = list the x and y values and write to file outfile
%   z = adjust times so that the cursor becomes the
%       zero.
%   a = the cursor becomes the p arrival time pick
%   x = enter twice (left then right) to zoom
%   o = zoom back out
%

%
s = s_in;
outfile
%
tzoom = 0;
iview = 1;
lf(iview) = s.beg;
rt(iview) = s.e;
%
plot(s.t, s.d,'k-');
grid on
xlabel('Time (Seconds)','Fontname','Helvetica','Fontsize',14);
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
			disp(sprintf('%f %f',x,y));
                        if(outfile ~= ' ')
                            count = fprintf(outfile,'%32s, %7.3f, %9.3f, A\n',s_in.filename,s_in.gcarc,x);
                        end
                        s.a = x;	
		elseif(button(1) == double('b'))
			disp(sprintf('%f %f',x,y));
                        if(outfile ~= ' ')
                            count = fprintf(outfile,'%32s, %7.3f, %9.3f, B\n',s_in.filename,s_in.gcarc,x);
                        end
                        s.a = x;	
		elseif(button(1) == double('c'))
			disp(sprintf('%f %f',x,y));
                        if(outfile ~= ' ')
                            count = fprintf(outfile,'%32s, %7.3f, %9.3f, C\n',s_in.filename,s_in.gcarc,x);
                        end
                        s.a = x;	
		elseif(button(1) == double('d'))
			disp(sprintf('%f %f',x,y));
                        if(outfile ~= ' ')
                            count = fprintf(outfile,'%32s, %7.3f, %9.3f, D\n',s_in.filename,s_in.gcarc,x);
                        end
                        s.a = x;	
		elseif(button(1) == double('f'))
			disp(sprintf('%f %f',x,y));
                        if(outfile ~= ' ')
                            count = fprintf(outfile,'%32s, %7.3f, %9.3f, F\n',s_in.filename,s_in.gcarc,x);
                        end
                        s.a = x;	
		elseif(button(1) == double('l'))
			disp(sprintf('%f %f',x,y));
			s.a = x;
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
		elseif(button(1) == double('o'))
			if(iview > 1)
				iview = iview - 1;
				sxlim([lf(iview) rt(iview)]);
			end
		elseif(button(1) == double('z'))
			s.beg = s.beg - x;
			s.e   = s.e   - x;
			%
			%s.o   = s.o   - x;
			%s.a   = s.a   - x;
			%s.picks = s.picks - x;
			s.t = s.t - x;
			p1sac(s);
			disp(sprintf('shifting times by %f seconds',x));
		else
			[x,y, button(1), char(button(1))]
		end
	end
end
%
