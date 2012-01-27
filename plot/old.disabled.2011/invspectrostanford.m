function a = invspectrostanford(b,hop,dbg)
%INVSPECTROGRAM Resynthesize a signal from its spectrogram.
%   A = INVSPECTROGRAM(B,NHOP)
%   B is a complex array of STFT values as generated by SPECTROGRAM.
%   The number of rows of B is taken to be the FFT size, NFFT.
%   INVSPECTROGRAM resynthesizes A by inverting each frame of the 
%   FFT in B, and overlap-adding them to the output array A.  
%   NHOP is the overlap-add offset between successive IFFT frames.
%
%   See also: SPECTROGRAM

if nargin<3, dbg=0; end

[nfft,nframes] = size(b);

No2 = nfft/2;

a = zeros(1, nfft+(nframes-1)*hop);

for col = 1:nframes
  fftframe = b(:,col);
  xzp = real(ifft(fftframe)); % zero phase
  x = [xzp(nfft-No2+1:nfft); xzp(1:No2)];
  ix = (col-1)*hop + [1:nfft];
  if dbg>=8, doplots(x,x,ix,a); end
  a(ix) = a(ix) + x';  % Overlap-add
end

function []=doplots(x,xw,ix,a);
figure(8);
subplot(4,1,1);
plot(ix,x);grid; ylabel('x');
set(gca,'YLim',[-1,1]);
subplot(4,1,2);
plot(ix,xw);grid; ylabel('xw');
set(gca,'YLim',[-1,1]);
subplot(4,1,3);
nx=length(x);
ix1=ix(1);
ia1 = ix1-nx;
% if ia1>=1, ia=[ia1:ix1-1,ix]; else ia=ix; end
% plot(ia,a(ia));grid;
plot(ix,a(ix));grid; ylabel('a(ix)');
set(gca,'YLim',[-1,1]);
subplot(4,1,4);
plot(a);grid; ylabel('a');
hold on; plot([ix1 ix1],YLim); hold off;
set(gca,'YLim',[-1,1]);
disp('*** PAUSING --- RETURN to continue'); pause;
