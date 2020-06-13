
%fist set the path to Seismic Lab, then:
presets;

% Read a segy: this is the F3 opensource dataset post stack distributed 
% with opendtect
seismic = read_segy_file('/Users/xxxxxxx/Opendetectroot/F3.sgy'); 
%panel=seismic.traces(1:176,1:1000);%take a slice of the cube

% Display the map of the headers, optional
%s_header_plot(seismic,{'cdp_x','cdp_y'},{'colors','ro'});

%calculating the size of the seismic cube in the 3 dimensions
%IlineSize=251; %width of the inline here 700 to 1200 every 2:251 200 to 650 every 2: 226
IlineSize=251;
[TSize,allpanel]=size (seismic.traces);
XlineSize=allpanel/IlineSize;

%display the size in the 3 dimensions
fprintf('Size of the cube:\n');
fprintf('Inline size %i\n',IlineSize);
fprintf('Xline size %i\n',XlineSize);
fprintf('Time size %i\n',TSize);

% %Doing some QC
% %Looking a particular inline
% n=100;%inline number
% panel=seismic.traces(1:176,(n*IlineSize)+1:(n+1)*IlineSize);%take a slice of the cube
% 
% %color display
% figure;
% imagesc(panel);
% 
% %gray scale display
% figure;
% min(min(panel))
% max(max(panel))
% imshow(panel, [-7000 7000])

%Load the data in a 3D structure
 last=XlineSize-1;
 for k=0:last
     S(:,:,k+1) =seismic.traces(1:TSize,((k*IlineSize)+1):((k+1)*IlineSize));
 end

%display iline, xline and timeslice for QC

% for i=1:50:IlineSize
% figure;
% ilineex(:,:)=S(:,i,:);
% imshow(ilineex,[-7000 7000]);
% end
% 
% for i=1:50:XlineSize
% figure;
% xlineex(:,:)=S(:,:,i);
% imshow(xlineex,[-7000 7000]);
% end
% 
% for i=1:30:TSize
% figure;
% tslicex(:,:)=S(i,:,:);
% imshow(tslicex,[-7000 7000]);
% end