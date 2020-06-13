%% Compute 3D median filter on a 3D cube
%Synopsis: F=threshold_filter(S); with S being an attribute cube and F the
%thresholded cube
function F=threshold_filter(S)
maxt=.9;
maxval=1;
mint=.01;
minval=0;

[ni,nj,nk]=size(S);
F=zeros(size(S));

parfor j=1:nj
    task=getCurrentTask(); id(j)=task.ID;
    fprintf('Worker %i at position j=%i ---\n',id(j),j);
    for k=1:nk
            for i=1:ni

                %very basic thresholding function
                if(S(i,j,k)>maxt)
                    F(i,j,k)=maxval;
                elseif(S(i,j,k)<mint)
                    F(i,j,k)=minval;
                else    
                    F(i,j,k)=S(i,j,k);
                end
            
            end %i
    end %k
end %j
