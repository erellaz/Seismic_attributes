%% Visualize 3D cube 
%Synopsis: view_cube(S,[100 120 125]);
function view_cube(A,slices)

h=slice(A,slices(1),slices(2),slices(3));
colormap(gray);
h(1).EdgeColor='none'; h(2).EdgeColor='none'; h(3).EdgeColor='none'; %h(4).EdgeColor='none';

view([30 -30]);