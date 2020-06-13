%% Compute 3D median filter on a 3D cube
%Synopsis: F=median_filter(S); with S being a seismic cube and F the
%filtered data
function F=median_filter(S)
win=3;%this is half the 3D median window
wini=win; winj=win; wink=win;
sizea=(2*wini+1)*(2*winj+1)*(2*wink+1);%number of samples in the 3D surrounding minicube

[ni,nj,nk]=size(S);
F=zeros(size(S));


parfor j=winj+1:nj-(winj+1)
    task=getCurrentTask(); id(j)=task.ID;
    fprintf('Worker %i at position j=%i ---\n',id(j),j);
    for k=wink+1:nk-(wink+1)
            for i=wini+1:ni-(wini+1)
            % Here we are on a sample in the cube, and we look around in 3D 
            % for the median value
            count=1;
            a=zeros(sizea,1);
    
                for jj=-winj:1:winj
                    for kk=-wink:1:wink
                        for ii=-wini:1:wini
                        a(count)=S(i+ii,j+jj,k+kk);
                        count=count+1;
                        end %ii
                    end %kk
                end %jj
            
            F(i,j,k)=median(a); %median filter
         
            end %i
    end %k
end %j
