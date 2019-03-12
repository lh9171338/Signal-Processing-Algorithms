function c = myrceps(x)
% MYRCEPS - Calculate the cepstrum
%
%   c = myrceps(x)

amp = abs(fft(x));
logamp = log(amp+eps);
c = real(ifft(logamp));