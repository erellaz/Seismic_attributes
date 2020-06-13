%% Post stack pattern removal on a 3D cube through kk filterlength
function P=pattern_filter(S,filterlength)
%% Input work
[ni,nj,nk]=size(S);%seize of the seismic cube
P=zeros(size(S));%pattern filtered cube
%filterlength=12; %percent of the data that will survive the filter in the fk domain
lj=floor(nj*filterlength/100); %number of samples to preserve in j direction
lk=floor(nk*filterlength/100);%number of samples to preserve in j direction
fprintf('Filter length: %i %i\n',lj,lk);

%% Some QC of the input
% for i=1:50:nj figure; ilineex(:,:)=S(:,i,:); imshow(ilineex,[-7000 7000]); end
% for i=1:50:nk figure; xlineex(:,:)=S(:,:,i); imshow(xlineex,[-7000 7000]); end
% for i=1:30:ni figure; tslicex(:,:)=S(i,:,:); imshow(tslicex,[-7000 7000]); end

%% step by step work on just one slice
% before(:,:)=S(50,:,:);
% imagesc(before);
% figure;
% 
% fftmag(:,:)=abs(fft2(S(50,:,:)));
% imagesc(fftmag);
% figure;
% 
% % fftangle(:,:)=angle(fft2(S(50,:,:)));
% % imagesc(fftangle);
% % figure;
% 
% slice(:,:)=S(50,:,:);
% freqpan=fft2(slice);
% for i=40:211
%    freqpan(i,:)=freqpan(i,:)/1000000;
% end
% 
% for j=30:196
%    freqpan(:,j)=freqpan(:,j)/1000000;
% end
% 
% filterlengthfft(:,:)=abs(freqpan);
% imagesc(filterlengthfft);
% figure;
% 
% timeagain(:,:)=real(ifft2(freqpan));
% imagesc(timeagain);

%% Actual 3D tkk filter
    for i=1:ni
    %fprintf('Slice %i\n',i);
    slice(:,:)=S(i,:,:);
    freqpan=fft2(slice);

            % Mute of the complex kk plane
            for j=lj:(ni-lj)
               freqpan(j,:)=freqpan(j,:)/1000000;
            end

            for k=lk:(nk-lk)
               freqpan(:,k)=freqpan(:,k)/1000000;
            end

    timeagain(:,:)=real(ifft2(freqpan));
    P(i,:,:)=timeagain(:,:);
    end

%% Look at the results    
%Szslice(:,:)=S(20,:,:);
%Fzslice(:,:)=P(20,:,:);
%figure; imshow(Szslice,[-7000 7000]); 
%figure; imshow(Fzslice,[-7000 7000]);

%viewf(S,P);
end

