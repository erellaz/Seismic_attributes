function [ col_wrap ] = circular_colormap( colmap )
% CIRCULAR_COLORMAP  makes any colormap circular for the pupose of
% displaying angles (azimuths) so +180 and -180 are the same continuous
% color.
col_wrap=vertcat(colmap,flipud(colmap));
colormap(col_wrap);
end

