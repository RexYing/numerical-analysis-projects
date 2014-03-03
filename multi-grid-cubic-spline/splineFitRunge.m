% splineFitRunge.m 
% script in an initial draft 
% 
% Purpose : 
% -- illustrate piecewise-polynomial interpolation with spline 
%          with samples on the Runge function 
% 
% Callee functions : 
% spline  (built-in) 
% ppval   (built-in) 
% runge   (provided) 
% 


%% ... begin 

clear all ; 
close all 


fprintf( '\n\n  splineFitRunge started \n '); 
   
  sType = 2 ; 
  
  n = 180 ; 
  r = 10 ; 

  %% ... set up the interpolation nodes and evaluation nodes 
  
  xnodes = linspace(-1,1, n+1)';         % equi-spaced sampling 
  ynodes = runge( xnodes ); 

  Xeval    = linspace(-1,1, r*n+1 )' ;   % make an odd # to show the midpoint
  FatXeval = runge( Xeval );

 %% ... get and evaluate the spline 
 
  
  switch sType 
      case 1 
         PatXeval = spline( xnodes, ynodes, Xeval ) ; 
      case 2  
         yprime = 50/26^2;    % end slopes of Runge for the clamped spline
         yprime = 0 ;         % for "natural" spline  
         Scoefs = spline( xnodes, [ yprime; ynodes; -yprime ] );
         PatXeval = ppval( Scoefs, Xeval ) ; 
      otherwise 
         error( ' unknown spline type ' ) 
  end
  
 %% ... error evaluation 
 
  ErrFit  = eps + norm( FatXeval - PatXeval, 'inf'); 
  ErrFit2 = eps + norm( FatXeval - PatXeval, 2)/sqrt(n);  % with n-scaling  

  fprintf( '\n  ErrInf = %0.3g', ErrFit ); 
  fprintf( '\n  Err2   = %0.3g', ErrFit2 );
    
  %% ... display the interpolation errs at the evaluation points 

  figure 
  
%  plot( Xeval, FatXeval, 'b.');
  plot( Xeval, FatXeval, 'b.', Xeval, PatXeval, 'm.');
  legend( 'Runge function', 'Spline interpolant', 'Location', 'Best');
  hold on 
%  plot( Xeval, FatXeval, 'b--'); 
  plot( Xeval, FatXeval, 'b--', Xeval, PatXeval, 'm--'); 
  hold off 
  
  xlabel( 'x' );
  bannerStr = sprintf( 'Spline interpolation', n); 
  title( bannerStr ); 

  
fprintf( '\n\n  splineFitRunge finished \n\n '); 

return 

% END of the script  

% --------------
% Xiaobai Sun  
% Duke CS
% for NA classes 
% ----------------

