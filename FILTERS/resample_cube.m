%% Resample a 3D cube
%interpolate the cube in the fast dimension by a factor of p and decimate
%by a factor of q, applies antialias
%Synopsis R=resamplecube(S,1,2);
function R=resample_cube(S,p,q)
%% Input work
[ni,nj,nk]=size(S);%seize of the seismic cube
R=zeros([round(ni*p/q),nj,nk]);%resampled cube

%% Actual resampling
    parfor j=1:nj
        for k=1:nk
            %compare slice n with slice (n-1)x2 +1
            R(:,j,k)=resample(S(:,j,k),p,q); 
            %R(:,j,k)=idresamp(S(:,j,k),(q/p));
            %R(:,j,k)=S(1:2:ni,j,k); %no antialias fast decimation by 2
        end %k
    end %j

end

