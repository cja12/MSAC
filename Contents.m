% MSAC1.5 Scripts
%
% A collection of scripts for manipulating SAC seismograms in MATLAB.
% Not all of these are complete or well tested. Use at your own risk.
%
% Author:	Charles J. Ammon, Saint Louis University / Penn State
% Developed: 	2000/2001/2017
%
% Author:	George E. Randall, LANL (Array processing functions)
% Developed: 	After 2000/2001
%
% IO Commands:
%
%	rsac		- Import a SAC file into a MATLAB structure.
%	wsac		- Export a SAC Structure from MATLAB to binary SAC.
%	wsac1		- Basic export with only a limited header.
%	sacheader	- returns an empy SAC structure (use it to set your own header values).
%
% Graphics:
%
%	psac		- plot one SAC seismogram structure.
%	p1sac		- plot an array of SAC seismograms structures in multiple panels.
%	p2sac		- plot an array of SAC seismograms structures in one panel.
%	sxlim		- set all the xlimits on a p1sac plot.
%	sylim		- set all the ylimits on a p1sac plot.
%	psac_stem	- plot one SAC seismogram structure as a stem plot.
%	sylabel		- Set all the ylabels on a p1sac plot
%	sxdiv		- set the xdivisions for the plot
%	sydiv		- set the xdivisions for the plot
%	sgrid		- turn the grid on a set of plots
%	p1persac	- plot an array of SAC structures in a sequence of plots
%	ppksac		- basic cursor picking features
%
% Filtering commands:
%
%	hpfilter	- Highpass filter the signal (Butterworth).
%	lpfilter	-  Lowpass filter the signal (Butterworth).
%	srgfilter	- Frequency-Domain convolution with a Rftn Gaussian filter.
%	strifilter	- Frequency-Domain convolution with a Triangle filter.
%	sswgfilter	- Frequency-Domain convolution with a surface-wave Gaussian filter.
%
% General Processing Commands:
%
%	srmean		- Remove the mean from the seismogram.
%	sdif		- Differentiate the seismogram.
%	sint		- Integrate the seismogram.
%	scut		- Cut a SAC seismogram structure.
%	staper		- Taper the seismogram file with a cosine taper.
%	scentroid	- Compute the centroid of a SAC seismogram structure.
%	shilbert	- Compute the Hilbert transform of a SAC seismogram structure.
%	senvelope	- Compute the envelope of a SAC seismogram structure.
%
% Spectral Commands:
%
%	sfft		- Compute and return the FFT of a SAC Structure.
%	spfft		- Compute and plot a SAC Structure's Amplitude Spectrum.
%	sconv		- Frequency Domain convolution of two SAC structures.
%	sccor		- Cross-correlation of two SAC structures.
%
% Deconvolution Scripts:
%
%	wlevel		- Deconvolve a SAC structure from another with water-level method.
%	tdecon		- Time-domain deconvolution.
%	tridecon	- Time-domain deconvolution with triangular basis functions.
%	iterdecon	- Iterative time-domain deconvolution.
%
