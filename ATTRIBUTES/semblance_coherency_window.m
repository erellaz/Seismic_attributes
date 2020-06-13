%% Compute semblance through coherence on a 3D cube
% Synopsis [C,P,Q]=semblance_coherency_window(S); 
% with S input seismic, C resulting semblance, P and Q dipscan result 
function [C,P,Q]=semblance_coherency_window(S)
%% Initialisation
[ni,nj,nk]=size(S);
C=zeros(size(S)); %Semblance through coherence
P=zeros(size(S)); %Inline dip
Q=zeros(size(S)); %xline dip
winj=1; %inline investigation window
wink=1; % xline investigation window
wini=17; % max time investigation window
wint=3; %time summation window

%% Looping on each sample in the cube, each dip and each search window 
%h = waitbar(0,'Computing Coherency Semblance...');
parfor j=winj+1:nj-(winj+1)
    %waitbar(j/(nj-(2*winj+2)))
    task=getCurrentTask(); id(j)=task.ID;
    fprintf('Worker %i at position j=%i ---\n',id(j),j);
    for k=wink+1:nk-(wink+1)
    %fprintf('At position j=%i k=%i\n',j,k);
            for i=wini+1:ni-(wini+1)
            %fprintf('At position i=%i j=%i k=%i\n',i,j,k);   
            %We are on one sample, looping on the 2 dips p and q, and 2
            %investigation windows
            maxval=0; maxvalp=0; maxvalq=0;
            for p=-0.0:.5:0.0
                for q=-0.0:.5:0.0
                    %we are on one sample, and have fixed the dips p and q
                    %summing now on the investigation window
                    sumw=0;
                    for w=-wint:wint
                        num=0; denum=0; count=0;
                        for m=-winj:winj
                            for n=-wink:wink
                              s=S(fix(i+w+m*p+n*q),j+m,k+n);
                              num=num+s;
                              denum=denum+s^2;
                              count=count+1;
                            end %n
                        end %m
                        num=num^2;
                        curval=num/(denum*count);
                        sumw=sumw+curval;
                    end %w
                    sumw=sumw/(2*wint+1);
                        if (sumw>maxval)
                            maxval=sumw; maxvalp=p; maxvalq=q;
                        end %if
                end %q
            end %p
            C(i,j,k)=maxval;
            P(i,j,k)=maxvalp;
            Q(i,j,k)=maxvalq;
            end %i
    end %k
end %j
